<?xml version="1.0"?>
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
<!--
site2xhtml.xsl is the final stage in HTML page production.  It merges HTML from
document2html.xsl, tab2menu.xsl and book2menu.xsl, and adds the site header,
footer, searchbar, css etc.  As input, it takes XML of the form:

<site>
  <div class="menu">
    ...
  </div>
  <div class="tab">
    ...
  </div>
  <div class="content">
    ...
  </div>
</site>

$Id: site2xhtml.xsl,v 1.4 2004/01/28 21:23:20 brondsem Exp $
-->

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:import href="../../../common/xslt/html/site2xhtml.xsl"/>

  <xsl:variable name="header-color" select="'#FFFFFF'"/>
  <xsl:variable name="header-color2" select="'#a5b6c6'"/>
  <xsl:variable name="menu-border" select="'#F7F7F7'"/>
  <xsl:variable name="background-bars" select="'#CFDCED'"/>


  <xsl:template match="site">
    <html>
      <head>
        <title><xsl:value-of select="div[@class='content']/h1"/></title>
        <link rel="stylesheet" href="{$root}skin/page.css" type="text/css"/>
        <link rel="alternate stylesheet" title="Krysalis" href="{$root}skin/krysalis.css" type="text/css"/>
        <xsl:if test="$config/favicon-url">
          <link rel="shortcut icon">
            <xsl:attribute name="href">
              <xsl:value-of select="concat($root,$config/favicon-url)"/>
            </xsl:attribute>
          </link>
        </xsl:if>
      </head>
      <body>
      	<div id="toplinks">
		   <xsl:call-template name="breadcrumbs"/>
		</div>
		
        <!-- ================= start Banner ================== -->
   	    <div id="mainheader">
	          <!-- ================= start Group Logo ================== -->
	          <xsl:if test="$config/group-url">
	  	      	<xsl:call-template name="renderlogo">
		        	<xsl:with-param name="name" select="$config/group-name"/>
		            <xsl:with-param name="url" select="$config/group-url"/>
		            <xsl:with-param name="logo" select="$config/group-logo"/>
		            <xsl:with-param name="root" select="$root"/>
		            <xsl:with-param name="imgid">grouplogo</xsl:with-param>
		            <xsl:with-param name="linkid">grouplogolink</xsl:with-param>
		          </xsl:call-template>
		      </xsl:if>
	          <!-- ================= end Group Logo ================== -->
	          <span class="textonly"> - </span>
	          <!-- ================= start Search ================== -->
	          <xsl:if test="$config/search">
	              <xsl:choose>
		          <xsl:when test="$config/search/@provider = 'lucene'">
                              <!-- Lucene search -->
                              <form method="get" action="{$root}{$lucene-search}">
     	                          <span id="search">
		                      <input type="text" class="query" name="queryString"/>
		                      <input type="submit" value="Search"/>
		                      <br />
		                      <span class="searchtext">
		                          the <xsl:value-of select="$config/search/@name"/> site
		                      </span>
		                  </span>
		              </form>
		          </xsl:when>
                          <xsl:otherwise>
                              <!-- Google search -->
                              <form method="get" action="http://www.google.com/search">
	                          <span id="search">
		                      <input type="hidden" name="as_sitesearch" value="{$config/search/@domain}"/>
		                      <input type="text" class="query" name="as_q"/>
		                      <input type="submit" value="Search"/>
		                      <br />
		                      <span class="searchtext">
		                          the <xsl:value-of select="$config/search/@name"/> site
		                      </span>
		                  </span>
		              </form>
		          </xsl:otherwise>
	              </xsl:choose>
	          </xsl:if>
	          <!-- ================= end Search ================== -->
			  <span class="textonly"> - </span>
	          <!-- ================= start Project Logo ================== -->
	          <xsl:if test="$config/project-url">
	              <xsl:call-template name="renderlogo">
	                <xsl:with-param name="name" select="$config/project-name"/>
	                <xsl:with-param name="url" select="$config/project-url"/>
	                <xsl:with-param name="logo" select="$config/project-logo"/>
	                <xsl:with-param name="root" select="$root"/>
		            <xsl:with-param name="imgid">projectlogo</xsl:with-param>
		            <xsl:with-param name="linkid">projectlogolink</xsl:with-param>
	              </xsl:call-template>
	          </xsl:if>
	          <!-- ================= end Project Logo ================== -->
	        </div>    
		
		<hr class="textonly"/>

        <!-- ================= start Content================== -->
        <xsl:apply-templates select="div[@class='content']"/>
        <!-- ================= end Content================== -->

		<hr class="textonly"/>

		<div id="nav">
	        <!-- ================= start Tabs ================== -->
	        <xsl:apply-templates select="div[@id='tabs']"/>
	        <!-- ================= end Tabs ================== -->
	
	        <!-- ================= end Banner ================== -->
	
	        <div class="navsection">
	        	<xsl:for-each select = "div[@class='menu']/ul/li">
	              <xsl:call-template name = "innermenuli" />
	            </xsl:for-each>
	        </div>
	    </div>

		<p class="textonly"/>
		<hr class="textonly"/>

        <!-- ================= start Footer ================== -->
        <div id="footer">
			<a href="{$skin-img-dir}/label.gif"/>
			<a href="{$skin-img-dir}/page.gif"/>
			<a href="{$skin-img-dir}/chapter.gif"/>
			<a href="{$skin-img-dir}/chapter_open.gif"/>
			<a href="{$skin-img-dir}/current.gif"/>
			<span id="copyright">
				<xsl:choose>
					<xsl:when test="$config/copyright-link">
						<a>
							<xsl:attribute name="href">
								<xsl:value-of select="$config/copyright-link"/>
							</xsl:attribute>
							Copyright &#169; <xsl:value-of select="$config/year"/>&#160;<xsl:value-of select="$config/vendor"/>
						</a>
					</xsl:when>
					<xsl:otherwise>
						Copyright &#169; <xsl:value-of select="$config/year"/>&#160;<xsl:value-of select="$config/vendor"/>
					</xsl:otherwise>
				</xsl:choose>
				All rights reserved.
			</span>
			<br class="textonly"/>
			<span id="revision"><script language="JavaScript" type="text/javascript"><![CDATA[<!--
			  document.write(" - "+"Last Published: " + document.lastModified);
			  //  -->]]></script>
			</span>
			<br class="textonly"/>
	
	        <xsl:if test="$config/host-logo and not($config/host-logo = '')">
	          <div class="host">
	            <img src="{$root}skin/images/spacer.gif" width="10" height="1" alt=""/>
	            <xsl:call-template name="renderlogo">
	              <xsl:with-param name="name" select="$config/host-name"/>
	              <xsl:with-param name="url" select="$config/host-url"/>
	              <xsl:with-param name="logo" select="$config/host-logo"/>
	              <xsl:with-param name="root" select="$root"/>
	            </xsl:call-template>
	          </div>
	        </xsl:if>
	
			<span id="validation">
	        	<xsl:call-template name="compliancy-logos"/>
		        <xsl:if test="$filename = 'index.html' and $config/credits">
		            <xsl:for-each select="$config/credits/credit[not(@role='pdf')]">
		              <xsl:variable name="name" select="name"/>
		              <xsl:variable name="url" select="url"/>
		              <xsl:variable name="image" select="image"/>
		              <xsl:variable name="width" select="width"/>
		              <xsl:variable name="height" select="height"/>
		              <a href="{$url}">
		                <img alt="{$name} logo" border="0">
		                  <xsl:attribute name="src">
		                    <xsl:if test="not(starts-with($image, 'http://'))"><xsl:value-of select="$root"/></xsl:if>
		                    <xsl:value-of select="$image"/>
		                  </xsl:attribute>
		                  <xsl:if test="$width"><xsl:attribute name="width"><xsl:value-of select="$width"/></xsl:attribute></xsl:if>
		                  <xsl:if test="$height"><xsl:attribute name="height"><xsl:value-of select="$height"/></xsl:attribute></xsl:if>
		                </img>
		                <img src="{$spacer}" border="0" alt="" width="5" height="1" />
		              </a>
		            </xsl:for-each>
		        </xsl:if>
		    </span>
	    </div>
        <!-- ================= end Footer ================== -->
      </body>
    </html>
  </xsl:template>


  <xsl:template name="innermenuli">
    <h3 class="navsectionheader"><xsl:value-of select="font"/><span class="textonly">:</span></h3>
  	<xsl:for-each select= "ul/li">
		<xsl:choose>
        	<xsl:when test="a">
            	<a href="{a/@href}" class="navitem"><xsl:value-of select="a" /></a>
            </xsl:when>
            <xsl:when test="span/@class='sel'">
                <span class="navitem"><xsl:value-of select="span" /></span>
            </xsl:when>
            <xsl:otherwise>
              <xsl:call-template name = "innermenuli" />
            </xsl:otherwise>
          </xsl:choose>
          <span class="textonly">-</span>
  	</xsl:for-each>
  </xsl:template>

  <xsl:template name="renderlogo">
    <xsl:param name="name"/>
    <xsl:param name="url"/>
    <xsl:param name="logo"/>
    <xsl:param name="width"/>
    <xsl:param name="height"/>
    <xsl:param name="root"/>
    <xsl:param name="linkid"/>
    <xsl:param name="imgid"/>
    <a href="{$url}">
    	<xsl:if test="$linkid and not($linkid = '')">
    		<xsl:attribute name="id">
    			<xsl:value-of select="$linkid"/>
    		</xsl:attribute>
    	</xsl:if>
      	<xsl:choose>
        	<xsl:when test="$logo and not($logo = '')">
          		<img alt="{$name}">
            		<xsl:attribute name="src">
		      			<xsl:if test="not(starts-with($logo, 'http://'))">
		      				<xsl:value-of select="$root"/>
		      			</xsl:if>
	              		<xsl:value-of select="$logo"/>
            		</xsl:attribute>
            		<xsl:if test="$width">
              			<xsl:attribute name="width">
              				<xsl:value-of select="$width"/>
              			</xsl:attribute>
            		</xsl:if>
            		<xsl:if test="$height">
              			<xsl:attribute name="height">
              				<xsl:value-of select="$height"/>
              			</xsl:attribute>
            		</xsl:if>
            		<xsl:if test="$imgid and not ($imgid='')">
            			<xsl:attribute name="id">
            				<xsl:value-of select="$imgid" />
            			</xsl:attribute>
            		</xsl:if>
	  			</img>
        	</xsl:when>
       		<xsl:otherwise><xsl:value-of select="$name"/></xsl:otherwise>
		</xsl:choose>
    </a>
  </xsl:template>
  
  <xsl:template match="node()|@*" priority="-1">
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template>
   

</xsl:stylesheet>
