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

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
                version="1.0">

  <!-- the skinconf file -->
  <xsl:variable name="config" select="//skinconfig"/>
  <!-- Get the section depth to use when generating the minitoc (default is 2) -->
  <xsl:variable name="toc-max-depth" select="number($config/toc/@max-depth)"/>

  <!-- The page size to be used -->
  <xsl:variable name="pagesize" 
                select="string($config/pdf/page/@size)"/>

  <!-- The page orientation ("portrait" or "landscape") -->
  <xsl:variable name="pageorientation" 
                select="string($config/pdf/page/@orientation)"/>

  <!-- Double-sided printing toggle -->
  <xsl:variable name="doublesided"
                select="string($config/pdf/margins/@double-sided)"/>

  <!-- The top page margin -->
  <xsl:variable name="topmargin"
                select="string($config/pdf/margins/top)"/>

  <!-- The bottom page margin -->
  <xsl:variable name="bottommargin"
                select="string($config/pdf/margins/bottom)"/>

  <!-- The inner page margin (always the left margin if
  double-sided printing is off, alternating between left and right if
  it's on) -->
  <xsl:variable name="innermargin"
                select="string($config/pdf/margins/inner)"/>

  <!-- The outer page margin (always the right margin if
  double-sided printing is off, alternating between right and left if
  it's on)-->
  <xsl:variable name="outermargin"
                select="string($config/pdf/margins/outer)"/>
  

  <xsl:param name="numbersections" select="'true'"/>

  <!-- Section depth at which we stop numbering and just indent -->
  <xsl:param name="numbering-max-depth" select="'3'"/>
  <xsl:param name="imagesdir" select="."/>
  <xsl:param name="xmlbasedir"/>
  <xsl:include href="pdfoutline.xsl"/>
  <xsl:include href="footerinfo.xsl"/>


  <!-- Determine page height for various page sizes (US Letter portrait
  is the default) -->
  <!-- FIXME: JJP:would this be better of a file? -->
  <xsl:variable name="pageheight">
    <xsl:choose>
      <xsl:when test="$pageorientation = 'landscape'">
        <xsl:choose>
          <xsl:when test="$pagesize = 'a0'">841mm</xsl:when>
          <xsl:when test="$pagesize = 'a1'">594mm</xsl:when>
          <xsl:when test="$pagesize = 'a2'">420mm</xsl:when>
          <xsl:when test="$pagesize = 'a3'">297mm</xsl:when>
          <xsl:when test="$pagesize = 'a4'">210mm</xsl:when>
          <xsl:when test="$pagesize = 'a5'">148mm</xsl:when>
          <xsl:when test="$pagesize = 'executive'">7.25in</xsl:when>
          <xsl:when test="$pagesize = 'folio'">8.5in</xsl:when>
          <xsl:when test="$pagesize = 'ledger'">11in</xsl:when>
          <xsl:when test="$pagesize = 'legal'">8.5in</xsl:when>
          <xsl:when test="$pagesize = 'letter'">8.5in</xsl:when>
          <xsl:when test="$pagesize = 'quarto'">8.5in</xsl:when>
          <xsl:when test="$pagesize = 'tabloid'">11in</xsl:when>
          <xsl:otherwise>8.5in</xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <xsl:choose>
          <xsl:when test="$pagesize = 'a0'">1189mm</xsl:when>
          <xsl:when test="$pagesize = 'a1'">841mm</xsl:when>
          <xsl:when test="$pagesize = 'a2'">594mm</xsl:when>
          <xsl:when test="$pagesize = 'a3'">420mm</xsl:when>
          <xsl:when test="$pagesize = 'a4'">297mm</xsl:when>
          <xsl:when test="$pagesize = 'a5'">210mm</xsl:when>
          <xsl:when test="$pagesize = 'executive'">10.5in</xsl:when>
          <xsl:when test="$pagesize = 'folio'">13in</xsl:when>
          <xsl:when test="$pagesize = 'ledger'">17in</xsl:when>
          <xsl:when test="$pagesize = 'legal'">14in</xsl:when>
          <xsl:when test="$pagesize = 'quarto'">10.83in</xsl:when>
          <xsl:when test="$pagesize = 'tabloid'">17in</xsl:when>
          <xsl:otherwise>11in</xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <!-- Determine page width for various page sizes (US Letter portrait
  is the default) -->
  <xsl:variable name="pagewidth">
    <xsl:choose>
      <xsl:when test="$pageorientation = 'landscape'">
        <xsl:choose>
          <xsl:when test="$pagesize = 'a0'">1189mm</xsl:when>
          <xsl:when test="$pagesize = 'a1'">841mm</xsl:when>
          <xsl:when test="$pagesize = 'a2'">594mm</xsl:when>
          <xsl:when test="$pagesize = 'a3'">420mm</xsl:when>
          <xsl:when test="$pagesize = 'a4'">297mm</xsl:when>
          <xsl:when test="$pagesize = 'a5'">210mm</xsl:when>
          <xsl:when test="$pagesize = 'executive'">10.5in</xsl:when>
          <xsl:when test="$pagesize = 'folio'">13in</xsl:when>
          <xsl:when test="$pagesize = 'ledger'">17in</xsl:when>
          <xsl:when test="$pagesize = 'legal'">14in</xsl:when>
          <xsl:when test="$pagesize = 'quarto'">10.83in</xsl:when>
          <xsl:when test="$pagesize = 'tabloid'">17in</xsl:when>
          <xsl:otherwise>11in</xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <xsl:choose>
          <xsl:when test="$pagesize = 'a0'">841mm</xsl:when>
          <xsl:when test="$pagesize = 'a1'">594mm</xsl:when>
          <xsl:when test="$pagesize = 'a2'">420mm</xsl:when>
          <xsl:when test="$pagesize = 'a3'">297mm</xsl:when>
          <xsl:when test="$pagesize = 'a4'">210mm</xsl:when>
          <xsl:when test="$pagesize = 'a5'">148mm</xsl:when>
          <xsl:when test="$pagesize = 'executive'">7.25in</xsl:when>
          <xsl:when test="$pagesize = 'folio'">8.5in</xsl:when>
          <xsl:when test="$pagesize = 'ledger'">11in</xsl:when>
          <xsl:when test="$pagesize = 'legal'">8.5in</xsl:when>
          <xsl:when test="$pagesize = 'letter'">8.5in</xsl:when>
          <xsl:when test="$pagesize = 'quarto'">8.5in</xsl:when>
          <xsl:when test="$pagesize = 'tabloid'">11in</xsl:when>
          <xsl:otherwise>8.5in</xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:template match="/">
    <fo:root xmlns:fo="http://www.w3.org/1999/XSL/Format">
      <fo:layout-master-set>

        <fo:simple-page-master master-name="first-page"
          page-height="{$pageheight}" 
          page-width="{$pagewidth}"
          margin-top="{$topmargin}" 
          margin-bottom="{$bottommargin}" 
          margin-left="{$innermargin}" 
          margin-right="{$outermargin}">
          <fo:region-body
            margin-top="0.5in"
            margin-bottom=".5in"/>
          <fo:region-after 
            region-name="first-footer"
            extent=".5in"
            display-align="before"/>
        </fo:simple-page-master>

        <fo:simple-page-master master-name="even-page"
          page-height="{$pageheight}" 
          page-width="{$pagewidth}"
          margin-top="{$topmargin}" 
          margin-bottom="{$bottommargin}">
          <xsl:choose>
            <xsl:when test="$doublesided = 'true'">
              <xsl:attribute name="margin-left">
                <xsl:value-of select="$outermargin"/>
              </xsl:attribute>
              <xsl:attribute name="margin-right">
                <xsl:value-of select="$innermargin"/>
              </xsl:attribute>
            </xsl:when>
            <xsl:otherwise>
              <xsl:attribute name="margin-left">
                <xsl:value-of select="$innermargin"/>
              </xsl:attribute>
              <xsl:attribute name="margin-right">
                <xsl:value-of select="$outermargin"/>
              </xsl:attribute>
            </xsl:otherwise>
          </xsl:choose>
          <fo:region-before
            region-name="even-header"
            extent="0.5in"
            border-bottom="0.5pt solid"/>
          <fo:region-body
            margin-top="0.5in"
            margin-bottom=".5in"/>
          <fo:region-after 
            region-name="even-footer"
            extent=".5in"
            display-align="before"/>
        </fo:simple-page-master>

        <fo:simple-page-master master-name="odd-page"
          page-height="{$pageheight}" 
          page-width="{$pagewidth}"
          margin-top="{$topmargin}" 
          margin-bottom="{$bottommargin}" 
          margin-left="{$innermargin}" 
          margin-right="{$outermargin}">
          <fo:region-before
            region-name="odd-header"
            extent="0.5in"
            border-bottom="0.5pt solid"/>
          <fo:region-body
            margin-top="0.5in"
            margin-bottom=".5in"/>
          <fo:region-after 
            region-name="odd-footer"
            extent=".5in"
            display-align="before"/>
        </fo:simple-page-master>

        <fo:page-sequence-master master-name="book">
          <fo:repeatable-page-master-alternatives>
            <fo:conditional-page-master-reference
              page-position="first"
              master-reference="first-page"/>
            <fo:conditional-page-master-reference
              odd-or-even="odd"
              master-reference="odd-page"/>
            <fo:conditional-page-master-reference
              odd-or-even="even"
              master-reference="even-page"/>
          </fo:repeatable-page-master-alternatives>
        </fo:page-sequence-master>
      </fo:layout-master-set>

      <xsl:apply-templates select="/document" mode="outline"/>

      <fo:page-sequence master-reference="book">
        <fo:title><xsl:value-of select="document/header/title"/></fo:title>
        <xsl:apply-templates/>
      </fo:page-sequence>
      
    </fo:root>
  </xsl:template>

  <xsl:template match="document">
    <fo:title><xsl:value-of select="header/title"/></fo:title>
    
    <fo:static-content flow-name="first-footer">
      <fo:block
        border-top="0.25pt solid"
        padding-before="6pt"
        text-align="center">
        <xsl:apply-templates select="footer"/>
      </fo:block>
      <fo:block
        text-align="start">
        Page <fo:page-number/>
      </fo:block>
      <xsl:call-template name="info"/>
    </fo:static-content>

    <fo:static-content flow-name="even-header">
      <fo:block
        text-align="end"
        font-style="italic">
        <xsl:value-of select="header/title"/>
      </fo:block>
    </fo:static-content>

    <fo:static-content flow-name="even-footer">
      <fo:block
        border-top="0.25pt solid"
        padding-before="6pt"
        text-align="center">
        <xsl:apply-templates select="footer"/>
      </fo:block>
      <fo:block
        text-align="end">
        Page <fo:page-number/>
      </fo:block>
      <xsl:call-template name="info"/>
    </fo:static-content>

    <fo:static-content flow-name="odd-header">
      <fo:block
        text-align="start"
        font-style="italic">
        <xsl:value-of select="header/title"/>
      </fo:block>
    </fo:static-content>
    
    <fo:static-content flow-name="odd-footer">
      <fo:block
        border-top="0.25pt solid"
        padding-before="6pt"
        text-align="center">
        <xsl:apply-templates select="footer"/>
      </fo:block>
      <fo:block
        text-align="start">
        Page <fo:page-number/>
      </fo:block>
      <xsl:call-template name="info"/>
    </fo:static-content>

    <fo:flow flow-name="xsl-region-body">
      <fo:block
        padding-before="24pt"
        padding-after="24pt"
        font-size="24pt"
        font-weight="bold"
        id="{generate-id()}">

        <xsl:value-of select="header/title"/>
      </fo:block>
      
      <fo:block
        text-align="justify"
        padding-before="18pt"
        padding-after="18pt">
        <xsl:apply-templates/>
      </fo:block>
    </fo:flow>
  </xsl:template>
  
  <xsl:template match="abstract">
    <fo:block
      font-size="12pt"
      text-align="center"
      space-before="20pt"
      space-after="25pt"
      width="7.5in"
      font-family="serif"
      font-style="italic">
      <xsl:apply-templates/>
    </fo:block>
  </xsl:template>
  
  <xsl:template match="notice">
    <fo:block
      font-size="10pt"
      text-align="left"
      space-before="20pt"
      width="7.5in"
      font-family="serif"
      border-top="0.25pt solid"
      border-bottom="0.25pt solid"
      padding-before="6pt"
      padding-after="6pt">
      NOTICE: <xsl:apply-templates/>
    </fo:block>
  </xsl:template>

  <xsl:template match="anchor">
    <fo:block id="{@id}"/>
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="section">
    
    <xsl:param name="level">0</xsl:param>

    <xsl:variable name="size">
      <!-- 14pt for level 1 12pt for level 2 -->
      <xsl:value-of select="14-number($level)"/>
    </xsl:variable>
    
    <fo:block
      font-family="serif"
      font-size="{$size}pt"
      font-weight="bold"
      space-before="12pt"
      space-after="4pt">

      <xsl:attribute name="id">
        <xsl:choose>
          <xsl:when test="normalize-space(@id)!=''">
            <xsl:value-of select="@id"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="generate-id()"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>

      <xsl:if test="$numbersections = 'true' and number($level) &lt; $numbering-max-depth+1">
        <xsl:number format="1.1.1.1.1.1.1" count="section" level="multiple"/>
        <xsl:text>. </xsl:text>
      </xsl:if>

      <!-- For sections 4  or more nestings deep, indent instead of number -->
      <xsl:if test="number($level) &gt; $numbering-max-depth+1">
        <xsl:attribute name="start-indent">
          <xsl:value-of select="4+number($level)"/><xsl:text>pt</xsl:text>
        </xsl:attribute>
      </xsl:if>

      <xsl:value-of select="title"/>
    </fo:block>
    <xsl:apply-templates>
      <xsl:with-param name="level" select="number($level)+1"/>
    </xsl:apply-templates>
    
  </xsl:template>
  
  <xsl:template match="title">
    <!-- do nothing as titles are handled in their parent templates -->
  </xsl:template>
  
  <xsl:template match="subtitle">
    <xsl:param name="level">0</xsl:param>
    <xsl:variable name="size" select="16-(number($level)*1.5)"/>

    <fo:block
      font-weight="bold"
      font-size="{$size}pt">
      <xsl:apply-templates/>
    </fo:block>
  </xsl:template>

  <xsl:template match="authors">
    <fo:block
      space-before="20pt"
      font-weight="bold"
      font-size="9pt">
      by
      <xsl:for-each select="person">
        <xsl:value-of select="@name"/>
        <xsl:if test="not(position() = last())">, </xsl:if>
      </xsl:for-each>
    </fo:block>
  </xsl:template>

  <xsl:template match="p">
    <fo:block
      space-before="4pt"
      space-after="4pt"
      font-family="serif">
      <xsl:apply-templates/>
    </fo:block>
  </xsl:template>
  

  <xsl:template match="source">
    <fo:block
      font-family="monospace"
      font-size="10pt"
      background-color="#f0f0f0"
      white-space-collapse="false"
      linefeed-treatment="preserve"
      white-space-treatment="preserve"
      wrap-option="no-wrap"
      text-align="start">
      <xsl:apply-templates/>
    </fo:block>
  </xsl:template>
  
  
  <xsl:template match="ol|ul">
    <fo:list-block 
      provisional-distance-between-starts="18pt"
      provisional-label-separation="3pt"
      text-align="start">
      <xsl:apply-templates/>
    </fo:list-block>
  </xsl:template>
  
  <xsl:template match="ol/li">
    <fo:list-item>
      <fo:list-item-label 
        end-indent="label-end()">
        <fo:block>
          <xsl:number format="1."/>
        </fo:block>
      </fo:list-item-label>
      <fo:list-item-body 
        start-indent="body-start()">
        <fo:block
          font-family="serif">
          <xsl:apply-templates/>
        </fo:block>
      </fo:list-item-body>
    </fo:list-item>
  </xsl:template>

  <!-- Emulate browser handling of these invalid combinations that our DTD
  unfortunately allows -->
  <xsl:template match="ul/ul | ul/ol | ol/ul | ol/ol">
    <fo:list-item>
      <fo:list-item-label end-indent="label-end()">
        <fo:block></fo:block>
      </fo:list-item-label>
      <fo:list-item-body start-indent="body-start()">
        <fo:block font-family="serif">
          <xsl:apply-templates/>
        </fo:block>
      </fo:list-item-body>
    </fo:list-item>
  </xsl:template>

  <xsl:template match="ul/li">
    <fo:list-item>
      <fo:list-item-label end-indent="label-end()">
        <fo:block>&#x2022;</fo:block>
      </fo:list-item-label>
      <fo:list-item-body start-indent="body-start()">
        <fo:block
          font-family="serif">
          <xsl:apply-templates/>
        </fo:block>
      </fo:list-item-body>
    </fo:list-item>
  </xsl:template>
  
  <xsl:template match="dl">
    <fo:list-block
      provisional-distance-between-starts="18pt"
      provisional-label-separation="3pt"
      text-align="start">
      <xsl:apply-templates/>
    </fo:list-block>
  </xsl:template>
  
  <xsl:template match="dt">
    <fo:list-item>
      <fo:list-item-label end-indent="label-end()">
        <fo:block></fo:block>
      </fo:list-item-label>
      <fo:list-item-body start-indent="body-start()">
        <fo:block
          font-weight="bold">
          <xsl:apply-templates/>
        </fo:block>
      </fo:list-item-body>
    </fo:list-item>
  </xsl:template>
  
  <xsl:template match="dd">
    <fo:list-item>
      <fo:list-item-label end-indent="label-end()">
        <fo:block></fo:block>
      </fo:list-item-label>
      <fo:list-item-body start-indent="body-start()">
        <fo:block>
          <xsl:apply-templates/>
        </fo:block>
      </fo:list-item-body>
    </fo:list-item>
  </xsl:template>
  
  <xsl:template match="strong">
    <fo:inline font-weight="bold"><xsl:apply-templates/></fo:inline>
  </xsl:template>
  
  <xsl:template match="em">
    <fo:inline font-style="italic"><xsl:apply-templates/></fo:inline>
  </xsl:template>

  <xsl:template match="code">
    <fo:inline font-family="monospace"><xsl:apply-templates/></fo:inline>
  </xsl:template>

  <xsl:template match="warning">
    <fo:block
      margin-left="0.25in"
      margin-right="0.25in"
      font-weight="bold"
      font-size="10pt"
      font-family="serif"
      space-before="10pt"
      border-before-style="solid"
      border-start-style="solid"
      border-end-style="solid"
      border-color="#D00000"
      background-color="#D00000"
      color="#ffffff">
      <xsl:choose>
        <xsl:when test="@label"><xsl:value-of select="@label"/></xsl:when>
        <xsl:otherwise>Note: </xsl:otherwise>
      </xsl:choose><xsl:value-of select="title"/>       
    </fo:block>
    <fo:block
      margin-left="0.25in"
      margin-right="0.25in"
      font-family="serif"
      font-size="8pt"
      border-after-style="solid"
      border-start-style="solid"
      border-end-style="solid"
      border-color="#D00000"
      background-color="#fff0f0"
      padding-start="3pt"
      padding-end="3pt"
      padding-before="3pt"
      padding-after="3pt"
      space-after="10pt">
      <xsl:apply-templates/>
    </fo:block>
  </xsl:template>

  <xsl:template match="note">
    <fo:block
      margin-left="0.25in"
      margin-right="0.25in"
      font-weight="bold"
      font-size="10pt"
      color="#ffffff"
      font-family="serif"
      space-before="10pt"
      border-before-style="solid"
      border-start-style="solid"
      border-end-style="solid"
      border-color="#A0C9F5"
      background-color="#A0C9F5">
      <xsl:choose>
        <xsl:when test="@label"><xsl:value-of select="@label"/></xsl:when>
        <xsl:otherwise>Note: </xsl:otherwise>
      </xsl:choose><xsl:value-of select="title"/>
    </fo:block>
    <fo:block
      margin-left="0.25in"
      margin-right="0.25in"
      font-family="serif"
      font-size="8pt"
      space-after="10pt"
      border-after-style="solid"
      border-start-style="solid"
      border-end-style="solid"
      border-color="#A0C9F5"
      background-color="#F0F0FF"
      padding-start="3pt"
      padding-end="3pt"
      padding-before="3pt"
      padding-after="3pt">
      <xsl:apply-templates/>
    </fo:block>
  </xsl:template>

  <xsl:template match="fixme">
    <fo:block
      margin-left="0.25in"
      margin-right="0.25in"
      font-weight="bold"
      font-size="10pt"
      color="#FFFFFF"
      font-family="serif"
      space-before="10pt"
      border-before-style="solid"
      border-start-style="solid"
      border-end-style="solid"
      border-color="#C6C650"
      background-color="#C6C650">
      FIXME (<xsl:value-of select="@author"/>): <xsl:value-of select="title"/>
    </fo:block>
    <fo:block
      margin-left="0.25in"
      margin-right="0.25in"
      font-family="serif"
      font-size="8pt"
      space-after="10pt"
      border-after-style="solid"
      border-start-style="solid"
      border-end-style="solid"
      border-color="#C6C650"
      background-color="#FFF0F0"
      padding-start="3pt"
      padding-end="3pt"
      padding-before="3pt"
      padding-after="3pt">
      <xsl:apply-templates/>
    </fo:block>
  </xsl:template>

  <xsl:template match="link">
    <xsl:choose>
      <xsl:when test="starts-with(@href, '#')">
    <fo:basic-link color="blue" text-decoration="underline" internal-destination="{substring(@href,2)}">
      <xsl:apply-templates/>
    </fo:basic-link>
      </xsl:when>
      <xsl:otherwise>
    <fo:basic-link color="blue" text-decoration="underline" external-destination="{@href}"><xsl:apply-templates/></fo:basic-link>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="figure|img">
    <fo:block text-align="center">
      <xsl:if test="normalize-space(@id)!=''">
          <xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute>
      </xsl:if>

      <!-- Make relative paths absolute -->
      <xsl:variable name="imgpath">
      <xsl:choose>
        <xsl:when test="starts-with(string(@src), 'images/') or contains(string(@src), '../images')">
          <xsl:value-of select="concat($imagesdir, substring-after(@src, 'images'))"/>
        </xsl:when>
        <xsl:when test="starts-with(string(@src), 'http') ">
          <xsl:value-of select="@src"/>
        </xsl:when>
        <xsl:otherwise><xsl:value-of select="concat($imagesdir, $xmlbasedir, @src)"/></xsl:otherwise>
      </xsl:choose>
      </xsl:variable>
      <fo:external-graphic src="{$imgpath}">
        <xsl:if test="@height">
          <xsl:attribute name="height"><xsl:value-of select="@height"/></xsl:attribute>
        </xsl:if>
        <xsl:if test="@width">
          <xsl:attribute name="width"><xsl:value-of select="@width"/></xsl:attribute>
        </xsl:if>
      </fo:external-graphic>
      <!-- alt text -->
      <xsl:if test="normalize-space(@alt)!=''">
          <fo:block><xsl:value-of select="@alt"/></fo:block>
      </xsl:if>
    </fo:block>
  </xsl:template>

  <xsl:template match="table">
    <!-- FIXME: Apache FOP must have column widths specified at present,
         this section can be removed when this limitation is removed from Fop. 
         Unfortunately, this means that each column is a fixed width,
         but at least the table displays! -->

    <xsl:variable name="max-number-columns">
      <xsl:for-each select="tr">
        <xsl:sort select="count(td|th)" data-type="number" order="descending"/>
        <xsl:if test="position() = 1">
          <xsl:value-of select="count(td|th)"/>
        </xsl:if>
      </xsl:for-each>
    </xsl:variable>


    <xsl:variable name="column-width">
      <xsl:value-of select="6.25 div number($max-number-columns)"/>in
    </xsl:variable>

    <fo:table>
                  
      <fo:table-column>
        <xsl:attribute name="column-width">
          <xsl:value-of select="$column-width"/>
        </xsl:attribute>

        <xsl:attribute name="number-columns-repeated">
          <xsl:value-of select="number($max-number-columns)"/>
        </xsl:attribute>
      </fo:table-column>

      <!-- End of hack for Fop support (if removing this hack, remember 
           you need the <fo:table> element) -->

      <fo:table-body
        font-size="10pt"
        font-family="sans-serif">
        <xsl:apply-templates select="tr"/>
      </fo:table-body>
    </fo:table>

    <!-- FIXME: Apache Fop does not support the caption element yet.
         This hack will display the table caption accordingly. -->
    <xsl:if test="caption">
      <fo:block
        text-align="center"
        font-weight="bold">
        Table
        <xsl:text> </xsl:text>
        <xsl:number count="table" level="multiple"/>
        <xsl:text>: </xsl:text>
        <xsl:value-of select="caption"/>
      </fo:block>
    </xsl:if>
  </xsl:template>

  <xsl:template match="tr">
    <fo:table-row>
      <xsl:apply-templates/>
    </fo:table-row>
  </xsl:template>

  <xsl:template match="th">
      <fo:table-cell
        padding-before="4pt"
        padding-after="4pt"
        padding-start="4pt"
        padding-end="4pt"
        background-color="#A0C9F5">
        <xsl:attribute name="number-columns-spanned">
          <xsl:value-of select="@colspan"/>
        </xsl:attribute>
        <xsl:attribute name="number-rows-spanned">
          <xsl:value-of select="@rowspan"/>
        </xsl:attribute>
        <fo:block
          text-align="center">
          <xsl:apply-templates/>
        </fo:block>
      </fo:table-cell>
  </xsl:template>

  <xsl:template match="td">
    <fo:table-cell
      padding-before="4pt"
      padding-after="4pt"
      padding-start="4pt"
      padding-end="4pt"
      border="1pt solid #A0C9F5">
      <xsl:attribute name="number-columns-spanned">
          <xsl:value-of select="@colspan"/>
        </xsl:attribute>
        <xsl:attribute name="number-rows-spanned">
          <xsl:value-of select="@rowspan"/>
        </xsl:attribute>
      <fo:block>
        <xsl:apply-templates/>
      </fo:block>
    </fo:table-cell>
  </xsl:template>

  <xsl:template match="br">
    <fo:block></fo:block>
  </xsl:template>

  <xsl:template match="legal">
    <fo:inline
      font-size="8pt">
      <xsl:apply-templates/>
    </fo:inline>
  </xsl:template>

  <xsl:template match="body[count(//section) != 0]">
    <xsl:if test="$toc-max-depth > 0">
      <fo:block font-family="serif" font-size="14pt" font-weight="bold" 
      space-after="5pt" space-before="5pt" text-align="justify" width="7.5in"> 
        <!-- insert i18n stuff here -->
        <xsl:text>Table of contents</xsl:text>
      </fo:block>
      <fo:block font-family="sans" font-size="12pt" space-after="5pt" 
      space-before="0pt" text-align="justify" width="7.5in">
          <xsl:apply-templates select="section" mode="toc" />
      </fo:block>
    </xsl:if>
    <xsl:apply-templates />
  </xsl:template>

  <xsl:template match="section" mode="toc">
    <fo:block space-before="5pt" text-align-last="justify">
      <fo:inline>
        <fo:basic-link internal-destination="{generate-id( )}">
          <xsl:number count="section" format="1.1.1.1.1.1.1" level="multiple" />
          <xsl:text>. </xsl:text>
          <xsl:value-of select="title" />
          <fo:leader leader-pattern="dots" />
          <fo:page-number-citation ref-id="{generate-id(  )}" />
        </fo:basic-link>
      </fo:inline>
        <xsl:if test="$toc-max-depth > 1">
          <xsl:apply-templates select="section" mode="toc2" /> 
        </xsl:if>
    </fo:block>
  </xsl:template>

  <xsl:template match="section" mode="toc2">
    <fo:block start-indent=".5em" text-align-last="justify" text-indent=".5em">
      <fo:inline padding-start="1em">
        <fo:basic-link internal-destination="{generate-id( )}">
          <xsl:number count="section" format="1.1.1.1.1.1.1" level="multiple" />
          <xsl:text>. </xsl:text>
          <xsl:value-of select="title" />
          <fo:leader leader-pattern="dots" />
          <fo:page-number-citation ref-id="{generate-id(  )}" />
        </fo:basic-link>
      </fo:inline>
    </fo:block>
  </xsl:template>

<!-- ====================================================================== -->
<!-- Local Extensions section -->
<!-- ====================================================================== -->

 <xsl:template match="citation">
   <fo:inline>
     [<xsl:value-of select="@def"/>]
   </fo:inline>
 </xsl:template>



</xsl:stylesheet>
