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
import java.net.URI;

/**
 * A representation of an XML document.
 * 
 * @FIXME: at this time this is nothing more than a simple string representation
 *         of the document
 */
public class XMLSourceDocument extends DefaultSourceDocument {

	public XMLSourceDocument(final URI requestURI, final String fileData,
			final BufferedReader reader, final String type) {
		super(requestURI, fileData, reader, type);
	}

	public XMLSourceDocument(final URI requestURI, final String content, final String type) {
		super(requestURI, content, type);
	}

}
