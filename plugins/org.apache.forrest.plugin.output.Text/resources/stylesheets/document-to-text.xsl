<?xml version="1.0"?>
<!--
  Licensed to the Apache Software Foundation (ASF) under one or more
  contributor license agreements.  See the NOTICE file distributed with
  this work for additional information regarding copyright ownership.
  The ASF licenses this file to You under the Apache License, Version 2.0
  (the "License"); you may not use this file except in compliance with
  the License.  You may obtain a copy of the License at

      http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.
-->
<!--
This stylesheet contains the majority of templates for converting documentv13
to Plain Text.  

No navigation is provided and no rendering of graphics is attempted.

-->
<xsl:stylesheet version="1.0" 
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:import href="common/text-templates.xsl"/>
  <xsl:param name="dynamic-page" select="'false'"/>
  <xsl:param name="notoc"/>
  <xsl:param name="path"/>
  <xsl:param name="document-width">76</xsl:param>
  <xsl:variable name="indent-per-level">2</xsl:variable>
  <xsl:template match="/">
    <xsl:apply-templates select="//document"/>
  </xsl:template>
  <xsl:template match="document">
    <xsl:apply-templates select="header"/>
    <xsl:apply-templates select="body" mode="toc"/>
    <xsl:apply-templates select="body"/>
  </xsl:template>
<!-- Handle the document header bits -->
  <xsl:template match="header">
    <xsl:call-template name="justify-text">
      <xsl:with-param name="text" select="title"/>
      <xsl:with-param name="width" select="$document-width"/>
      <xsl:with-param name="align" select="'center'"/>
    </xsl:call-template>
    <xsl:call-template name="cr"/>
    <xsl:if test="normalize-space(subtitle)!=''">
      <xsl:call-template name="justify-text">
        <xsl:with-param name="text" select="subtitle"/>
        <xsl:with-param name="width" select="$document-width"/>
        <xsl:with-param name="align" select="'center'"/>
      </xsl:call-template>
      <xsl:call-template name="cr"/>
    </xsl:if>
    <xsl:apply-templates select="type"/>
    <xsl:apply-templates select="notice"/>
    <xsl:apply-templates select="abstract"/>
    <xsl:apply-templates select="authors"/>
    <xsl:apply-templates select="version"/>
    <xsl:call-template name="cr"/>
  </xsl:template>
  <xsl:template match="header/authors">
    <xsl:for-each select="person">
      <xsl:choose>
        <xsl:when test="position()=1">by </xsl:when>
        <xsl:otherwise>, </xsl:otherwise>
      </xsl:choose>
      <xsl:value-of select="@name"/>
    </xsl:for-each>
    <xsl:call-template name="cr"/>
  </xsl:template>
  <xsl:template match="notice">
    <xsl:param name="level" select="'2'"/>
    <xsl:call-template name="cr"/>
    <xsl:call-template name="justify-text">
      <xsl:with-param name="text" select="'NOTICE'"/>
      <xsl:with-param name="width" select="$document-width"/>
    </xsl:call-template>
    <xsl:call-template name="cr"/>
    <xsl:variable name="para">
      <xsl:apply-templates>
        <xsl:with-param name="level" select="$level"/>
      </xsl:apply-templates>
    </xsl:variable>
    <xsl:call-template name="wrap-text">
      <xsl:with-param name="text" select="$para"/>
      <xsl:with-param name="indent" select="$level * $indent-per-level"/>
      <xsl:with-param name="width" select="$document-width"/>
    </xsl:call-template>
    <xsl:call-template name="cr"/>
  </xsl:template>
  <xsl:template match="abstract">
    <xsl:param name="level" select="'2'"/>
    <xsl:call-template name="cr"/>
    <xsl:call-template name="justify-text">
      <xsl:with-param name="text" select="'ABSTRACT'"/>
      <xsl:with-param name="width" select="$document-width"/>
    </xsl:call-template>
    <xsl:call-template name="cr"/>
    <xsl:variable name="para">
      <xsl:apply-templates>
        <xsl:with-param name="level" select="$level"/>
      </xsl:apply-templates>
    </xsl:variable>
    <xsl:call-template name="wrap-text">
      <xsl:with-param name="text" select="$para"/>
      <xsl:with-param name="indent" select="$level * $indent-per-level"/>
      <xsl:with-param name="width" select="$document-width"/>
    </xsl:call-template>
    <xsl:call-template name="cr"/>
  </xsl:template>
