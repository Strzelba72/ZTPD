1.
CREATE TABLE figury (
    id NUMBER(1) PRIMARY KEY,
    ksztalt MDSYS.SDO_GEOMETRY
);
2.
INSERT INTO figury VALUES
(
    1,
    MDSYS.SDO_GEOMETRY(
        2003,
        NULL,
        NULL,
        SDO_ELEM_INFO_ARRAY(1, 1003, 4),
        SDO_ORDINATE_ARRAY(3, 5, 5, 7, 7, 5)
    )
);

INSERT INTO figury VALUES 
(
    2,
    MDSYS.SDO_GEOMETRY(
        2003,
        NULL,
        NULL,
        SDO_ELEM_INFO_ARRAY(1, 1003, 3),
        SDO_ORDINATE_ARRAY(1, 1, 5, 5)
    )
);

INSERT INTO figury VALUES 
(
    3,
    MDSYS.SDO_GEOMETRY(
        2002,
        NULL,
        NULL,
        SDO_ELEM_INFO_ARRAY(1, 4, 2, 1,2,1, 5,2,2),
        SDO_ORDINATE_ARRAY(3,2,6,2,7,3,8,2,7,1)
    )
);

INSERT INTO figury VALUES 
(
    3,
    MDSYS.SDO_GEOMETRY(
        2002,
        NULL,
        NULL,
        SDO_ELEM_INFO_ARRAY(1, 4, 2, 1,2,1, 5,2,2),
        SDO_ORDINATE_ARRAY(3,2,6,2,7,3,8,2,7,1)
    )
);
c)
INSERT INTO figury VALUES
(
    4,
    MDSYS.SDO_GEOMETRY(
        2003,
        NULL,
        NULL,
        SDO_ELEM_INFO_ARRAY(1, 1003, 4),
        SDO_ORDINATE_ARRAY(3, 5, 5, 5, 7, 5)
    )
);
d)
SELECT id, SDO_GEOM.VALIDATE_GEOMETRY_WITH_CONTEXT(ksztalt, 0.005) FROM figury;
e)
DELETE FROM figury
WHERE SDO_GEOM.VALIDATE_GEOMETRY_WITH_CONTEXT(ksztalt, 0.005) <> 'TRUE';
COMMIT;