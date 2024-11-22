Zad. 1
Utwórz w swoim schemacie kopię tabeli MOVIES ze schematu ZTPD.

CREATE TABLE MOVIES AS (SELECT * FROM ZTPD.MOVIES)

Zad. 2
Zapoznaj się ze schematem tabeli MOVIES, zwracając uwagę na kolumnę typu BLOB

DESC MOVIES;

Zad.3
Sprawdź zapytaniem SQL do tabeli MOVIES, które filmy nie mają okładek.

SELECT ID, TITLE FROM MOVIES WHERE COVER IS NULL;

Zad. 4
Dla filmów, które mają okładki odczytaj rozmiar obrazka w bajtach.

SELECT ID, TITLE, DBMS_LOB.GETLENGTH(COVER) FROM MOVIES WHERE COVER IS NOT NULL;

Zad. 5
Sprawdź co się stanie gdy zostanie dokonana próba odczytu rozmiaru obrazków dla
filmów, które nie posiadają okładek w tabeli MOVIES

SELECT ID, TITLE, DBMS_LOB.GETLENGTH(COVER) FROM MOVIES WHERE COVER IS NULL;

Zad. 6
Brakujące okładki zostały umieszczone w jednym z katalogów systemu plików serwera
bazy danych w plikach eagles.jpg i escape.jpg. Został on udostępniony w bazie danych jako
obiekt DIRECTORY o nazwie TPD_DIR. Upewnij się zapytaniem do perspektywy
ALL_DIRECTORIES czy widzisz katalog TPD_DIR i odczytaj jaką ścieżkę w systemie
plików on reprezentuje.
Uwaga: Z poziomu bazy danych do katalogu odwołuje się poprzez nazwę obiektu
DIRECTORY (czyli TPD_DIR w naszym przypadku). Gdy nazwa ta pojawia się jako
tekstowy parametr procedur/funkcji, to musi być zachowana wielkość liter jak w słowniku
bazy danych.

SELECT * FROM ALL_DIRECTORIES

Zad. 7
Zmodyfikuj okładkę filmu o identyfikatorze 66 w tabeli MOVIES na pusty obiekt BLOB
(lokalizator bez wartości), a jako typ MIME (w przeznaczonej do tego celu kolumnie tabeli)
podaj: image/jpeg. Zatwierdź transakcję

UPDATE MOVIES
SET COVER = EMPTY_BLOB(),
MIME_TYPE = 'image/jpeg'
WHERE ID=66;
COMMIT;

Zad. 8
Odczytaj z tabeli MOVIES rozmiar obrazków dla filmów o identyfikatorach 65 i 66

SELECT ID, DBMS_LOB.GETLENGTH(cover) FROM MOVIES WHERE ID IN (65,66)

Zad. 9
Napisz program w formie anonimowego bloku PL/SQL, który dla filmu o identyfikatorze
66 przekopiuje binarną zawartość obrazka z pliku escape.jpg znajdującego się w katalogu
systemu plików serwera (za pośrednictwem obiektu BFILE) do pustego w tej chwili obiektu
BLOB w tabeli MOVIES. Wykorzystaj poniższy schemat postępowania:
1) Zadeklaruj w programie zmienną typu BFILE i zwiąż ją z plikiem okładki
	w katalogu na serwerze.
2) Odczytaj z tabeli MOVIES pusty obiekt BLOB do zmiennej (nie zapomnij
	o klauzuli zakładającej blokadę na wierszu zawierającym obiekt BLOB,
	który będzie modyfikowany).
3) Przekopiuj zawartość binarną z BFILE do BLOB
	(nie zapominając o otwarciu i zamknięciu pliku BFILE!).
4) Zatwierdź transakcję

DECLARE
 lobd blob;
 fils BFILE := BFILENAME('TPD_DIR','escape.jpg');
BEGIN
    SELECT cover INTO lobd
    FROM MOVIES
    where ID=66
    FOR UPDATE;
    DBMS_LOB.fileopen(fils, DBMS_LOB.file_readonly);
    DBMS_LOB.LOADFROMFILE(lobd,fils,DBMS_LOB.GETLENGTH(fils));
    DBMS_LOB.FILECLOSE(fils);
    COMMIT;
END;
/

Zad. 10
Utwórz tabelę TEMP_COVERS o poniższej strukturze:
	movie_id NUMBER(12)
	image BFILE
	mime_type VARCHAR2(50)
	
CREATE TABLE TEMP_COVERS(
    movie_id NUMBER(2),
    image BFILE,
    mime_type VARCHAR2(50)
);

Zad. 11
Wstaw do tabeli TEMP_COVERS obrazek z pliku eagles.jpg z udostępnionego katalogu.
Nadaj mu identyfikator filmu, którego jest okładką (65). Jako typ MIME podaj: image/jpeg.
Zatwierdź transakcję.

INSERT INTO TEMP_COVERS (movie_id, image, mime_type)
    VALUES (65, BFILENAME('TPD_DIR', 'eagles.jpg'), 'image/jpeg');

Zad. 12
Odczytaj rozmiar w bajtach dla obrazka załadowanego jako BFILE

SELECT movie_id, DBMS_LOB.GETLENGTH(image) AS FILESIZE
    FROM TEMP_COVERS;

Zad. 13
Napisz program w formie anonimowego bloku PL/SQL, który dla filmu o identyfikatorze
65 utworzy obiekt BLOB, przekopiuje do niego binarną zawartość okładki BFILE z tabeli
TEMP_COVERS i umieści BLOB w odpowiednim wierszu tabeli MOVIES. Wykorzystaj
poniższy schemat postępowania:
1) Odczytaj lokalizator BFILE i informację o typie MIME obrazka z tabeli
	TEMP_COVERS do zmiennych w programie.
2) Utwórz tymczasowy obiekt LOB.
3) Przekopiuj do niego zawartość binarną z BFILE
	(nie zapominając o otwarciu i zamknięciu pliku!).
4) Zapisz tymczasowy LOB do tabeli MOVIES poleceniem UPDATE, jednocześnie
	ustawiając typ MIME na odczytany z tabeli TEMP_COVERS.
5) Zwolnij tymczasowy LOB.
6) Zatwierdź transakcję.

DECLARE
    tmp_cover BFILE;
    tmp_blob BLOB;
    tmp_mime VARCHAR2(50);
BEGIN        
    SELECT image, mime_type INTO tmp_cover, tmp_mime
    FROM TEMP_COVERS
    WHERE movie_id=65;
    
    DBMS_LOB.FILEOPEN(tmp_cover, DBMS_LOB.file_readonly);
    DBMS_LOB.CREATETEMPORARY(tmp_blob, TRUE);
    DBMS_LOB.LOADFROMFILE(tmp_blob, tmp_cover, DBMS_LOB.GETLENGTH(tmp_cover));
    DBMS_LOB.FILECLOSE(tmp_cover);
    
    UPDATE MOVIES SET
        cover = tmp_blob,
        mime_type = tmp_mime
        WHERE ID=65;
        
    DBMS_LOB.FREETEMPORARY(tmp_blob);
    COMMIT;
END;
/

Zad. 14
Odczytaj rozmiar w bajtach dla okładek filmów 65 i 66 z tabeli MOVIES.

SELECT id, DBMS_LOB.GETLENGTH(cover) 
    FROM MOVIES
    WHERE ID=65 OR ID=66;

Zad. 15
Usuń tabelę MOVIES ze swojego schematu