<!-- Handle the body bits -->
  <xsl:template match="body">
    <xsl:apply-templates>
      <xsl:with-param name="level" select="'0'"/>
    </xsl:apply-templates>
  </xsl:template>
  <xsl:template match="section">
    <xsl:param name="level" select="'0'"/>
    <xsl:variable name="title-text">
      <xsl:value-of select="normalize-space(title)"/>
    </xsl:variable>
    <xsl:call-template name="cr"/>
    <xsl:call-template name="lineOf">
      <xsl:with-param name="size" select="$level * $indent-per-level"/>
    </xsl:call-template>
    <xsl:value-of select="$title-text"/>
    <xsl:call-template name="cr"/>
<!-- generate a title element, level 1 -> h3, level 2 -> h4 and so on... -->
    <xsl:call-template name="lineOf">
      <xsl:with-param name="size" select="$level * $indent-per-level"/>
    </xsl:call-template>
    <xsl:choose>
      <xsl:when test="$level=0">
        <xsl:call-template name="lineOf">
          <xsl:with-param name="chars" select="'='"/>
          <xsl:with-param name="size" select="string-length($title-text)"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="$level=1">
        <xsl:call-template name="lineOf">
          <xsl:with-param name="chars" select="'-'"/>
          <xsl:with-param name="size" select="string-length($title-text)"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="$level=2">
        <xsl:call-template name="lineOf">
          <xsl:with-param name="chars" select="'.-'"/>
          <xsl:with-param name="size" select="string-length($title-text)"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="$level=3">
        <xsl:call-template name="lineOf">
          <xsl:with-param name="chars" select="'.'"/>
          <xsl:with-param name="size" select="string-length($title-text)"/>
        </xsl:call-template>
      </xsl:when>
    </xsl:choose>
    <xsl:call-template name="cr"/>
<!-- FIXME display $indent spaces -->
    <xsl:apply-templates select="*[not(self::title)]">
      <xsl:with-param name="level" select="$level + 1"/>
    </xsl:apply-templates>
  </xsl:template>
  <xsl:template match="p[@xml:space='preserve']">
    <xsl:param name="level" select="'1'"/>
    <xsl:call-template name="cr"/>
    <xsl:value-of select="."/>
    <xsl:call-template name="cr"/>
  </xsl:template>
  <xsl:template match="source">
    <xsl:param name="level" select="'1'"/>
    <xsl:call-template name="emit-with-indent">
      <xsl:with-param name="text" select="."/>
      <xsl:with-param name="indent" select="$level * $indent-per-level"/>
      <xsl:with-param name="marker" select="''"/>
    </xsl:call-template>
    <xsl:call-template name="cr"/>
  </xsl:template>
  <xsl:template match="p">
    <xsl:param name="level" select="'1'"/>
    <xsl:param name="width"
            select="$document-width - ($level * $indent-per-level)"/>
    <xsl:call-template name="cr"/>
    <xsl:variable name="para">
      <xsl:apply-templates>
        <xsl:with-param name="level" select="$level"/>
        <xsl:with-param name="width" select="$width"/>
      </xsl:apply-templates>
    </xsl:variable>
    <xsl:call-template name="wrap-text">
      <xsl:with-param name="text" select="$para"/>
      <xsl:with-param name="indent" select="$level * $indent-per-level"/>
      <xsl:with-param name="width" select="$width"/>
    </xsl:call-template>
    <xsl:call-template name="cr"/>
  </xsl:template>
  <xsl:template match="p" mode="in-list">
    <xsl:param name="level" select="'1'"/>
    <xsl:param name="width"
            select="$document-width - ($level * $indent-per-level)"/>
    <xsl:variable name="para">
      <xsl:apply-templates mode="in-list">
        <xsl:with-param name="level" select="$level"/>
        <xsl:with-param name="width" select="$width"/>
      </xsl:apply-templates>
    </xsl:variable>
    <xsl:call-template name="wrap-text">
      <xsl:with-param name="text" select="$para"/>
      <xsl:with-param name="indent" select="'0'"/>
      <xsl:with-param name="width" select="$width"/>
    </xsl:call-template>
    <xsl:if test="position()!=last()">
      <xsl:call-template name="cr"/>
    </xsl:if>
  </xsl:template>
  <xsl:template match="div|span">
    <xsl:param name="level" select="'1'"/>
    <xsl:param name="width"
            select="$document-width - ($level * $indent-per-level)"/>
    <xsl:apply-templates>
      <xsl:with-param name="level" select="$level"/>
      <xsl:with-param name="width" select="$width"/>
    </xsl:apply-templates>
  </xsl:template>
  <xsl:template match="div|span" mode="in-list">
    <xsl:param name="level" select="'1'"/>
    <xsl:param name="width"
            select="$document-width - ($level * $indent-per-level)"/>
    <xsl:apply-templates mode="in-list">
      <xsl:with-param name="level" select="$level"/>
      <xsl:with-param name="width" select="$width"/>
    </xsl:apply-templates>
  </xsl:template>
  <xsl:template match="ol|ul">
    <xsl:param name="level" select="'1'"/>
    <xsl:param name="width"
            select="$document-width - ($level * $indent-per-level)"/>
    <xsl:call-template name="cr"/>
    <xsl:apply-templates select="li">
      <xsl:with-param name="level" select="$level"/>
      <xsl:with-param name="width" select="$width"/>
    </xsl:apply-templates>
  </xsl:template>
  <xsl:template match="ol|ul" mode="in-list">
    <xsl:param name="level" select="'1'"/>
    <xsl:param name="width"
            select="$document-width - ($level * $indent-per-level)"/>
    <xsl:call-template name="cr"/>
    <xsl:apply-templates select="li" mode="in-list">
      <xsl:with-param name="level" select="$level"/>
      <xsl:with-param name="width" select="$width"/>
    </xsl:apply-templates>
  </xsl:template>
  <xsl:template match="dl">
    <xsl:param name="level" select="'1'"/>
    <xsl:param name="width"
            select="$document-width - ($level * $indent-per-level)"/>
    <xsl:call-template name="cr"/>
    <xsl:apply-templates>
      <xsl:with-param name="level" select="$level"/>
      <xsl:with-param name="width" select="$width"/>
    </xsl:apply-templates>
  </xsl:template>
  <xsl:template match="dl" mode="in-list">
    <xsl:param name="level" select="'1'"/>
    <xsl:param name="width"
            select="$document-width - ($level * $indent-per-level)"/>
    <xsl:apply-templates mode="in-list">
      <xsl:with-param name="level" select="$level"/>
      <xsl:with-param name="width" select="$width"/>
    </xsl:apply-templates>
  </xsl:template>
  <xsl:template match="note | warning | fixme">
    <xsl:param name="level" select="'1'"/>
    <xsl:param name="width"
            select="$document-width - ($level * $indent-per-level)"/>
    <xsl:call-template name="cr"/>
    <xsl:call-template name="lineOf">
      <xsl:with-param name="size" select="$level * $indent-per-level"/>
    </xsl:call-template>
    <xsl:variable name="title-text">
