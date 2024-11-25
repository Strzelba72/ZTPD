<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">
    <xsl:template match="/">
        <PRACOWNICY>
            <xsl:for-each select="//PRACOWNICY/ROW">
                <xsl:sort select="ID_PRAC"/>
                <PRACOWNIK>
                    <xsl:copy-of select="*"/>
                </PRACOWNIK>
            </xsl:for-each>
        </PRACOWNICY>
    </xsl:template>
</xsl:stylesheet>