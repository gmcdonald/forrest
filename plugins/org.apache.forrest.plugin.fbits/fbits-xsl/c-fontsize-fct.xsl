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
<forrest:contract name="fontsize-fct" nc="fontsize" tlc="content"
  xmlns:forrest="http://apache.org/forrest/templates/1.0">
  <description>
    This functions lets you change the size of the font you are using in the site with a jscript.
  </description>

	<xsl:stylesheet version="1.1" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	  <xsl:template name="fontsize" mode="xhtml-head">
	    <head>
	      <script type="text/javascript" language="javascript" 
	        src="{$root}skin/fontsize.js"></script>
	    </head>
	  </xsl:template>
	  
	  <xsl:template name="fontsize" mode="xhtml-body">
			<body onload="init()">
	      <script type="text/javascript">ndeSetTextSize();</script>
	      <div class="trail">
	            Font size: 
	              &#160;<input type="button" onclick="ndeSetTextSize('reset'); return false;" title="Reset text" class="resetfont" value="Reset"/>      
	              &#160;<input type="button" onclick="ndeSetTextSize('decr'); return false;" title="Shrink text" class="smallerfont" value="-a"/>
	              &#160;<input type="button" onclick="ndeSetTextSize('incr'); return false;" title="Enlarge text" class="biggerfont" value="+a"/>
	      </div>
	    </body>
	  </xsl:template>
	
	</xsl:stylesheet>
</forrest:contract>