/*
 * Licensed to the Apache Software Foundation (ASF) under one or more
 * contributor license agreements.  See the NOTICE file distributed with
 * this work for additional information regarding copyright ownership.
 * The ASF licenses this file to You under the Apache License, Version 2.0
 * (the "License"); you may not use this file except in compliance with
 * the License.  You may obtain a copy of the License at
 * 
 *      http://www.apache.org/licenses/LICENSE-2.0
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package org.apache.forrest.http;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.net.URI;
import java.util.Arrays;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.forrest.log.LogPlugin.LOG;
import org.apache.forrest.plugin.api.ForrestPlugin;
import org.apache.forrest.plugin.api.ForrestResult;
import org.apache.forrest.util.ContentType;
import org.osgi.framework.BundleContext;
import org.osgi.framework.Constants;
import org.osgi.framework.Filter;
import org.osgi.framework.InvalidSyntaxException;
import org.osgi.framework.ServiceReference;
import org.osgi.util.tracker.ServiceTracker;
import org.osgi.util.tracker.ServiceTrackerCustomizer;

/**
 * Implements the main Forrest servlet.
 */
public class ForrestServlet extends HttpServlet {

  private static final long serialVersionUID = 3575916939233594893L;

  /**
   * Stores reference to {@link BundleContext} to enable communication
   * with the framework. Needed to create local {@link ServiceTracker}s
   * and {@link Filter}s.
   */
  private BundleContext mBundleContext;

  /**
   * Tracks registered input plugins.
   */
  private ServiceTracker mInputPluginTracker;

  /**
   * Tracks registered output plugins.
   */
  private ServiceTracker mOutputPluginTracker;

  /**
   * Constructs a servlet with the given context.
   *
   * @param context this bundle's context within the framework
   *
   * @see ServiceTracker#ServiceTracker(BundleContext, Filter, ServiceTrackerCustomizer)
   * @see BundleContext#createFilter(String)
   */
  public ForrestServlet(final BundleContext context) {
    mBundleContext = context;

    try {
      // track input plugins
      mInputPluginTracker = buildPluginTracker(ForrestPlugin.TYPE_INPUT);
      mInputPluginTracker.open();

      // track output plugins
      mOutputPluginTracker = buildPluginTracker(ForrestPlugin.TYPE_OUTPUT);
      mOutputPluginTracker.open();
    } catch (InvalidSyntaxException ise) {
      // TODO handle failure with grace
      LOG.debug("Failed to track plugins: " + ise);
    }
  }

  private ServiceTracker buildPluginTracker(String type) throws InvalidSyntaxException {
    String filterFormat = new StringBuilder()
      .append("(&(")
      .append(Constants.OBJECTCLASS)
      .append("=").append(ForrestPlugin.class.getName()).append(")")
      .append("(pluginType=%s))").toString();

    String filterString = String.format(filterFormat, type);
    LOG.debug("Building service tracker with LDAP filter: " + filterString);

    Filter filter = mBundleContext.createFilter(filterString);

    return new  ServiceTracker(mBundleContext, filter, null);
  }

