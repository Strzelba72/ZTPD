1.
CREATE TYPE SAMOCHOD AS OBJECT (
    MARKA VARCHAR2(20),
    MODEL VARCHAR2(20),
    KILOMETRY NUMBER,
    DATA_PRODUKCJI DATE,
    CENA NUMBER(10,2)
);
CREATE TABLE SAMOCHODY OF SAMOCHOD;

INSERT INTO SAMOCHODY VALUES(NEW SAMOCHOD('DAEWOO','MATIZ',206000,'2000-01-04',500));
INSERT INTO SAMOCHODY VALUES(NEW SAMOCHOD('FIAT','SEICENTO',180000,'2006-05-12',2000));
INSERT INTO SAMOCHODY VALUES(NEW SAMOCHOD('VOLKSWAGEN','GOLF',150000,'2010-07-02',10000));

2.
CREATE TABLE WLASCICIELE (
    IMIE VARCHAR2(100),
    NAZWISKO VARCHAR2(100),
    AUTO SAMOCHOD
);

INSERT INTO WLASCICIELE VALUES ('JAN', 'KOWALSKI',NEW SAMOCHOD('BMW','E46',400000,'2006-03-03',5000));
INSERT INTO WLASCICIELE VALUES ('ADAM', 'NOWAK',NEW SAMOCHOD('VOLKSWAGEN','PASSAT',450000,'2001-02-03',3000));

3.
ALTER TYPE SAMOCHOD REPLACE AS OBJECT (
    MARKA VARCHAR2(20),
    MODEL VARCHAR2(20),
    KILOMETRY NUMBER,
    DATA_PRODUKCJI DATE,
    CENA NUMBER(10,2),  
    MEMBER FUNCTION WARTOSC RETURN NUMBER
);
CREATE OR REPLACE TYPE BODY SAMOCHOD AS
 MEMBER FUNCTION WARTOSC RETURN NUMBER IS
 BEGIN
 RETURN CENA * POWER(0.9, EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM DATA_PRODUKCJI));
END WARTOSC;
END;
4.
ALTER TYPE SAMOCHOD ADD MAP MEMBER FUNCTION odwzoruj RETURN NUMBER CASCADE INCLUDING TABLE DATA;

CREATE OR REPLACE TYPE BODY SAMOCHOD AS
 MEMBER FUNCTION WARTOSC RETURN NUMBER IS
 BEGIN
 RETURN CENA * POWER(0.9, EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM DATA_PRODUKCJI));
END WARTOSC;
MAP MEMBER FUNCTION odwzoruj RETURN NUMBER IS
 BEGIN
 RETURN ROUND(EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM DATA_PRODUKCJI)+KILOMETRY/10000);
 END odwzoruj;
END;

5.
CREATE OR REPLACE TYPE WLASCICIEL AS OBJECT
(
    IMIE VARCHAR(100),
    NAZWISKO VARCHAR(100),
    auto REF SAMOCHOD
);
CREATE TABLE WLASCICIELE OF WLASCICIEL;
ALTER TABLE WLASCICIELE ADD SCOPE FOR(auto) IS SAMOCHODY;
INSERT INTO WLASCICIELE VALUES (NEW WLASCICIEL('Jan', 'Kowalski', null));
UPDATE WLASCICIELE w SET w.auto = (select ref(s) FROM SAMOCHODY s WHERE s.marka = 'DAEWOO');
SELECT * FROM  WLASCICIELE;
6.
DECLARE
 TYPE t_przedmioty IS VARRAY(10) OF VARCHAR2(20);
 moje_przedmioty t_przedmioty := t_przedmioty('');
BEGIN
 moje_przedmioty(1) := 'MATEMATYKA';
 moje_przedmioty.EXTEND(9);
 FOR i IN 2..10 LOOP
 moje_przedmioty(i) := 'PRZEDMIOT_' || i;
 END LOOP;
 FOR i IN moje_przedmioty.FIRST()..moje_przedmioty.LAST() LOOP
 DBMS_OUTPUT.PUT_LINE(moje_przedmioty(i));
 END LOOP;
 moje_przedmioty.TRIM(2);
 FOR i IN moje_przedmioty.FIRST()..moje_przedmioty.LAST() LOOP
 DBMS_OUTPUT.PUT_LINE(moje_przedmioty(i));
 END LOOP;
 DBMS_OUTPUT.PUT_LINE('Limit: ' || moje_przedmioty.LIMIT());
 DBMS_OUTPUT.PUT_LINE('Liczba elementow: ' || moje_przedmioty.COUNT());
 moje_przedmioty.EXTEND();
 moje_przedmioty(9) := 9;
 DBMS_OUTPUT.PUT_LINE('Limit: ' || moje_przedmioty.LIMIT());
 DBMS_OUTPUT.PUT_LINE('Liczba elementow: ' || moje_przedmioty.COUNT());
 moje_przedmioty.DELETE();
 DBMS_OUTPUT.PUT_LINE('Limit: ' || moje_przedmioty.LIMIT());
 DBMS_OUTPUT.PUT_LINE('Liczba elementow: ' || moje_przedmioty.COUNT());
