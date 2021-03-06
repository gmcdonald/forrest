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

import java.util.Set;

/**
 * An output document is a single document that has been processed by Forrest
 * and is now ready to be returned to the client.
 */
public abstract class AbstractOutputDocument extends AbstractDocument {


	/**
	 * Get a set of links to local documents in within this
	 * document. This is used to identify links that should
	 * be crawled when generating content.
	 * 
	 * @return
	 */
	public abstract Set<String> getLocalDocumentLinks();

	/**
	 * Get the the relative path to this document from the
	 * point of view of the client.
	 * 
	 * @return
	 */
	public String getPath() {
		return getRequestURI().getPath();
	}

	/**
	 * Get a value from this document as defined by a
	 * XPath statement.
	 * 
	 * @param xpath
	 */
	public String getValue(String xpath) {
		return "FIXME: imple ment getValue(xpath) method in AbstractOutputDocument";
	}

}
