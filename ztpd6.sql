1. A
select lpad('-',2*(level-1),'|-') || t.owner||'.'||t.type_name||' (FINAL:'||t.final||
', INSTANTIABLE:'||t.instantiable||', ATTRIBUTES:'||t.attributes||', METHODS:'||t.methods||')'
from all_types t
start with t.type_name = 'ST_GEOMETRY'
connect by prior t.type_name = t.supertype_name 
 and prior t.owner = t.owner;
1. B
select distinct m.method_name
from all_type_methods m
where m.type_name like 'ST_POLYGON'
and m.owner = 'MDSYS'
order by 1;
1. C
CREATE TABLE MYST_MAJOR_CITIES(
FIPS_CNTRY VARCHAR2(2),
CITY_NAME VARCHAR2(40),
STGEOM ST_POINT );
1. D
INSERT INTO myst_major_cities (
    SELECT fips_cntry, city_name, TREAT(ST_POINT(geom) as ST_POINT) FROM major_cities
);
2
SELECT C.FIPS_CNTRY, C.STGEOM.GET_WKT() WKT FROM MYST_MAJOR_CITIES C;
INSERT INTO myst_major_cities VALUES (
    'PL',
    'Szczyrk',
    new ST_POINT(19.036107, 49.718655)
);
3. A
CREATE TABLE myst_country_boundaries (
    fips_cntry VARCHAR2(2),
    cntry_name VARCHAR2(40),
    stgeom ST_MULTIPOLYGON
);
3. B
INSERT INTO myst_country_boundaries (
    SELECT fips_cntry, cntry_name, TREAT(ST_MULTIPOLYGON(geom) AS ST_MULTIPOLYGON) from country_boundaries
);
3. C
SELECT c.stgeom.st_geometrytype() as typ_obiektu, count(*) as ile
FROM myst_country_boundaries c
GROUP BY c.stgeom.st_geometrytype();
3. D
SELECT c.stgeom.st_issimple()
FROM myst_country_boundaries c;

4. A
UPDATE myst_major_cities 
SET STGEOM = new ST_POINT(19.036107, 49.718655, 8307)
WHERE CITY_NAME = 'Szczyrk';

SELECT b.cntry_name, count(*)
FROM myst_country_boundaries b, myst_major_cities c
WHERE c.stgeom.st_within(b.stgeom) = 1
GROUP BY b.cntry_name;

4. B
SELECT b1.cntry_name
FROM myst_country_boundaries b1, myst_country_boundaries b2
WHERE b1.stgeom.st_touches(b2.stgeom) = 1
AND b2.cntry_name LIKE 'Czech Republic';

4. C
SELECT b.cntry_name, r.name
FROM myst_country_boundaries b, rivers r
WHERE b.cntry_name LIKE 'Czech Republic'
AND st_linestring(r.geom).st_intersects(b.stgeom) = 1;

4. D
SELECT TREAT(b.stgeom.st_union(c.stgeom) as st_polygon).st_area() as powierzchnia
FROM myst_country_boundaries b, myst_country_boundaries c
WHERE b.cntry_name LIKE 'Slovakia' AND c.cntry_name LIKE 'Czech Republic';

4. E

SELECT b.stgeom.st_geometrytype() as obiekt, TREAT(b.stgeom.st_difference(st_geometry(c.geom)) as st_polygon).st_geometrytype() as wegry_bez
FROM myst_country_boundaries b, water_bodies c
WHERE b.cntry_name LIKE 'Hungary' and c.name LIKE 'Balaton';

5. A
EXPLAIN PLAN FOR
SELECT b.cntry_name, COUNT(*)
FROM myst_major_cities c, myst_country_boundaries b
WHERE sdo_within_distance(c.stgeom, b.stgeom, 'distance=100 unit=km') = 'TRUE' AND b.cntry_name = 'Poland'
GROUP BY b.cntry_name;
SELECT plan_table_output FROM TABLE(dbms_xplan.display());

5. B
INSERT INTO user_sdo_geom_metadata (
    SELECT 'MYST_MAJOR_CITIES', 'STGEOM', diminfo,srid
    FROM all_sdo_geom_metadata
    WHERE table_name = 'MAJOR_CITIES'
);
5. C
CREATE INDEX myst_major_cities_idx
ON myst_major_cities(stgeom)
INDEXTYPE IS mdsys.spatial_index_v2;
5. D
EXPLAIN PLAN FOR
SELECT b.cntry_name, COUNT(*)
FROM myst_major_cities c, myst_country_boundaries b
WHERE sdo_within_distance(c.stgeom, b.stgeom, 'distance=100 unit=km') = 'TRUE'
AND b.cntry_name = 'Poland'
GROUP BY b.cntry_name;
SELECT plan_table_output FROM TABLE(dbms_xplan.display());