END;

7.
DECLARE    
    TYPE t_ksiazki IS VARRAY(20) OF VARCHAR2(100); 
    moje_ksiazki t_ksiazki := t_ksiazki(); 
BEGIN
    moje_ksiazki.EXTEND(3);
    moje_ksiazki(1) := 'KSIAZKA 1';
    moje_ksiazki(2) := 'KSIAZKA 2';
    moje_ksiazki(3) := 'KSIAZKA 3';
    
    DBMS_OUTPUT.PUT_LINE('Zawartość kolekcji książek:');
    FOR i IN moje_ksiazki.FIRST()..moje_ksiazki.LAST() LOOP
        DBMS_OUTPUT.PUT_LINE(moje_ksiazki(i));
    END LOOP;

	moje_ksiazki.TRIM(1); 
    DBMS_OUTPUT.PUT_LINE('Usunięto ostatni element.');
   
    DBMS_OUTPUT.PUT_LINE('Zawartość po usunięciu:');
    FOR i IN moje_ksiazki.FIRST()..moje_ksiazki.LAST() LOOP
        DBMS_OUTPUT.PUT_LINE(moje_ksiazki(i));
    END LOOP;

    moje_ksiazki.EXTEND; 
    moje_ksiazki(moje_ksiazki.LAST()) := 'KSIAZKA 4'; 
    
    DBMS_OUTPUT.PUT_LINE('Zawartość po dodaniu nowego tytułu:');
    FOR i IN moje_ksiazki.FIRST()..moje_ksiazki.LAST() LOOP
        DBMS_OUTPUT.PUT_LINE(moje_ksiazki(i));
    END LOOP;
    
    DBMS_OUTPUT.PUT_LINE('Liczba elementów w kolekcji: ' || moje_ksiazki.COUNT());
END;
8.
DECLARE
 TYPE t_wykladowcy IS TABLE OF VARCHAR2(20);
 moi_wykladowcy t_wykladowcy := t_wykladowcy();
BEGIN
 moi_wykladowcy.EXTEND(2);
 moi_wykladowcy(1) := 'MORZY';
 moi_wykladowcy(2) := 'WOJCIECHOWSKI';
 moi_wykladowcy.EXTEND(8);
 FOR i IN 3..10 LOOP
 moi_wykladowcy(i) := 'WYKLADOWCA_' || i;
 END LOOP;
 FOR i IN moi_wykladowcy.FIRST()..moi_wykladowcy.LAST() LOOP
 DBMS_OUTPUT.PUT_LINE(moi_wykladowcy(i));
 END LOOP;
 moi_wykladowcy.TRIM(2);
 FOR i IN moi_wykladowcy.FIRST()..moi_wykladowcy.LAST() LOOP
 DBMS_OUTPUT.PUT_LINE(moi_wykladowcy(i));
 END LOOP;
 moi_wykladowcy.DELETE(5,7);
 DBMS_OUTPUT.PUT_LINE('Limit: ' || moi_wykladowcy.LIMIT());
 DBMS_OUTPUT.PUT_LINE('Liczba elementow: ' || moi_wykladowcy.COUNT());
 FOR i IN moi_wykladowcy.FIRST()..moi_wykladowcy.LAST() LOOP
 IF moi_wykladowcy.EXISTS(i) THEN
 DBMS_OUTPUT.PUT_LINE(moi_wykladowcy(i));
 END IF;
 END LOOP;
 moi_wykladowcy(5) := 'ZAKRZEWICZ';
 moi_wykladowcy(6) := 'KROLIKOWSKI';
 moi_wykladowcy(7) := 'KOSZLAJDA';
 FOR i IN moi_wykladowcy.FIRST()..moi_wykladowcy.LAST() LOOP
 IF moi_wykladowcy.EXISTS(i) THEN
 DBMS_OUTPUT.PUT_LINE(moi_wykladowcy(i));
 END IF;
 END LOOP;
 DBMS_OUTPUT.PUT_LINE('Limit: ' || moi_wykladowcy.LIMIT());
 DBMS_OUTPUT.PUT_LINE('Liczba elementow: ' || moi_wykladowcy.COUNT());
END;
9.
DECLARE
 TYPE miesiace IS TABLE OF VARCHAR2(20);
 moje_miesiace miesiace := miesiace();
