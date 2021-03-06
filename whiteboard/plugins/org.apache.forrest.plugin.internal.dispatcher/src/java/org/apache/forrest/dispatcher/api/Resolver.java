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
package org.apache.forrest.dispatcher.api;

import java.io.InputStream;

import org.apache.forrest.dispatcher.exception.DispatcherException;

/**
 * Wrapper interface to enable multible resolver implementation this makes it
 * possible to use the dispatcher outside of cocoon as standalone application
 * without any mayor rewrites.
 * 
 * @version 1.0
 * 
 */
public interface Resolver {

  /**
   * A resolver simply looks up a given uri and tries to generate a stream
   * from it.
   * 
   * @param uri the uri that we want
   * @return the stream representation of the uri.
   * @throws DispatcherException 
   */
  InputStream resolve(String uri) throws DispatcherException;

}
