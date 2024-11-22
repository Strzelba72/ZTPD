1.
INSERT INTO user_sdo_geom_metadata VALUES
(
    'FIGURY',
    'KSZTALT',
    mdsys.sdo_dim_array(
        mdsys.sdo_dim_element('X', 0, 10, 0.01),
        mdsys.sdo_dim_element('Y', 0, 10, 0.01)),
    NULL
);
2.
SELECT sdo_tune.estimate_rtree_index_size(3000000, 8192, 10, 2, 0) FROM dual;
3.
CREATE INDEX figury_idx ON figury (ksztalt) INDEXTYPE IS mdsys.spatial_index_v2;
4.
SELECT id FROM figury WHERE sdo_filter(ksztalt,sdo_geometry(2001, NULL, sdo_point_type(3, 3, NULL), NULL, NULL)) = 'TRUE';
5.
SELECT id FROM figury WHERE sdo_relate(ksztalt,sdo_geometry(2001, NULL, sdo_point_type(3, 3, NULL), NULL, NULL),'mask=ANYINTERACT') = 'TRUE';
2 A
SELECT city_name AS miasto, sdo_nn_distance(1) AS odl
FROM major_cities
WHERE sdo_nn(
    geom,
    (SELECT geom FROM major_cities WHERE UPPER(city_name) LIKE 'WARSAW'),
    'sdo_num_res=10 unit=km',
    1
) = 'TRUE' AND UPPER(city_name) NOT LIKE 'WARSAW';
2.B
SELECT city_name AS miasto FROM major_cities
WHERE sdo_within_distance(geom,(SELECT geom FROM major_cities WHERE UPPER(city_name) LIKE 'WARSAW'),
2.C
SELECT b.cntry_name, c.city_name
FROM country_boundaries b, major_cities c
WHERE sdo_relate(c.geom, b.geom,'mask=INSIDE') = 'TRUE'
AND b.cntry_name LIKE 'Slovakia';
2.D
SELECT b2.cntry_name AS panstwo, sdo_geom.sdo_distance(b1.geom, b2.geom, 1, 'unit=km') AS odl
FROM country_boundaries b1, country_boundaries b2
WHERE sdo_relate(b1.geom, b2.geom,'mask=ANYINTERACT') <> 'TRUE'
AND b1.cntry_name LIKE 'Poland';
3.A
SELECT * FROM 
(SELECT b2.cntry_name AS panstwo, sdo_geom.sdo_length(sdo_geom.sdo_intersection(b1.geom, b2.geom, 1), 1, 'unit=km') AS granica
FROM country_boundaries b1, country_boundaries b2
WHERE b1.cntry_name LIKE 'Poland'
AND b2.cntry_name NOT LIKE 'Poland')
WHERE granica IS NOT NULL;
3.B
SELECT b.cntry_name
FROM country_boundaries b
ORDER BY sdo_geom.sdo_area(b.geom, 1) DESC
FETCH FIRST 1 ROWS ONLY;
3.C
SELECT sdo_geom.sdo_area(
(SELECT sdo_geom.sdo_mbr(
(SELECT sdo_geom.sdo_union(
    (SELECT geom FROM major_cities WHERE city_name LIKE 'Lodz'),
    (SELECT geom FROM major_cities WHERE city_name LIKE 'Warsaw'),
    1
) FROM dual)) FROM dual), 1, 'unit=sq_km') as sq_km FROM dual;
3.D
SELECT 
sdo_geom.sdo_union(b.geom, c.geom, 0.01).get_dims() ||
sdo_geom.sdo_union(b.geom, c.geom, 0.01).get_lrs_dim() ||
lpad(sdo_geom.sdo_union(b.geom, c.geom, 0.01).get_gtype(), 2, '0') as gtype
FROM country_boundaries b, major_cities c
WHERE b.cntry_name LIKE 'Poland'
AND c.city_name LIKE 'Prague';

3.E
SELECT b.cntry_name, c.city_name
FROM country_boundaries b, major_cities c
WHERE b.cntry_name = c.cntry_name
ORDER BY sdo_geom.sdo_distance(sdo_geom.sdo_centroid(b.geom, 1), c.geom, 1)
FETCH FIRST 1 ROWS ONLY;

3.F
SELECT name, SUM(dlugosc)
FROM (SELECT r.name, sdo_geom.sdo_length(sdo_geom.sdo_intersection(b.geom, r.geom, 1), 1, 'unit=km') AS dlugosc
FROM country_boundaries b, rivers r
WHERE b.cntry_name LIKE 'Poland')
WHERE dlugosc IS NOT NULL
GROUP BY name;


