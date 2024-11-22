1. A
CREATE TABLE a6_lrs (
    geom SDO_GEOMETRY
);
1. B
INSERT INTO a6_lrs (
SELECT sr.geom
FROM streets_and_railroads sr
WHERE sdo_within_distance(
    (SELECT geom FROM major_cities WHERE city_name = 'Koszalin'),
    sr.geom,
    'distance=10 unit=km') = 'TRUE');
1. C
SELECT sdo_geom.sdo_length(a.geom, 1, 'unit=km') as distance,
    st_linestring(a.geom).st_numpoints() as st_numpoints
FROM a6_lrs a;
1. D
UPDATE a6_lrs
SET geom = sdo_lrs.convert_to_lrs_geom(geom, 0, 276,681315399186);
1. E
INSERT INTO user_sdo_geom_metadata
VALUES(
    'A6_LRS', 
    'GEOM',
    mdsys.sdo_dim_array(
        mdsys.sdo_dim_element('X', 12.603676, 26.369824, 1),
        mdsys.sdo_dim_element('Y', 45.8464, 58.0213, 1),
        mdsys.sdo_dim_element('M', 0, 300, 1)),
    8307);
1. F
CREATE INDEX a6_lrs_idx
ON a6_lrs(geom)
INDEXTYPE IS MDSYS.SPATIAL_INDEX;

2. A
SELECT sdo_lrs.valid_measure(geom, 500) AS valid_500 FROM A6_LRS;
2. B
SELECT sdo_lrs.geom_segment_end_pt(geom) FROM a6_lrs;
2. C
SELECT sdo_lrs.locate_pt(geom, 150, 0) km150 FROM a6_lrs;
2. D
SELECT sdo_lrs.clip_geom_segment(geom, 120, 160) clipped FROM a6_lrs;
2. E
SELECT sdo_lrs.project_pt(a6.geom, c.geom) WJAZD_NA_A6
FROM a6_lrs a6, major_cities c
WHERE c.city_name = 'Slupsk';
2. F
SELECT sdo_geom.sdo_length(sdo_lrs.offset_geom_segment(a6.geom, m.diminfo, 50, 200, 50, 'unit=m'), 1, 'unit=km') as koszt
FROM a6_lrs a6, user_sdo_geom_metadata m
WHERE m.table_name = 'A6_LRS' AND m.column_name = 'GEOM';