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
package org.apache.forrest.plugin.api;

import java.net.URI;

import org.apache.forrest.log.LogPlugin.LOG;
import org.osgi.framework.BundleContext;

/**
 * Base implementation for input plugins. Input plugins override
 * {@link #getSource(URI)}.
 */
public class BaseInputPlugin extends AbstractPlugin {

  /**
   * Constructs a <code>BaseInputPlugin</code>
   * with the given {@link BundleContext}.
   *
   * @param context this bundle's context within the framework
   */
  public BaseInputPlugin(final BundleContext context) {
    super(context);
  }

  /**
   * Returns a <code>ForrestSource</code> object to access
   * the given <code>URI</code> and represent the internal format.
   * <p>
   * Input plugins must override this method.
   * <p>
   * The base implementation returns null.
   *
   * @param uri the source <code>URI</code>
   * @return the <code>ForrestSource</code> representing the source object
   */
  public ForrestSource getSource(URI uri) {
    LOG.debug("BaseInputPlugin.getSource() must be implemented by a plugin, ignoring");

    return null;
  }

  /**
   * Input plugins do not implement this method. The base
   * implementation returns null.
   *
   * @param source the <code>ForrestSource</code> representing the source object
   * @return null
   */
  public final ForrestResult transform(ForrestSource source) {
    LOG.debug("transform() called on an input plugin, ignoring");

    return null;
  }

}
