--zad 1
CREATE TABLE CYTATY AS (SELECT * FROM ztpd.cytaty);
--zad 2
SELECT * FROM CYTATY WHERE UPPER(tekst) LIKE UPPER('%pesymista%') AND UPPER(tekst) LIKE UPPER('%optymista%');
--zad 3
CREATE INDEX cytaty_idx ON cytaty(tekst)
INDEXTYPE IS CTXSYS.CONTEXT;
--zad 4
SELECT * FROM CYTATY WHERE CONTAINS(TEKST, 'optymista and pesymista') > 0;
--zad 5
SELECT * FROM cytaty
WHERE CONTAINS(tekst, 'pesymista not optymista') > 0;
--zad 6
SELECT * FROM cytaty
WHERE CONTAINS(tekst, 'near((pesymista, optymista), 3)') > 0;
--zad 7
SELECT * FROM cytaty
WHERE CONTAINS(tekst, 'near((pesymista, optymista), 10)') > 0;
--zad 8
SELECT * FROM cytaty
WHERE CONTAINS(tekst, 'życi%') > 0;
--zad 9
SELECT c.autor, c.tekst, score(1) as DOPASOWANIE FROM cytaty c
WHERE CONTAINS(tekst, 'życi%', 1) > 0;
-- zad 10
SELECT c.autor, c.tekst, score(1) as DOPASOWANIE FROM cytaty c
WHERE CONTAINS(tekst, 'życi%', 1) > 0
ORDER BY score(1) DESC
FETCH FIRST ROW ONLY;
--zad 11
SELECT c.autor, c.tekst FROM cytaty c
WHERE CONTAINS(tekst, 'fuzzy(probelm)') > 0;
--zad 12
INSERT INTO cytaty VALUES
(39, 'Bernard Russel', 'To smutne, że głupcy są tacy pewni siebie, a ludzie rozsądni tacy pełni wątpliwości.');
COMMIT;
--zad 13
SELECT * FROM cytaty
WHERE CONTAINS(tekst, 'głupcy') > 0;
--zad 14
SELECT * FROM dr$cytaty_idx$i
WHERE token_text = 'GŁUPCY';
--zad 15
CREATE  INDEX cytaty_idx ON cytaty(tekst)
INDEXTYPE IS CTXSYS.CONTEXT;
--zad 16
SELECT * FROM dr$cytaty_idx$i
WHERE token_text = 'GŁUPCY';
--zad 17
SELECT * FROM cytaty
WHERE CONTAINS(tekst, 'głupcy') > 0;
--zad 18
DROP INDEX cytaty_idx;
DROP TABLE cytaty;

--zad 1
CREATE TABLE quotes AS (SELECT * FROM ztpd.quotes);

--zad 2
CREATE INDEX cytaty_idx ON quotes(text)
INDEXTYPE IS CTXSYS.CONTEXT;

--zad 3
SELECT * FROM quotes
WHERE CONTAINS(text, 'work') > 0;
SELECT * FROM quotes
WHERE CONTAINS(text, '$work') > 0;
SELECT * FROM quotes
WHERE CONTAINS(text, 'working') > 0;
SELECT * FROM quotes
WHERE CONTAINS(text, '$working') > 0;

--zad 4
SELECT * FROM quotes
WHERE CONTAINS(text, 'it') > 0;

--zad 5
SELECT * FROM ctx_stoplists;

--zad 6
SELECT * FROM ctx_stopwords;

--zad 7
DROP INDEX cytaty_idx;

CREATE INDEX quotes_idx ON quotes(text)
INDEXTYPE IS CTXSYS.CONTEXT
PARAMETERS ('STOPLIST CTXSYS.EMPTY_STOPLIST');

--zad 8
SELECT * FROM quotes
WHERE CONTAINS(text, 'it') > 0;

--zad 9
SELECT * FROM quotes
WHERE CONTAINS(text, 'fool and humans') > 0;

--zad 10
SELECT * FROM quotes
WHERE CONTAINS(text, 'fool and computer') > 0;

--zad 11
SELECT * FROM quotes
WHERE CONTAINS(text, '(fool and humans) within sentence') > 0;

--zad 12
DROP INDEX quotes_idx;

--zad 13
begin
 ctx_ddl.create_section_group('nullgroup', 'NULL_SECTION_GROUP');
 ctx_ddl.add_special_section('nullgroup', 'SENTENCE');
 ctx_ddl.add_special_section('nullgroup', 'PARAGRAPH');
end;
/
--zad 14
CREATE INDEX quotes_idx ON quotes(text)
INDEXTYPE IS CTXSYS.CONTEXT
PARAMETERS ('STOPLIST CTXSYS.EMPTY_STOPLIST SECTION GROUP nullgroup');

--zad 15
SELECT * FROM quotes
WHERE CONTAINS(text, '(fool and computer) within sentence') > 0;

SELECT * FROM quotes
WHERE CONTAINS(text, '(fool and humans) within sentence') > 0;

--zad 16

SELECT * FROM quotes
WHERE CONTAINS(text, 'humans') > 0;

--zad 17
DROP INDEX quotes_idx;
begin
 ctx_ddl.create_preference('lex_z_m','BASIC_LEXER');
 ctx_ddl.set_attribute('lex_z_m', 'printjoins', '_-');
 ctx_ddl.set_attribute ('lex_z_m', 'index_text', 'YES');
end;

CREATE INDEX quotes_idx ON quotes(text)
INDEXTYPE IS CTXSYS.CONTEXT
PARAMETERS ('STOPLIST CTXSYS.EMPTY_STOPLIST SECTION GROUP nullgroup LEXER lex_z_m');

--zad 18
SELECT * FROM quotes
WHERE CONTAINS(text, 'humans') > 0;

--zad 19

SELECT * FROM quotes
WHERE CONTAINS(text, 'non\-humans') > 0;

DROP TABLE quotes;

BEGIN
    ctx_ddl.drop_preference('lex_z_m');
END;
/