<xsl:text>** </xsl:text>
      <xsl:choose>
        <xsl:when test="@label">
          <xsl:value-of select="@label"/>
        </xsl:when>
        <xsl:when test="local-name() = 'note'">Note</xsl:when>
        <xsl:when test="local-name() = 'warning'">Warning</xsl:when>
        <xsl:otherwise>Fixme (<xsl:value-of select="@author"/>)</xsl:otherwise>
      </xsl:choose>
<xsl:text> **</xsl:text>
    </xsl:variable>
    <xsl:call-template name="justify-text">
      <xsl:with-param name="text" select="$title-text"/>
      <xsl:with-param name="width" select="$width"/>
    </xsl:call-template>
    <xsl:call-template name="cr"/>
    <xsl:variable name="para">
      <xsl:apply-templates>
        <xsl:with-param name="level" select="$level"/>
        <xsl:with-param name="width" select="$width"/>
      </xsl:apply-templates>
    </xsl:variable>
    <xsl:call-template name="wrap-text">
      <xsl:with-param name="text" select="$para"/>
      <xsl:with-param name="indent" select="$level * $indent-per-level"/>
      <xsl:with-param name="width" select="$width"/>
    </xsl:call-template>
    <xsl:call-template name="cr"/>
    <xsl:call-template name="lineOf">
      <xsl:with-param name="size" select="$level * $indent-per-level"/>
    </xsl:call-template>
    <xsl:call-template name="lineOf">
      <xsl:with-param name="size" select="$width"/>
      <xsl:with-param name="chars" select="'-'"/>
    </xsl:call-template>
    <xsl:call-template name="cr"/>
  </xsl:template>
  <xsl:template match="note | warning | fixme" mode="in-list">
    <xsl:param name="level" select="'1'"/>
    <xsl:param name="width"
            select="$document-width - ($level * $indent-per-level)"/>
    <xsl:variable name="title-text">
<xsl:text>** </xsl:text>
      <xsl:choose>
        <xsl:when test="@label">
          <xsl:value-of select="@label"/>
        </xsl:when>
        <xsl:when test="local-name() = 'note'">Note</xsl:when>
        <xsl:when test="local-name() = 'warning'">Warning</xsl:when>
        <xsl:otherwise>Fixme (<xsl:value-of select="@author"/>)</xsl:otherwise>
      </xsl:choose>
