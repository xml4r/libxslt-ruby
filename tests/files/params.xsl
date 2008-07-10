<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version='1.0'
  xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
  xmlns:foo='http://example.com/foo'
  exclude-result-prefixes='foo'>

  <xsl:param name='bar'>failure</xsl:param>
  <xsl:template match='/'>
    <article><xsl:value-of select='$bar'/></article>
  </xsl:template>
</xsl:stylesheet>