1.
1. Utwórz w swoim schemacie tabelę DOKUMENTY o poniższej strukturze:
ID NUMBER(12) PRIMARY KEY
DOKUMENT CLOB

create table DOKUMENTY(
ID NUMBER(12) PRIMARY KEY,
DOKUMENT CLOB
);

2. Wstaw do tabeli DOKUMENTY dokument utworzony przez konkatenację 10000 kopii
tekstu 'Oto tekst. ' nadając mu ID = 1 (Wskazówka: wykorzystaj anonimowy blok kodu
PL/SQL).
DECLARE
    text CLOB;
BEGIN
    FOR I IN 1..10000
    LOOP
        text := CONCAT(text, 'Oto text. ');
    END LOOP;
    
    INSERT INTO DOKUMENTY VALUES(1, text);
END;

3. 
SELECT * FROM DOKUMENTY;
SELECT UPPER(DOKUMENT) FROM DOKUMENTY;
SELECT LENGTH(DOKUMENT) FROM DOKUMENTY;
SELECT DBMS_LOB.GETLENGTH(DOKUMENT) FROM DOKUMENTY;
SELECT SUBSTR(DOKUMENT,5,1000) FROM DOKUMENTY;
SELECT DBMS_LOB.SUBSTR(DOKUMENT, 1000, 5) FROM DOKUMENTY;
4.
Wstaw do tabeli drugi dokument jako pusty obiekt CLOB nadając mu ID = 2.
INSERT INTO DOKUMENTY VALUES(2,EMPTY_CLOB())

5.
Wstaw do tabeli trzeci dokument jako NULL nadając mu ID = 3. Zatwierdź transakcję.
INSERT INTO DOKUMENTY VALUES(3,NULL);
COMMIT;

6.Sprawdź jaki będzie efekt zapytań z punktu 3 dla wszystkich trzech dokumentów
SELECT * FROM DOKUMENTY;
SELECT UPPER(DOKUMENT) FROM DOKUMENTY;
SELECT LENGTH(DOKUMENT) FROM DOKUMENTY;
SELECT DBMS_LOB.GETLENGTH(DOKUMENT) FROM DOKUMENTY;
SELECT SUBSTR(DOKUMENT,5,1000) FROM DOKUMENTY;
SELECT DBMS_LOB.SUBSTR(DOKUMENT, 1000, 5) FROM DOKUMENTY;

7.
Napisz program w formie anonimowego bloku PL/SQL, który do dokumentu
o identyfikatorze 2 przekopiuje tekstową zawartość pliku dokument.txt znajdującego się
w katalogu systemu plików serwera udostępnionym przez obiekt DIRECTORY o nazwie
TPD_DIR do pustego w tej chwili obiektu CLOB w tabeli DOKUMENTY. Wykorzystaj
poniższy schemat postępowania:
1) Zadeklaruj w programie zmienną typu BFILE i zwiąż ją z plikiem tekstowym
w katalogu na serwerze.
2) Odczytaj z tabeli DOKUMENTY pusty obiekt CLOB do zmiennej (nie zapomnij
o klauzuli zakładającej blokadę na wierszu zawierającym obiekt CLOB,
który będzie modyfikowany).
3) Przekopiuj zawartość z BFILE do CLOB procedurą LOADCLOBFROMFILE
z pakietu DBMS_LOB (nie zapominając o otwarciu i zamknięciu pliku BFILE!).
Wskazówki: Pamiętaj aby parametry przekazywane w trybie IN OUT i OUT
przekazać jako zmienne. Wartości parametrów określających identyfikator zestawu
znaków źródła i kontekst językowy ustaw na 0. Wartość 0 identyfikatora zestawu
znaków źródła oznacza że jest on taki jak w bazie danych dla wykorzystywanego typu
dużego obiektu tekstowego.

DECLARE
    doc CLOB;
    text_file BFILE := BFILENAME('TPD_DIR', 'dokument.txt');
    doffset integer := 1;
     soffset integer := 1;
     langctx integer := 0;
     warn integer := null;
BEGIN
    SELECT dokument INTO doc FROM dokumenty
    WHERE id = 2
    FOR UPDATE;
    
    DBMS_LOB.fileopen(text_file, DBMS_LOB.file_readonly);
    DBMS_LOB.loadclobfromfile(doc, text_file, DBMS_LOB.lobmaxsize, doffset, soffset, 873, langctx, warn);
    DBMS_LOB.fileclose(text_file);
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Status operacji: '||warn);
END;

8.Do dokumentu o identyfikatorze 3 przekopiuj tekstową zawartość pliku dokument.txt
znajdującego się w katalogu systemu plików serwera (za pośrednictwem obiektu BFILE), tym
razem nie korzystając z PL/SQL, a ze zwykłego polecenia UPDATE z poziomu SQL.
Wskazówka: Od wersji Oracle 12.2 funkcje TO_BLOB i TO_CLOB zostały rozszerzone
o obsługę parametru typu BFILE.
(https://docs.oracle.com/en/database/oracle/oracle-database/19/sqlrf/TO_CLOB-bfileblob.html)

UPDATE dokumenty
SET dokument = TO_CLOB(BFILENAME('TPD_DIR', 'dokument.txt'), 873)
WHERE id = 3;

9.  Odczytaj zawartość tabeli DOKUMENTY.
SELECT * FROM DOKUMENTY;

10. Odczytaj rozmiar wszystkich dokumentów z tabeli DOKUMENTY.
SELECT DBMS_LOB.GETLENGTH(DOKUMENT) FROM DOKUMENTY;

11. Usuń tabelę DOKUMENTY.
DROP TABLE DOKUMENTY;

12.
CREATE OR REPLACE PROCEDURE CLOB_CENSOR(
    clob_object IN OUT CLOB,
    replace_object   VARCHAR2)
IS
    dotted_object VARCHAR2(256);
    index_position         INTEGER := 1;
BEGIN
    dotted_object := LPAD('.', LENGTH(replace_object), '.');
    LOOP
        index_position := DBMS_LOB.INSTR(clob_object, replace_object, 1, 1);
        EXIT WHEN index_position = 0;
        DBMS_LOB.WRITE(clob_object, LENGTH(replace_object), index_position, dotted_object);
    END LOOP;
END CLOB_CENSOR;

13.
CREATE TABLE biographies AS SELECT * FROM ztpd.biographies;
14.
DECLARE
    biographies_clob CLOB;
BEGIN
    SELECT bio INTO biographies_clob
    FROM biographies
    FOR UPDATE;
    CLOB_CENSOR(biographies_clob, 'Cimrman');
    COMMIT;
END;
DROP TABLE biographies;