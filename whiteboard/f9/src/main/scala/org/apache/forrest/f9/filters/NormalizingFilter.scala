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
package org.apache.forrest.f9.filters

import scala.xml.Node
import scala.xml.Document

class NormalizingFilter extends Filter {
 	def process(model: Map[String, Any]) = {
 		println("Normalized Content: " + model("requestUri"))
 		
 		//Cheat and assume input is Forrest internal format.
 		val d = XDocTransformer(model("entityBody").asInstanceOf[Document].docElem)
       println("Done forwarding now.")
	  model + ("entityBody"->d)
	}
}