<xsl:text> **</xsl:text>
    </xsl:variable>
    <xsl:call-template name="justify-text">
      <xsl:with-param name="text" select="$title-text"/>
      <xsl:with-param name="width" select="$width"/>
    </xsl:call-template>
    <xsl:call-template name="cr"/>
    <xsl:variable name="para">
      <xsl:apply-templates mode="in-list">
        <xsl:with-param name="level" select="$level"/>
        <xsl:with-param name="width" select="$width"/>
      </xsl:apply-templates>
    </xsl:variable>
    <xsl:call-template name="wrap-text">
      <xsl:with-param name="text" select="$para"/>
      <xsl:with-param name="indent" select="'0'"/>
      <xsl:with-param name="width" select="$width"/>
      <xsl:with-param name="fixed" select="true"/>
    </xsl:call-template>
    <xsl:call-template name="cr"/>
    <xsl:call-template name="lineOf">
      <xsl:with-param name="size" select="$width"/>
      <xsl:with-param name="chars" select="'-'"/>
    </xsl:call-template>
    <xsl:call-template name="cr"/>
  </xsl:template>
  <xsl:template match="figure">
    <xsl:param name="level" select="'1'"/>
<xsl:text> </xsl:text>
    <xsl:apply-templates>
      <xsl:with-param name="level" select="$level"/>
    </xsl:apply-templates>
<xsl:text>[Figure: </xsl:text>
    <xsl:value-of select="@alt"/>
<xsl:text>]</xsl:text>
  </xsl:template>
  <xsl:template match="ol/li">
    <xsl:param name="level" select="'1'"/>
    <xsl:param name="width"
            select="$document-width - ($level * $indent-per-level)"/>
    <xsl:variable name="marker">
      <xsl:value-of select="position()"/>
<xsl:text>. </xsl:text>
    </xsl:variable>
    <xsl:variable name="item">
<!-- If we have no surrounding "p" elements in which word wrapping
      can take place, we need to see if we can word-wrap everything
      we have.  We can do this if we have no "p" elements and no
      nested lists or tables. -->
      <xsl:choose>
        <xsl:when test="p|ol|ul|dl">
          <xsl:apply-templates mode="in-list">
            <xsl:with-param name="level" select="'0'"/>
            <xsl:with-param name="width"
                select="$width - string-length($marker)"/>
          </xsl:apply-templates>
        </xsl:when>
        <xsl:otherwise>
          <xsl:variable name="tmp">
            <xsl:apply-templates mode="in-list">
              <xsl:with-param name="level" select="'0'"/>
              <xsl:with-param name="width"
                  select="$width - string-length($marker)"/>
            </xsl:apply-templates>
          </xsl:variable>
          <xsl:call-template name="wrap-text">
            <xsl:with-param name="text" select="$tmp"/>
            <xsl:with-param name="indent" select="'0'"/>
            <xsl:with-param name="width" select="$width"/>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:call-template name="emit-with-indent">
      <xsl:with-param name="text" select="$item"/>
      <xsl:with-param name="indent" select="$level * $indent-per-level"/>
      <xsl:with-param name="marker" select="$marker"/>
    </xsl:call-template>
  </xsl:template>
  <xsl:template match="ol/li" mode="in-list">
    <xsl:param name="level" select="'1'"/>
    <xsl:param name="width"
            select="$document-width - ($level * $indent-per-level)"/>
    <xsl:variable name="marker">
      <xsl:value-of select="position()"/>
<xsl:text>. </xsl:text>
    </xsl:variable>
    <xsl:variable name="item">
<!-- If we have no surrounding "p" elements in which word wrapping
      can take place, we need to see if we can word-wrap everything
      we have.  We can do this if we have no "p" elements and no
      nested lists or tables. -->
      <xsl:choose>
        <xsl:when test="p|ol|ul|dl">
          <xsl:apply-templates mode="in-list">
            <xsl:with-param name="level" select="'0'"/>
            <xsl:with-param name="width"
                select="$width - string-length($marker)"/>
          </xsl:apply-templates>
        </xsl:when>
        <xsl:otherwise>
          <xsl:variable name="tmp">
            <xsl:apply-templates mode="in-list">
              <xsl:with-param name="level" select="'0'"/>
              <xsl:with-param name="width"
                  select="$width - string-length($marker)"/>
            </xsl:apply-templates>
          </xsl:variable>
          <xsl:call-template name="wrap-text">
            <xsl:with-param name="text" select="$tmp"/>
            <xsl:with-param name="indent" select="'0'"/>
            <xsl:with-param name="width" select="$width"/>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:call-template name="emit-with-indent">
      <xsl:with-param name="text" select="$item"/>
      <xsl:with-param name="indent" select="$level * $indent-per-level"/>
      <xsl:with-param name="marker" select="$marker"/>
    </xsl:call-template>
  </xsl:template>
  <xsl:template match="ul/li">
    <xsl:param name="level" select="'1'"/>
    <xsl:param name="width"
            select="$document-width - ($level * $indent-per-level)"/>
    <xsl:variable name="item">
