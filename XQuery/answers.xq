(: zad 5 doc("db/bib/bib.xml")//author//last :)
(: zad 6
for $book in doc("db/bib/bib.xml")//book
for $title in $book/title
for $author in $book/author
return
  <ksiazka>
    <author>{$author/*}</author>
    <title>{$title/text()}</title>
  </ksiazka> :)
(: zad 7 
for $book in doc("db/bib/bib.xml")//book
for $title in $book/title
for $author in $book/author
return
  <ksiazka>
    <tytul>{$title/text()}</tytul>
    <autor>{$author/last/text()}{$author/first/text()}</autor>
  </ksiazka>:)
(: zad 8 
for $book in doc("db/bib/bib.xml")//book
for $title in $book/title
for $author in $book/author
return
  <ksiazka>
    <tytul>{$title/text()}</tytul>
    <autor>{concat($author/last/text(), " ", $author/first/text())}</autor>
  </ksiazka> :)
(: zad 9
<wynik>
{
  for $book in doc("db/bib/bib.xml")//book
  for $title in $book/title
  for $author in $book/author
  return
    <ksiazka>
      <tytul>{$title/text()}</tytul>
      <autor>{concat($author/last/text(), " ", $author/first/text())}</autor>
    </ksiazka>
}
</wynik> :)
(: zad 10 
<imiona>
{
  for $book in doc("db/bib/bib.xml")//book
  where $book/title = "Data on the Web"
  for $author in $book/author
  return
    <imie>{$author/first/text()}</imie>
}
</imiona> :)
(: zad 11
<DataOnTheWeb>
  {doc("db/bib/bib.xml")//book[title = "Data on the Web"]}
</DataOnTheWeb>
<DataOnTheWeb>
  {for $book in doc("db/bib/bib.xml")//book
    where $book/title = "Data on the Web"
    return $book
  }
</DataOnTheWeb>:)
(: zad 12 <Data>
{
  for $book in doc("db/bib/bib.xml")//book
  where contains($book/title, "Data")
  for $author in $book/author
  return
    <nazwisko>{$author/last/text()}</nazwisko>
}
</Data> :)
(: zad 13 
for $book in doc("db/bib/bib.xml")//book
where contains($book/title, "Data")
return 
  <Data>
    <title>{$book/title/text()}</title>
    {
      for $author in $book/author
      return <nazwisko>{$author/last/text()}</nazwisko>
    }
  </Data>:)
(:zad 14
for $book in doc("db/bib/bib.xml")//book
where count($book/author)<= 2
return $book/title :)
(: zad 15 
for $book in doc("db/bib/bib.xml")//book
return
  <ksiazka>
    {$book/title}
    <autorow>{count($book/author)}</autorow>
  </ksiazka> :)
(: zad 16 
<przedział>
{
  let $years := doc("db/bib/bib.xml")//book/@year
  return concat(min($years), " - ", max($years))
}
</przedział>
:)
(: zad 17 
<różnica>
{
  let $cena := doc("db/bib/bib.xml")//book/price
  return max($cena) - min($cena)
}
</różnica> :)
(: zad 18
<najtańsze>
{
  let $minPrice := min(doc("db/bib/bib.xml")//book/price)
  for $book in doc("db/bib/bib.xml")//book
  where $book/price = $minPrice
  return
    <najtańsza>
      <title>{$book/title/text()}</title>
      {
        for $author in $book/author
        return
          <author>
            <last>{$author/last/text()}</last>
            <first>{$author/first/text()}</first>
          </author>
      }
    </najtańsza>
}
</najtańsze> :)
(: zad 19
for $author in distinct-values(doc("db/bib/bib.xml")//book/author/last)
let $books := doc("db/bib/bib.xml")//book[author/last = $author]
return
  <autor>
    <last>{$author}</last>
      {
        for $book in $books
        return <title>{$book/title/text()}</title>
      }
    </autor> :)
(: zad 20
collection("db/shakespeare")//PLAY/TITLE :)
(: zad 21
for $play in collection("db/shakespeare")//PLAY
where some $line in $play/ACT/SCENE/SPEECH/LINE satisfies
contains($line, "or not to be")
return $play/TITLE :)
(: zad 22 
for $play in collection("db/shakespeare")//PLAY
return
  <sztuka tytul="{$play/TITLE/text()}">
  <postaci>{count($play/PERSONAE/PERSONA | $play/PERSONAE/PGROUP/PERSONA)}</postaci>
  <aktow>{count($play/ACT)}</aktow>
  <scen>{count($play/ACT/SCENE)}</scen>
  </sztuka> :)