BEGIN
 moje_miesiace.EXTEND(12);
 FOR i IN 1..12 LOOP
 moje_miesiace(i) := 'MIESIAC' || i;
 END LOOP;
 FOR i IN moje_miesiace.FIRST()..moje_miesiace.LAST() LOOP
 DBMS_OUTPUT.PUT_LINE(moje_miesiace(i));
 END LOOP;
 moje_miesiace.TRIM(2);
 FOR i IN moje_miesiace.FIRST()..moje_miesiace.LAST() LOOP
 DBMS_OUTPUT.PUT_LINE(moje_miesiace(i));
 END LOOP;
 moje_miesiace.DELETE(1,7);
 DBMS_OUTPUT.PUT_LINE('Limit: ' || moje_miesiace.LIMIT());
 DBMS_OUTPUT.PUT_LINE('Liczba elementow: ' || moje_miesiace.COUNT());
 FOR i IN moje_miesiace.FIRST()..moje_miesiace.LAST() LOOP
 IF moje_miesiace.EXISTS(i) THEN
 DBMS_OUTPUT.PUT_LINE(moje_miesiace(i));
 END IF;
 END LOOP;
 moje_miesiace(5) := 'MAJ';
 moje_miesiace(6) := 'CZERWIEC';
 moje_miesiace(7) := 'LIPIEC';
 FOR i IN moje_miesiace.FIRST()..moje_miesiace.LAST() LOOP
 IF moje_miesiace.EXISTS(i) THEN
 DBMS_OUTPUT.PUT_LINE(moje_miesiace(i));
 END IF;
 END LOOP;
 DBMS_OUTPUT.PUT_LINE('Limit: ' || moje_miesiace.LIMIT());
 DBMS_OUTPUT.PUT_LINE('Liczba elementow: ' || moje_miesiace.COUNT());
END;

10.
CREATE TYPE jezyki_obce AS VARRAY(10) OF VARCHAR2(20);
/
CREATE TYPE stypendium AS OBJECT (
 nazwa VARCHAR2(50),
 kraj VARCHAR2(30),
 jezyki jezyki_obce );
/
CREATE TABLE stypendia OF stypendium;
INSERT INTO stypendia VALUES
('SOKRATES','FRANCJA',jezyki_obce('ANGIELSKI','FRANCUSKI','NIEMIECKI'));
INSERT INTO stypendia VALUES
('ERASMUS','NIEMCY',jezyki_obce('ANGIELSKI','NIEMIECKI','HISZPANSKI'));
SELECT * FROM stypendia;
SELECT s.jezyki FROM stypendia s;
UPDATE STYPENDIA
SET jezyki = jezyki_obce('ANGIELSKI','NIEMIECKI','HISZPANSKI','FRANCUSKI')
WHERE nazwa = 'ERASMUS';
CREATE TYPE lista_egzaminow AS TABLE OF VARCHAR2(20);
/
CREATE TYPE semestr AS OBJECT (
 numer NUMBER,
 egzaminy lista_egzaminow );
/
CREATE TABLE semestry OF semestr
NESTED TABLE egzaminy STORE AS tab_egzaminy;
INSERT INTO semestry VALUES
(semestr(1,lista_egzaminow('MATEMATYKA','LOGIKA','ALGEBRA')));
INSERT INTO semestry VALUES
(semestr(2,lista_egzaminow('BAZY DANYCH','SYSTEMY OPERACYJNE')));
SELECT s.numer, e.*
FROM semestry s, TABLE(s.egzaminy) e;
SELECT e.*
FROM semestry s, TABLE ( s.egzaminy ) e;
SELECT * FROM TABLE ( SELECT s.egzaminy FROM semestry s WHERE numer=1 );
INSERT INTO TABLE ( SELECT s.egzaminy FROM semestry s WHERE numer=2 )
VALUES ('METODY NUMERYCZNE');
UPDATE TABLE ( SELECT s.egzaminy FROM semestry s WHERE numer=2 ) e
SET e.column_value = 'SYSTEMY ROZPROSZONE'
WHERE e.column_value = 'SYSTEMY OPERACYJNE';
DELETE FROM TABLE ( SELECT s.egzaminy FROM semestry s WHERE numer=2 ) e
WHERE e.column_value = 'BAZY DANYCH';
11.
CREATE TYPE koszyk_produktow AS TABLE OF VARCHAR2(50);
/
CREATE TYPE zakup AS OBJECT (
    id_zakupu NUMBER,
    data_zakupu DATE,
    koszyk koszyk_produktow
);
/
CREATE TABLE zakupy OF zakup
NESTED TABLE koszyk STORE AS koszyk_produktow_tab;
/
INSERT INTO zakupy VALUES (
    zakup(1, SYSDATE, koszyk_produktow('Chleb', 'Mleko', 'Chipsy'))
);
INSERT INTO zakupy VALUES (
    zakup(2, SYSDATE, koszyk_produktow('Jablka', 'Sok', 'Ciastka'))
);
INSERT INTO zakupy VALUES (
    zakup(3, SYSDATE, koszyk_produktow('Makaron', 'Ser', 'Sos pomidorowy'))
);
SELECT * FROM zakupy;
SELECT z.id_zakupu, p.COLUMN_VALUE AS produkt
FROM zakupy z, TABLE(z.koszyk) p;
DELETE FROM zakupy z
WHERE EXISTS (
    SELECT 1
    FROM TABLE(z.koszyk) p
    WHERE p.COLUMN_VALUE = 'Makaron'
);
SELECT * FROM zakupy;
12.
CREATE TYPE instrument AS OBJECT (
 nazwa VARCHAR2(20),
 dzwiek VARCHAR2(20),
 MEMBER FUNCTION graj RETURN VARCHAR2 ) NOT FINAL;