<!-- If we have no surrounding "p" elements in which word wrapping
      can take place, we need to see if we can word-wrap everything
      we have.  We can do this if we have no "p" elements and no
      nested lists or tables. -->
      <xsl:choose>
        <xsl:when test="p|ol|ul|dl">
          <xsl:apply-templates mode="in-list">
            <xsl:with-param name="level" select="'0'"/>
            <xsl:with-param name="width" select="$width - 2"/>
          </xsl:apply-templates>
        </xsl:when>
        <xsl:otherwise>
          <xsl:variable name="tmp">
            <xsl:apply-templates mode="in-list">
              <xsl:with-param name="level" select="'0'"/>
              <xsl:with-param name="width" select="$width - 2"/>
            </xsl:apply-templates>
          </xsl:variable>
          <xsl:call-template name="wrap-text">
            <xsl:with-param name="text" select="$tmp"/>
            <xsl:with-param name="indent" select="'0'"/>
            <xsl:with-param name="width" select="$width"/>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:call-template name="emit-with-indent">
      <xsl:with-param name="text" select="$item"/>
      <xsl:with-param name="indent" select="$level * $indent-per-level"/>
      <xsl:with-param name="marker" select="'* '"/>
    </xsl:call-template>
  </xsl:template>
  <xsl:template match="ul/li" mode="in-list">
    <xsl:param name="level" select="'1'"/>
    <xsl:param name="width"
            select="$document-width - ($level * $indent-per-level)"/>
    <xsl:variable name="item">
<!-- If we have no surrounding "p" elements in which word wrapping
      can take place, we need to see if we can word-wrap everything
      we have.  We can do this if we have no "p" elements and no
      nested lists or tables. -->
      <xsl:choose>
        <xsl:when test="p|ol|ul|dl">
          <xsl:apply-templates mode="in-list">
            <xsl:with-param name="level" select="'0'"/>
            <xsl:with-param name="width" select="$width - 2"/>
          </xsl:apply-templates>
        </xsl:when>
        <xsl:otherwise>
          <xsl:variable name="tmp">
            <xsl:apply-templates mode="in-list">
              <xsl:with-param name="level" select="'0'"/>
              <xsl:with-param name="width" select="$width - 2"/>
            </xsl:apply-templates>
          </xsl:variable>
          <xsl:call-template name="wrap-text">
            <xsl:with-param name="text" select="$tmp"/>
            <xsl:with-param name="indent" select="'0'"/>
            <xsl:with-param name="width" select="$width"/>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:call-template name="emit-with-indent">
      <xsl:with-param name="text" select="$item"/>
      <xsl:with-param name="indent" select="$level * $indent-per-level"/>
      <xsl:with-param name="marker" select="'* '"/>
    </xsl:call-template>
  </xsl:template>
  <xsl:template match="dd">
    <xsl:param name="level" select="'1'"/>
    <xsl:param name="width"
            select="$document-width - ($level * $indent-per-level)"/>
    <xsl:variable name="item">
<!-- If we have no surrounding "p" elements in which word wrapping
      can take place, we need to see if we can word-wrap everything
      we have.  We can do this if we have no "p" elements and no
      nested lists or tables. -->
      <xsl:choose>
        <xsl:when test="p|ol|ul|dl">
          <xsl:apply-templates mode="in-list">
            <xsl:with-param name="level" select="'0'"/>
            <xsl:with-param name="width" select="$width - 3"/>
          </xsl:apply-templates>
        </xsl:when>
        <xsl:otherwise>
          <xsl:variable name="tmp">
            <xsl:apply-templates mode="in-list">
              <xsl:with-param name="level" select="'0'"/>
              <xsl:with-param name="width" select="$width - 3"/>
            </xsl:apply-templates>
          </xsl:variable>
          <xsl:call-template name="wrap-text">
            <xsl:with-param name="text" select="$tmp"/>
            <xsl:with-param name="indent" select="'0'"/>
            <xsl:with-param name="width" select="$width"/>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:call-template name="emit-with-indent">
      <xsl:with-param name="text" select="$item"/>
      <xsl:with-param name="indent" select="$level * $indent-per-level"/>
      <xsl:with-param name="marker" select="'   '"/>
    </xsl:call-template>
  </xsl:template>
  <xsl:template match="dd" mode="in-list">
    <xsl:param name="level" select="'1'"/>
    <xsl:param name="width"
            select="$document-width - ($level * $indent-per-level)"/>
    <xsl:variable name="item">
