/*
 * Licensed to the Apache Software Foundation (ASF) under one or more
 * contributor license agreements.  See the NOTICE file distributed with
 * this work for additional information regarding copyright ownership.
 * The ASF licenses this file to You under the Apache License, Version 2.0
 * (the "License"); you may not use this file except in compliance with
 * the License.  You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package org.apache.forrest.core.document;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.URI;
import java.net.URL;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.forrest.core.IController;
import org.apache.forrest.core.exception.ProcessingException;

/**
 * The document factory creates instances of various types of document.
 * 
 */
public class DocumentFactory {
	
	static Log log = LogFactory.getLog(DocumentFactory.class);

	/**
	 * Reads as much of the supplied input stream as needed in order to identify
	 * the type of document that should be created. Then it creates the document
	 * and returns it.
	 * 
	 * @FIXME At present the whole file is read
	 * 
	 * @param is
	 * @return
	 * @throws IOException
	 *             If there is a problem reading the document content from the
	 *             InputStream
	 * @throws ProcessingException 
	 */
	public static AbstractSourceDocument getSourceDocumentFor(final URL sourceURL, final URI requestURI, 
			final InputStream is) throws IOException, ProcessingException {
		return readFile(sourceURL, requestURI, is);
	}

	/**
	 * Read a string from an InputStream. Each time a chunk of the file is read
	 * we try and work out what type of document we have. Once we know what it
	 * is we return an IDocument instance that contains the data read so far and
	 * the reader used to read the rest of the data.
	 * 
	 * @param is
	 * @throws ProcessingException 
	 */
	private static AbstractSourceDocument readFile(final URL sourceURL, final URI requestURI, final InputStream is)
			throws java.io.IOException, ProcessingException {
		AbstractSourceDocument doc = null;
		final StringBuffer fileData = new StringBuffer(1024);
		final BufferedReader reader = new BufferedReader(new InputStreamReader(
				is));
		char[] buf = new char[1000];
		int numRead = 0;
		String type = null;
		while (type == null && (numRead = reader.read(buf)) != -1) {
			final String readData = String.valueOf(buf, 0, numRead);
			fileData.append(readData);
			buf = new char[1024];
			if (fileData.toString().contains("<?xml")) {
				type = getXMLDocumentType(fileData.toString());
				if (type != null) {
					doc = new XMLSourceDocument(requestURI, fileData.toString(), reader,
							type);
				}
			}
		}
		if (type == null) {
			if (fileData.toString().contains("<?xml")) {
				doc = new XMLSourceDocument(requestURI, fileData.toString(), reader,
						"application/xml");
			} else if (fileData.toString().toLowerCase().contains("<html>")) {
				doc = new DefaultSourceDocument(requestURI, fileData.toString(), reader,
						"html");
			} else {
				String file = sourceURL.getFile();
				String ext = file.substring(file.lastIndexOf(".") + 1);
				log.warn("We don't know the document type, so using source file extension: " + ext);
				doc = new DefaultSourceDocument(requestURI, fileData.toString(), reader,
				ext);
			}
		}
		return doc;
	}

	/**
	 * Given a string that identifies the start of an XML document we look ahead
	 * to see if there is a Doctype or a namespace definition that enables to
	 * narrow down the type of XML document this is. If there is no clue to the
	 * specific type of XML document we return null.
	 * 
	 * See http://www.ietf.org/rfc/rfc3023.txt for more inforamtion about XML
	 * mime types and how to identify them.
	 * 
	 * @param string
	 * @return
	 */
	private static String getXMLDocumentType(final String content) {
		String type = null;
		if (content.contains("http://www.w3.org/2002/06/xhtml2")) {
			type = "org.w3c.xhtml2";
		} else if (content.contains("http://forrest.apache.org/helloWorld.dtd")) {
			type = "org.apache.forrest.hellowWorld";
		} else if (content.contains("http://forrest.apache.org/dtd/document-v20.dtd")) {
			type = "org.apache.forrest.xdoc2";
		} else if (content.contains("http://forrest.apache.org/dtd/document-v20.dtd")) {
			type = "org.apache.forrest.xdoc2";
		} else if (content.contains("<site")) {
			type = "org.apache.forrest.site";
		}
		return type;
	}
}
