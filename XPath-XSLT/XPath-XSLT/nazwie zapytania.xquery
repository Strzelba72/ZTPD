(: for $k in doc('C:/Users/mikolaj/Desktop/ztpd/XPath-XSLT/XPath-XSLT/swiat.xml')/SWIAT/KRAJE/KRAJ[starts-with(NAZWA, substring(STOLICA, 1, 1))]
return <KRAJ>
{$k/NAZWA, $k/STOLICA}
</KRAJ> :)

(:doc('C:/Users/mikolaj/Desktop/ztpd/XPath-XSLT/XPath-XSLT//swiat.xml')//KRAJ :)

(: zad 31 doc('C:/Users/mikolaj/Desktop/ztpd/XPath-XSLT/XPath-XSLT/zesp_prac.xml') :)
(: zad 32 doc('C:/Users/mikolaj/Desktop/ztpd/XPath-XSLT/XPath-XSLT/zesp_prac.xml')//NAZWISKO :)
(: zad 33 doc('C:/Users/mikolaj/Desktop/ztpd/XPath-XSLT/XPath-XSLT/zesp_prac.xml')//ROW[NAZWA='SYSTEMY EKSPERCKIE']//NAZWISKO :)
(: zad 34 count(doc('C:/Users/mikolaj/Desktop/ztpd/XPath-XSLT/XPath-XSLT/zesp_prac.xml')//ROW[ID_ZESP=10]/PRACOWNICY/ROW) :)
(: zad 35 doc('C:/Users/mikolaj/Desktop/ztpd/XPath-XSLT/XPath-XSLT/zesp_prac.xml')//PRACOWNICY/ROW[ID_SZEFA=100]/NAZWISKO :)
sum(doc('C:/Users/mikolaj/Desktop/ztpd/XPath-XSLT/XPath-XSLT/zesp_prac.xml')//PRACOWNICY/ROW[ID_ZESP=//PRACOWNICY/ROW[NAZWISKO='BRZEZINSKI']/ID_ZESP]//PLACA_POD)