<!-- If we have no surrounding "p" elements in which word wrapping
      can take place, we need to see if we can word-wrap everything
      we have.  We can do this if we have no "p" elements and no
      nested lists or tables. -->
      <xsl:choose>
        <xsl:when test="p|ol|ul|dl">
          <xsl:apply-templates mode="in-list">
            <xsl:with-param name="level" select="'0'"/>
            <xsl:with-param name="width" select="$width - 3"/>
          </xsl:apply-templates>
        </xsl:when>
        <xsl:otherwise>
          <xsl:variable name="tmp">
            <xsl:apply-templates mode="in-list">
              <xsl:with-param name="level" select="'0'"/>
              <xsl:with-param name="width" select="$width - 3"/>
            </xsl:apply-templates>
          </xsl:variable>
          <xsl:call-template name="wrap-text">
            <xsl:with-param name="text" select="$tmp"/>
            <xsl:with-param name="indent" select="'0'"/>
            <xsl:with-param name="width" select="$width"/>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:call-template name="emit-with-indent">
      <xsl:with-param name="text" select="$item"/>
      <xsl:with-param name="indent" select="$level * $indent-per-level"/>
      <xsl:with-param name="marker" select="'   '"/>
    </xsl:call-template>
  </xsl:template>
<!-- Simple items that can contain only in-line mark up -->
  <xsl:template match="dt">
    <xsl:param name="level" select="'1'"/>
    <xsl:param name="width"
            select="$document-width - ($level * $indent-per-level)"/>
    <xsl:call-template name="cr"/>
    <xsl:variable name="item">
      <xsl:apply-templates mode="in-list">
        <xsl:with-param name="level" select="'0'"/>
        <xsl:with-param name="width" select="$width"/>
      </xsl:apply-templates>
    </xsl:variable>
    <xsl:call-template name="emit-with-indent">
      <xsl:with-param name="text" select="$item"/>
      <xsl:with-param name="indent" select="$level * $indent-per-level"/>
      <xsl:with-param name="marker" select="':: '"/>
    </xsl:call-template>
  </xsl:template>
  <xsl:template match="dt" mode="in-list">
    <xsl:param name="level" select="'1'"/>
    <xsl:param name="width"
            select="$document-width - ($level * $indent-per-level)"/>
    <xsl:call-template name="cr"/>
    <xsl:variable name="item">
      <xsl:apply-templates mode="in-list">
        <xsl:with-param name="level" select="'0'"/>
        <xsl:with-param name="width" select="$width"/>
      </xsl:apply-templates>
    </xsl:variable>
    <xsl:call-template name="emit-with-indent">
      <xsl:with-param name="text" select="$item"/>
      <xsl:with-param name="indent" select="$level * $indent-per-level"/>
      <xsl:with-param name="marker" select="':: '"/>
    </xsl:call-template>
  </xsl:template>
<!-- Handle some in-line elements that we won't actually do anything
       with other than handle the emission of a space after the element
       has been emitted.  Needs to be done since any text nodes will
       have any leading spaces removed when they go through the 
       the wrap-text() template.  This will preserve the space
       between an in-line element and a following text node.
  -->
  <xsl:template match="em|strong|code">
    <xsl:param name="level" select="'1'"/>
    <xsl:apply-templates>
      <xsl:with-param name="level" select="$level"/>
    </xsl:apply-templates>
    <xsl:choose>
      <xsl:when test="starts-with(following-sibling::text(),' ')">
<xsl:text> </xsl:text>
      </xsl:when>
      <xsl:when test="starts-with(following-sibling::text(),'&#xa;')">
<xsl:text> </xsl:text>
      </xsl:when>
      <xsl:otherwise/>
    </xsl:choose>
  </xsl:template>
  <xsl:template match="em|strong|code" mode="in-list">
    <xsl:param name="level" select="'1'"/>
    <xsl:apply-templates>
      <xsl:with-param name="level" select="$level"/>
    </xsl:apply-templates>
    <xsl:choose>
      <xsl:when test="starts-with(following-sibling::text(),' ')">
<xsl:text> </xsl:text>
      </xsl:when>
      <xsl:when test="starts-with(following-sibling::text(),'&#xa;')">
<xsl:text> </xsl:text>
      </xsl:when>
      <xsl:otherwise/>
    </xsl:choose>
  </xsl:template>
  <xsl:template match="link|jump|fork|a">
    <xsl:param name="level" select="'1'"/>
    <xsl:apply-templates>
      <xsl:with-param name="level" select="$level"/>
    </xsl:apply-templates>
<xsl:text> </xsl:text>
    <xsl:call-template name="wrap-text">
      <xsl:with-param name="text" select="concat('[Link: ', @href, ']')"/>
      <xsl:with-param name="indent" select="$level * $indent-per-level"/>
      <xsl:with-param name="width"
          select="$document-width - ($level * $indent-per-level)"/>
    </xsl:call-template>
    <xsl:choose>
      <xsl:when test="starts-with(following-sibling::text(),' ')">