CREATE TYPE BODY instrument AS
 MEMBER FUNCTION graj RETURN VARCHAR2 IS
 BEGIN
 RETURN dzwiek;
 END;
END;
/
CREATE TYPE instrument_dety UNDER instrument (
 material VARCHAR2(20),
 OVERRIDING MEMBER FUNCTION graj RETURN VARCHAR2,
 MEMBER FUNCTION graj(glosnosc VARCHAR2) RETURN VARCHAR2 );
CREATE OR REPLACE TYPE BODY instrument_dety AS
 OVERRIDING MEMBER FUNCTION graj RETURN VARCHAR2 IS
 BEGIN
 RETURN 'dmucham: '||dzwiek;
 END;
 MEMBER FUNCTION graj(glosnosc VARCHAR2) RETURN VARCHAR2 IS
 BEGIN
 RETURN glosnosc||':'||dzwiek;
 END;
END;
/
CREATE TYPE instrument_klawiszowy UNDER instrument (
 producent VARCHAR2(20),
 OVERRIDING MEMBER FUNCTION graj RETURN VARCHAR2 );
CREATE OR REPLACE TYPE BODY instrument_klawiszowy AS
 OVERRIDING MEMBER FUNCTION graj RETURN VARCHAR2 IS
 BEGIN
 RETURN 'stukam w klawisze: '||dzwiek;
 END;
END;
/
DECLARE
 tamburyn instrument := instrument('tamburyn','brzdek-brzdek');
 trabka instrument_dety := instrument_dety('trabka','tra-ta-ta','metalowa');
 fortepian instrument_klawiszowy := instrument_klawiszowy('fortepian','pingping','steinway');
BEGIN
 dbms_output.put_line(tamburyn.graj);
 dbms_output.put_line(trabka.graj);
 dbms_output.put_line(trabka.graj('glosno'));
 dbms_output.put_line(fortepian.graj);
END;
13.
CREATE TYPE istota AS OBJECT (
 nazwa VARCHAR2(20),
 NOT INSTANTIABLE MEMBER FUNCTION poluj(ofiara CHAR) RETURN CHAR )
 NOT INSTANTIABLE NOT FINAL;
CREATE TYPE lew UNDER istota (
 liczba_nog NUMBER,
 OVERRIDING MEMBER FUNCTION poluj(ofiara CHAR) RETURN CHAR );
CREATE OR REPLACE TYPE BODY lew AS
 OVERRIDING MEMBER FUNCTION poluj(ofiara CHAR) RETURN CHAR IS
 BEGIN
 RETURN 'upolowana ofiara: '||ofiara;
 END;
END;
DECLARE
 KrolLew lew := lew('LEW',4);
 InnaIstota istota := istota('JAKIES ZWIERZE');
BEGIN
 DBMS_OUTPUT.PUT_LINE( KrolLew.poluj('antylopa') );
END;
14.
DECLARE
 tamburyn instrument;
 cymbalki instrument;
 trabka instrument_dety;
 saksofon instrument_dety;
BEGIN
 tamburyn := instrument('tamburyn','brzdek-brzdek');
 cymbalki := instrument_dety('cymbalki','ding-ding','metalowe');
 trabka := instrument_dety('trabka','tra-ta-ta','metalowa');
 -- saksofon := instrument('saksofon','tra-taaaa');
 -- saksofon := TREAT( instrument('saksofon','tra-taaaa') AS instrument_dety);
END;
15.

CREATE TABLE instrumenty OF instrument;
INSERT INTO instrumenty VALUES ( instrument('tamburyn','brzdek-brzdek') );
INSERT INTO instrumenty VALUES ( instrument_dety('trabka','tra-ta-ta','metalowa')
);
INSERT INTO instrumenty VALUES ( instrument_klawiszowy('fortepian','pingping','steinway') );
SELECT i.nazwa, i.graj() FROM instrumenty i;




