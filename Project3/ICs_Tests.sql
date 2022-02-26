--------------
--- (IC-1) ---
--------------

/* Falta verificar */


------ 1. [Should give error] ------

-- 1. Book 'Estrela do Mar' on a date 'to the left' of an existing booking [Should give error]
INSERT INTO schedule(start_date, end_date)
VALUES ('2021-10-10', '2021-11-10');

INSERT INTO reservation(iso_code_boat, cni, start_date, end_date, iso_code_sailor, id_sailor)
VALUES ('PT', '658457998', '2021-10-10', '2021-11-10', 'ES', '1587479C');    -- Estrela do Mar, Aida Garcia Sanchéz

-- 1.Test
SELECT * FROM schedule;
SELECT * FROM reservation;

-- 1.Delete
DELETE
FROM reservation
WHERE iso_code_boat = 'PT' AND cni = '658457998' AND start_date = '2021-10-10'
        AND end_date = '2021-11-10' AND iso_code_sailor = 'ES'  AND id_sailor = '1587479C';

DELETE
FROM schedule
WHERE start_date = '2021-10-10' AND end_date = '2021-11-10';

-- 1. Test
SELECT * FROM schedule;
SELECT * FROM reservation;


------ 2. [Should NOT give error] ------

-- 2. Book 'Zaragoza mi amor' on a date 'out' of any existing booking [Should NOT give error]
INSERT INTO schedule(start_date, end_date)
VALUES ('2021-12-01', '2021-12-02');

INSERT INTO reservation(iso_code_boat, cni, start_date, end_date, iso_code_sailor, id_sailor)
VALUES ('ES', '125452654778', '2021-12-01', '2021-12-02', 'PT', '15658898'); -- Zaragoza mi amor, Pedro Costa Rendeiro

-- 2.Test
SELECT * FROM schedule;
SELECT * FROM reservation;

-- 2.Delete
DELETE
FROM reservation
WHERE iso_code_boat = 'ES' AND cni = '125452654778' AND start_date = '2021-12-01'
        AND end_date = '2021-12-02' AND iso_code_sailor = 'PT'  AND id_sailor = '15658898';

DELETE
FROM schedule
WHERE start_date = '2021-12-01' AND end_date = '2021-12-02';

-- 2.Test
SELECT * FROM schedule;
SELECT * FROM reservation;


------ 3. [Should give error] ------

-- 3. Book 'Margareth' on a date 'to the right' of an existing booking [Should give error]
INSERT INTO schedule(start_date, end_date)
VALUES ('2021-12-01', '2022-01-25');

INSERT INTO reservation(iso_code_boat, cni, start_date, end_date, iso_code_sailor, id_sailor)
VALUES ('GB', '111555888', '2021-12-01', '2022-01-25', 'ES', '1565889A');  -- Margareth, Alberto Gínes Lopez

-- 3.Test
SELECT * FROM schedule;
SELECT * FROM reservation;

-- 3.Delete
DELETE
FROM reservation
WHERE iso_code_boat = 'GB' AND cni = '111555888' AND start_date = '2021-12-01'
        AND end_date = '2022-01-25' AND iso_code_sailor = 'ES'  AND id_sailor = '1565889A';

DELETE
FROM schedule
WHERE start_date = '2021-12-01' AND end_date = '2022-01-25';

-- 3.Test
SELECT * FROM schedule;
SELECT * FROM reservation;


------ 4. [Should give error] ------

-- 4. Book 'Mi hermana' on a date 'inside' of an existing booking [Should give error]
INSERT INTO reservation(iso_code_boat, cni, start_date, end_date, iso_code_sailor, id_sailor)
VALUES ('ES', '120000147315', '2021-12-15', '2021-12-15', 'ES', '1587479C'); -- Mi hermana, Aida Garcia Sanchéz




--------------
--- (IC-2) ---
--------------

/* Falta verificar */

-- Create
BEGIN;
SET CONSTRAINTS ALL DEFERRED;
INSERT INTO location(name, iso_code, latitude, longitude)
VALUES ('Nowhere', 'PT', 39.692239, -10.419173);
INSERT INTO wharf(latitude, longitude)
VALUES (32.717975, -16.759959);
COMMIT;

-- Check
SELECT *
FROM location;
SELECT *
FROM wharf;

-- Delete
BEGIN;
SET CONSTRAINTS ALL DEFERRED;
DELETE FROM marina WHERE latitude = 39.692239 and longitude=-10.419173;
DELETE FROM port WHERE latitude = 39.692239 and longitude=-10.419173;
DELETE FROM wharf WHERE latitude = 39.692239 and longitude=-10.419173;
DELETE FROM location WHERE latitude = 39.692239 and longitude=-10.419173;
COMMIT;



--------------
--- (IC-3) ---
--------------

/* Falta verificar */

INSERT INTO boat(iso_code, cni, year, name, iso_code_owner, id_owner)
VALUES ('GB', '111111111', 1994, 'NoName', 'PT', '15658898');

BEGIN;
SET CONSTRAINTS ALL DEFERRED;
DELETE FROM port WHERE (latitude, longitude) IN (
    SELECT latitude, longitude
    FROM location
    WHERE name = 'Algeciras'
    );
DELETE FROM location WHERE name = 'Algeciras';
COMMIT;