<xsl:text> </xsl:text>
      </xsl:when>
      <xsl:when test="starts-with(following-sibling::text(),'&#xa;')">
<xsl:text> </xsl:text>
      </xsl:when>
      <xsl:otherwise/>
    </xsl:choose>
  </xsl:template>
  <xsl:template match="link|jump|fork|a" mode="in-list">
    <xsl:param name="level" select="'1'"/>
    <xsl:apply-templates mode="in-list">
      <xsl:with-param name="level" select="$level"/>
    </xsl:apply-templates>
<xsl:text> </xsl:text>
    <xsl:call-template name="wrap-text">
      <xsl:with-param name="text" select="concat('[Link: ', @href, ']')"/>
      <xsl:with-param name="indent" select="$level * $indent-per-level"/>
      <xsl:with-param name="width"
          select="$document-width - ($level * $indent-per-level)"/>
    </xsl:call-template>
    <xsl:choose>
      <xsl:when test="starts-with(following-sibling::text(),' ')">
<xsl:text> </xsl:text>
      </xsl:when>
      <xsl:when test="starts-with(following-sibling::text(),'&#xa;')">
<xsl:text> </xsl:text>
      </xsl:when>
      <xsl:otherwise/>
    </xsl:choose>
  </xsl:template>
  <xsl:template match="icon|img">
    <xsl:param name="level" select="'1'"/>
    <xsl:variable name="type">
      <xsl:choose>
        <xsl:when test="local-name()='icon'">Icon: </xsl:when>
        <xsl:when test="local-name()='img'">Image: </xsl:when>
        <xsl:otherwise>Unknown: </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="value">
      <xsl:choose>
        <xsl:when test="local-name()='icon'">
          <xsl:value-of select="@alt"/>
        </xsl:when>
        <xsl:when test="local-name()='img'">
          <xsl:value-of select="@alt"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="local-name()"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
<xsl:text> </xsl:text>
    <xsl:call-template name="wrap-text">
      <xsl:with-param name="text" select="concat('[', $type, $value, ']')"/>
      <xsl:with-param name="indent" select="$level * $indent-per-level"/>
      <xsl:with-param name="width"
          select="$document-width - ($level * $indent-per-level)"/>
    </xsl:call-template>
    <xsl:choose>
      <xsl:when test="starts-with(following-sibling::text(),' ')">
<xsl:text> </xsl:text>
      </xsl:when>
      <xsl:when test="starts-with(following-sibling::text(),'&#xa;')">
<xsl:text> </xsl:text>
      </xsl:when>
      <xsl:otherwise/>
    </xsl:choose>
  </xsl:template>
  <xsl:template match="icon|img" mode="in-list">
    <xsl:param name="level" select="'1'"/>
    <xsl:variable name="type">
      <xsl:choose>
        <xsl:when test="local-name()='icon'">Icon: </xsl:when>
        <xsl:when test="local-name()='img'">Image: </xsl:when>
        <xsl:otherwise>Unknown: </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="value">
      <xsl:choose>
        <xsl:when test="local-name()='icon'">
          <xsl:value-of select="@alt"/>
        </xsl:when>
        <xsl:when test="local-name()='img'">
          <xsl:value-of select="@alt"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="local-name()"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
<xsl:text> </xsl:text>
    <xsl:call-template name="wrap-text">
      <xsl:with-param name="text" select="concat('[', $type, $value, ']')"/>
      <xsl:with-param name="indent" select="$level * $indent-per-level"/>
      <xsl:with-param name="width"
          select="$document-width - ($level * $indent-per-level)"/>
    </xsl:call-template>
    <xsl:choose>
      <xsl:when test="starts-with(following-sibling::text(),' ')">
<xsl:text> </xsl:text>
      </xsl:when>
      <xsl:when test="starts-with(following-sibling::text(),'&#xa;')">
<xsl:text> </xsl:text>
      </xsl:when>
      <xsl:otherwise/>
    </xsl:choose>
  </xsl:template>
  <xsl:template match="acronym">
    <xsl:param name="level" select="'1'"/>
    <xsl:apply-templates>
      <xsl:with-param name="level" select="$level"/>
    </xsl:apply-templates>
    <xsl:call-template name="wrap-text">
      <xsl:with-param name="text" select="concat(' (',@title,')')"/>
      <xsl:with-param name="indent" select="$level * $indent-per-level"/>
      <xsl:with-param name="width"
          select="$document-width - ($level * $indent-per-level)"/>
    </xsl:call-template>
    <xsl:choose>
      <xsl:when test="starts-with(following-sibling::text(),' ')">
