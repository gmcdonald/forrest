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

<!--+
    | Replace element for the value on the project descriptor 
    | xmlns:for has to be replaced for the final version
    |
    | Author: Juan Jose Pablos "cheche@apache.org"
    | 
    | CVS $\Id$
    +-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:for="http://xml.apache.org/forrest" version="1.0">

<xsl:import href="copyover.xsl"/>

<xsl:param name="config-file" />
  <xsl:variable name="config" select="document($config-file)/skinconfig"/>

<xsl:template match="for:project-name">
    <xsl:value-of select="$config/project-name"/>
  </xsl:template>

<xsl:template match="for:group-name">
    <xsl:value-of select="$config/group-name"/>
  </xsl:template>
</xsl:stylesheet>
