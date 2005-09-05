<?xml version="1.0"?>
<!--
  Copyright 2002-2005 The Apache Software Foundation or its licensors,
  as applicable.

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

<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    version="1.0">

  <xsl:param name="versionNumber"/>
  <xsl:include href="changes2document.xsl"/>

  <!-- Calculate path to site root, eg '../../' -->
  <xsl:variable name="root">
    <xsl:call-template name="dotdots">
      <xsl:with-param name="path" select="$path"/>
    </xsl:call-template>
  </xsl:variable>

  <!-- versionNumber: detect the value "current" or use the number that was supplied -->
  <xsl:variable name="realVersionNumber">
    <xsl:choose>
      <xsl:when test="$versionNumber='current'">
        <xsl:value-of select="//release[1]/@version"/>
      </xsl:when>
      <xsl:when test="$versionNumber=''">
        <xsl:value-of select="//release[1]/@version"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$versionNumber"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

 <!-- FIXME (JJP):  bugzilla is hardwired -->
 <xsl:variable name="bugzilla" select="'http://issues.apache.org/bugzilla/buglist.cgi?bug_id='"/>

 <xsl:param name="bugtracking-url" select="$bugzilla"/>

 <xsl:template match="/">
  <xsl:apply-templates select="//changes"/>
 </xsl:template>

 <xsl:template match="changes">
  <document>
   <header>
    <title>
    <xsl:choose>
     <xsl:when test="@title!=''">
       <xsl:value-of select="@title"/>
     </xsl:when>
     <xsl:otherwise>
       <xsl:text>Release Notes for Apache Forrest </xsl:text><xsl:value-of select="$versionNumber"/>
     </xsl:otherwise>
    </xsl:choose>
   </title>
   </header>
   <body>
     <xsl:if test="contains($realVersionNumber, 'dev')">
       <warning>Version <xsl:value-of select="$realVersionNumber"/> is a development release,
       these notes are therefore not complete, they are intended to be an indicator
       of the major features that are so far included in this version.</warning>
     </xsl:if>

     <xsl:if test="release[@version=$realVersionNumber]/notes">
         <xsl:apply-templates select="release[@version=$realVersionNumber]/notes"/>
     </xsl:if>

     <xsl:apply-templates select="release[@version=$realVersionNumber]"/>
   </body>
  </document>
 </xsl:template>

 <xsl:template match="release">
  <section id="version_{@version}">
   <title>Major Changes in Version <xsl:value-of select="@version"/></title>
   <note>This is not a complete list of changes, a
   full list of changes in this release
   <a href="changes_{$versionNumber}.html">is available</a>.</note>
     <xsl:if test="action[@context='code' and @importance='high']">
       <section>
         <title>Important Changes Code Base</title>
         <ul>
          <xsl:apply-templates select="action[@context='code' and @importance='high']">
            <xsl:sort select="@type"/>
          </xsl:apply-templates>
         </ul>
       </section>
     </xsl:if>
     <xsl:if test="action[@context='docs' and @importance='high']">
       <section>
         <title>Important Changes Documentation</title>
         <ul>
          <xsl:apply-templates select="action[@context='docs' and @importance='high']">
            <xsl:sort select="@type"/>
          </xsl:apply-templates>
        </ul>
       </section>
     </xsl:if>
     <xsl:if test="action[@context='admin' and @importance='high']">
       <section>
         <title>Important Changes Project Administration</title>
         <ul>
           <xsl:apply-templates select="action[@context='admin' and @importance='high']">
            <xsl:sort select="@type"/>
          </xsl:apply-templates>
         </ul>
       </section>
     </xsl:if>
     <xsl:if test="action[@context='design' and @importance='high']">
       <section>
         <title>Important Changes Design</title>
         <ul>
          <xsl:apply-templates select="action[@context='design' and @importance='high']">
            <xsl:sort select="@type"/>
          </xsl:apply-templates>
         </ul>
       </section>
     </xsl:if>
     <xsl:if test="action[@context='build' and @importance='high']">
       <section>
         <title>Important Changes Build</title>
         <ul>
           <xsl:apply-templates select="action[@context='build' and @importance='high']">
            <xsl:sort select="@type"/>
          </xsl:apply-templates>
         </ul>
       </section>
     </xsl:if>
  </section>
 </xsl:template>

</xsl:stylesheet>
