<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:template match='/'>
        <html>
            <body>
                <h1>ZESPOŁY:</h1>
                <ol> <xsl:apply-templates select="ZESPOLY/ROW" mode="list"/></ol>
                <xsl:apply-templates select="ZESPOLY/ROW" mode="info"/>
            </body>
        </html>
    </xsl:template>
    <xsl:template match="*" mode="list">
        <li><a href="#{NAZWA}"><xsl:value-of select="NAZWA"/></a></li>
    </xsl:template>
    <xsl:template match="*" mode="info">
        <div>
            <b id="{NAZWA}">NAZWA: <xsl:value-of select="NAZWA" /></b><br />
            <b>ADRES: <xsl:value-of select="ADRES" /></b><br />
            <br />
            <xsl:if test="count(PRACOWNICY/ROW) > 0">
                <table border="1">
                    <tr>
                        <th>Nazwisko</th>
                        <th>Etat</th>
                        <th>Zatrudniony</th>
                        <th>Płaca pod.</th>
                        <th>Szef</th>
                    </tr>
                    <xsl:apply-templates select="PRACOWNICY/ROW" mode="workers">
                        <xsl:sort select="NAZWISKO"/>
                    </xsl:apply-templates>
                </table>
            </xsl:if>
            Liczba pracowników: <xsl:value-of select="count(PRACOWNICY/ROW)"/>
            <br />
            <br />
        </div>
    </xsl:template>
    <xsl:template match="*" mode="workers">
        <tr>
            <td><xsl:value-of select="NAZWISKO"/></td>
            <td><xsl:value-of select="ETAT"/></td>
            <td><xsl:value-of select="ZATRUDNIONY"/></td>
            <td><xsl:value-of select="PLACA_POD"/></td>
            <td><xsl:call-template name="boss"><xsl:with-param name="boss_id" select="ID_SZEFA"/></xsl:call-template></td>
        </tr>
    </xsl:template>
    <xsl:template name="boss">
        <xsl:param name="boss_id"></xsl:param>
        <xsl:choose>
            <xsl:when test="$boss_id != ''">
                <xsl:value-of select="//PRACOWNICY/ROW[ID_PRAC = $boss_id]/NAZWISKO"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>brak</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>