<xsl:text> </xsl:text>
      </xsl:when>
      <xsl:when test="starts-with(following-sibling::text(),'&#xa;')">
<xsl:text> </xsl:text>
      </xsl:when>
      <xsl:otherwise/>
    </xsl:choose>
  </xsl:template>
  <xsl:template match="acronym" mode="in-list">
    <xsl:param name="level" select="'1'"/>
    <xsl:apply-templates>
      <xsl:with-param name="level" select="$level"/>
    </xsl:apply-templates>
    <xsl:call-template name="wrap-text">
      <xsl:with-param name="text" select="concat(' (',@title,')')"/>
      <xsl:with-param name="indent" select="$level * $indent-per-level"/>
      <xsl:with-param name="width"
          select="$document-width - ($level * $indent-per-level)"/>
    </xsl:call-template>
    <xsl:choose>
      <xsl:when test="starts-with(following-sibling::text(),' ')">
<xsl:text> </xsl:text>
      </xsl:when>
      <xsl:when test="starts-with(following-sibling::text(),'&#xa;')">
<xsl:text> </xsl:text>
      </xsl:when>
      <xsl:otherwise/>
    </xsl:choose>
  </xsl:template>
  <xsl:template match="version">
    <xsl:param name="level" select="'1'"/>
    <xsl:apply-templates select="@major"/>
    <xsl:apply-templates select="@minor"/>
    <xsl:apply-templates select="@fix"/>
    <xsl:apply-templates select="@tag"/>
    <xsl:choose>
      <xsl:when test="starts-with(., '$Rev')">
        <xsl:value-of select="concat('Version ',
          substring-before(substring-after(., ' '),' '))"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="."/>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:call-template name="cr"/>
  </xsl:template>
  <xsl:template match="@major">
     v<xsl:value-of select="."/>
  </xsl:template>
  <xsl:template match="@minor">
    <xsl:value-of select="concat('.',.)"/>
  </xsl:template>
  <xsl:template match="@fix">
    <xsl:value-of select="concat('.',.)"/>
  </xsl:template>
  <xsl:template match="@tag">
    <xsl:value-of select="concat('-',.)"/>
  </xsl:template>
  <xsl:template match="type">
    <xsl:param name="level" select="'1'"/>
<xsl:text>Type: </xsl:text>
    <xsl:value-of select="normalize-space(.)"/>
  </xsl:template>
  <xsl:template name="email">
    <xsl:param name="level" select="'1'"/><a>
    <xsl:attribute name="href">
      <xsl:value-of select="concat('mailto:',@email)"/>
    </xsl:attribute>
    <xsl:value-of select="@name"/></a>
  </xsl:template>
  <xsl:template match="text()">
    <xsl:param name="level" select="'1'"/>
    <xsl:param name="width"
            select="$document-width - ($level * $indent-per-level)"/>
    <xsl:call-template name="wrap-text">
      <xsl:with-param name="text" select="."/>
      <xsl:with-param name="indent" select="'0'"/>
      <xsl:with-param name="width" select="$width"/>
    </xsl:call-template>
  </xsl:template>
  <xsl:template match="text()" mode="in-list">
    <xsl:param name="level" select="'1'"/>
    <xsl:param name="width"
            select="$document-width - ($level * $indent-per-level)"/>
    <xsl:call-template name="wrap-text">
      <xsl:with-param name="text" select="."/>
      <xsl:with-param name="indent" select="'0'"/>
      <xsl:with-param name="width" select="$width"/>
    </xsl:call-template>
  </xsl:template>
<!--  Templates for "toc" mode.  This will generate a complete 
        Table of Contents for the document.  This will then be used
        by the site2xhtml to generate a Menu ToC and a Page ToC -->
  <xsl:template match="body" mode="toc">
<xsl:text>Table Of Contents&#xa;=================</xsl:text>
    <xsl:call-template name="cr"/>
    <xsl:apply-templates select="section" mode="toc">
      <xsl:with-param name="level" select="1"/>
    </xsl:apply-templates>
  </xsl:template>
  <xsl:template match="section" mode="toc">
    <xsl:param name="level" select="'1'"/>
    <xsl:call-template name="lineOf">
      <xsl:with-param name="size" select="($level - 1) * $indent-per-level"/>
    </xsl:call-template>
    <xsl:value-of select="normalize-space(title)"/>
    <xsl:call-template name="cr"/>
    <xsl:apply-templates mode="toc">
      <xsl:with-param name="level" select="$level+1"/>
    </xsl:apply-templates>
  </xsl:template>
  <xsl:template match="text()" mode="toc">
    <xsl:value-of select="normalize-space(.)"/>
  </xsl:template>
  <xsl:template match="node()|@*" mode="toc"/>
<!-- End of "toc" mode templates -->
</xsl:stylesheet>
