<?xml version="1.0" encoding="UTF-8"?>
<!--
  Copyright 2002-2004 The Apache Software Foundation

  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at

      http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.
-->
<forrest:contract name="txt-fct" nc="txt" tlc="content"
  xmlns:forrest="http://apache.org/forrest/templates/1.0">
  <description>
    This functions will output the TXT link with image and print link.
  </description>

	<xsl:stylesheet version="1.1" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	  <xsl:template name="txt" mode="xhtml-head">
	    <head/>
	  </xsl:template>
	  
	  <xsl:template name="txt" mode="xhtml-body">
<body>
      <script type="text/javascript" language="Javascript">
function printit() {
  if (window.print) {
    window.focus();
    window.print();
  }
}
        </script>

        <script type="text/javascript" language="Javascript">
var NS = (navigator.appName == "Netscape");
var VERSION = parseInt(navigator.appVersion);
if (VERSION > 3) {
  document.write('<div class="txt" title="Print this Page">');
  document.write('  <a href="javascript:printit()" class="dida">');
  document.write('    <img class="skin" src="{$skin-img-dir}/printer.gif" alt="print - icon" />');
  document.write('    <br />');
  document.write('  PRINT</a>');
  document.write('</div>');
}
        </script>
    </body>
	  </xsl:template>
	
	</xsl:stylesheet>
</forrest:contract>