  @Override
  protected void doGet(HttpServletRequest req, HttpServletResponse resp)
    throws ServletException, IOException {

    String pathInfo = req.getPathInfo();
    LOG.debug("doGet: " + pathInfo);
    File rootPath = new File(System.getProperty("project.home"),
                             System.getProperty("project.xdocs-dir"));
    LOG.debug("project.xdocs-dir: " + rootPath.getAbsolutePath());

    if (!rootPath.canRead()) {
      // not much to do if the source area is not readable
      resp.sendError(resp.SC_INTERNAL_SERVER_ERROR);

      return;
    }

    LOG.debug("Can read " + rootPath.getAbsolutePath());
    File source = new File(rootPath, pathInfo);

    if (source.canRead()) {
      // source exists on disk and is readable
      LOG.debug("Can read " + source.getAbsolutePath());
      doFileResponse(req, resp, source);

      return;
    }

    // source does not exist on disk or is not readable
    LOG.debug("Cannot read " + source.getAbsolutePath());

    File[] files = source.getParentFile().listFiles();
    Arrays.sort(files);

    String sourceName = source.getName();
    int sourceExtension = sourceName.lastIndexOf(".");
    String sourceBasename = null;

    if (sourceExtension > 0) {
      sourceBasename = sourceName.substring(0, sourceExtension);
    }

    boolean foundMatch = false;
    String name = null;
    URI sourceUri = null;

    for (int i = 0; i < files.length; i++) {
      name = files[i].getName();

      // exclude certain files from consideration
      if (!name.endsWith("~")) {
        int extension = name.lastIndexOf(".");

        if (extension > 0) {
          String base = name.substring(0, extension);
          LOG.debug(name + " --> " + base);

          if (base.equals(sourceBasename)) {
            foundMatch = true;
            sourceUri = files[i].toURI();
            break;
          }
        }
      }
    }

    if (foundMatch) {
      String requestUri = req.getRequestURI();
      String sourceFormat = name;
      String logMsg = "transform input " + sourceFormat + " into output " + requestUri;

      LOG.debug(logMsg);

      String pluginType;

      // is there support for the requested output format?
      ForrestPlugin outputPlugin = null;

      if (null != mOutputPluginTracker) {
        ServiceReference[] outRefs = mOutputPluginTracker.getServiceReferences();

        if (null != outRefs) {
          for (int i = 0; i < outRefs.length; i++) {
            // XXX use property name, something like PROP_CONTENT_TYPE
            pluginType = (String) outRefs[i].getProperty("contentType");
            LOG.debug("Found an output plugin for format: " + pluginType);

            if (null != pluginType
                && pluginType.equals
                (ContentType.getContentTypeByName(requestUri))) {
              LOG.debug("It's a match. Transform it.");

              outputPlugin = (ForrestPlugin) mOutputPluginTracker.getService(outRefs[i]);
              break;
            } else {
              LOG.debug("Skipping " + pluginType + " format for " + ContentType.getContentTypeByName(requestUri));
            }
          }
        } else {
          LOG.debug("List of output plugins is null");
        }
      }

      // is there support for the source format?
      ForrestPlugin inputPlugin = null;

      if (null != mInputPluginTracker) {
        ServiceReference[] inRefs = mInputPluginTracker.getServiceReferences();

        if (null != inRefs) {
          for (int i = 0; i < inRefs.length; i++) {
            // XXX use property, something like PROP_CONTENT_TYPE
            pluginType = (String) inRefs[i].getProperty("contentType");
            LOG.debug("Found an input plugin for format: " + pluginType);

            if (null != pluginType
                && pluginType.equals
                (ContentType.getContentTypeByName(sourceFormat))) {
              LOG.debug("It's a match. Transform it.");

              inputPlugin = (ForrestPlugin) mInputPluginTracker.getService(inRefs[i]);
              break;
            } else {
              LOG.debug("Skipping " + pluginType + " format for "
                        + ContentType.getContentTypeByName(sourceFormat));
            }
          }
        } else {
          LOG.debug("List of input plugins is null");
        }
      }

      if (null != outputPlugin && null != inputPlugin) {
        resp.setContentType
          (ContentType.getContentTypeByName(requestUri));

        ForrestResult result = outputPlugin.transform(inputPlugin.getSource(sourceUri));
        if (null != result) {
          resp.getWriter().println(result.getResultAsString());
        }

        return;
      }
    }

    // no source found for requested output format
    resp.sendError(resp.SC_NOT_FOUND);
  }

  private void doFileResponse(HttpServletRequest req,
                              HttpServletResponse resp, File source) throws IOException {
    // source exists and is readable
    if (source.isFile()) {
      try {
        String contentType = ContentType.getContentTypeByName(source);

        if (null != contentType) {
          resp.setContentType(contentType);
          BufferedReader reader = new BufferedReader(new FileReader(source));
          String line;

          do {
            line = reader.readLine();

            if (null != line) {
              resp.getWriter().println(line);
            }
          } while (null != line);

          reader.close();
        }
      } catch (IOException e) {
        e.printStackTrace();
      }
    } else if (isDirectory(source.getName())) {
      // TODO: use a property here for index file name
      resp.sendRedirect(redirectTo(req.getPathInfo(), "index.html"));
    }
  }

  private boolean isDirectory(String path) {
    if (path.endsWith("/")) {
      return true;
    }

    // TODO: raw content location is not considered
    File file = new File(System.getProperty("project.xdocs-dir"), path);

    return file.isDirectory();
  }

  private String redirectTo(String path, String index) {
    return path + (path.endsWith("/") ? "" : "/") + index;
  }

  @Override
  public void destroy() {
    mInputPluginTracker.close();
    mOutputPluginTracker.close();
    mBundleContext = null;
  }

}
