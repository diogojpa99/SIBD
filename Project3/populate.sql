BEGIN;
SET CONSTRAINTS ALL DEFERRED;
-- Create tables
INSERT INTO country(iso_code,name,flag)
VALUES ('PT', 'Portugal', 'https://www.nationsonline.org/flags_big/Portugal_lgflag.gif'),
       ('PR', 'Puerto Rico', 'https://www.nationsonline.org/flags_big/Puerto_Rico_lgflag.gif'),
       ('ZA', 'South Africa', 'https://www.nationsonline.org/flags_big/South_Africa_lgflag.gif'),
       ('ES', 'Spain', 'https://www.nationsonline.org/flags_big/Spain_lgflag.gif'),
       ('GB', 'United Kingdom', 'https://www.nationsonline.org/flags_big/United_Kingdom_lgflag.gif'),
       ('MC', 'Monaco', 'https://www.nationsonline.org/flags_big/Monaco_lgflag.gif'),
       ('SR', 'Suriname', 'https://www.nationsonline.org/flags_big/Suriname_lgflag.gif');

INSERT INTO person(iso_code, id, name)
VALUES ('PT', '15658898', 'Pedro Costa Rendeiro'),
       ('PT', '34558898', 'Joana Lopes Silva'),
       ('PT', '15658655', 'Maria de Jesus Rendeiro'),
       ('ES', '1565889A', 'Alberto Gines Lopez'),
       ('ES', '1587479C', 'Aida Garcia Sanchez'),
       ('GB', '68588745ZY', 'Robert Hill Smith'),
       ('GB', '69957854ZZ', 'Margareth Hilda Tatcher'),
       ('ZA', '5528558', 'Siyabonga Khumalu Mamadou');

INSERT INTO sailor(iso_code, id)
VALUES ('PT', '15658898'),   -- Pedro Costa Rendeiro
       ('PT', '15658655'),   -- Maria de Jesus Rendeiro
       ('ES', '1565889A'),   -- Alberto Gínes Lopez
       ('ES', '1587479C'),   -- Aida Garcia Sanchéz
       ('GB', '68588745ZY'), -- Robert Hill Smith
       ('GB', '69957854ZZ'), -- Margareth Hilda Tatcher
       ('ZA', '5528558');    -- Siyabonga Khumalu Mamadou


INSERT INTO owner(iso_code, id, birthdate)
VALUES ('PT', '15658898', '1960-10-05'),  -- Pedro Costa Rendeiro
       ('PT', '34558898', '1995-07-03'),  -- Joana Lopes Silva
       ('ES', '1587479C', '1990-12-25'),  -- Aida Garcia Sanchéz
       ('GB', '69957854ZZ', '1970-10-08');-- Margareth Hilda Tatcher

INSERT INTO location(name, iso_code, latitude, longitude)
VALUES ('Cascais', 'PT', 38.692239, -9.419173),
       ('Porto Santo', 'PT', 33.061985, -16.316764),
       ('Machico', 'PT', 32.717975, -16.759959),
       ('Kenton', 'ZA', -33.679573, 26.655839),
       ('Port Elizabeth', 'ZA', -33.958575, 25.635091),
       ('Monaco', 'MC', 43.737288, 7.426913),
       ('Algeciras','ES', 36.140367, -5.436428),
       ('Greenock', 'GB', 55.954055, -4.760097);

INSERT INTO marina(latitude, longitude)
VALUES (38.692239, -9.419173),  -- Cascais
       (33.061985, -16.316764), -- Porto Santo
       (43.737288, 7.426913);   -- Monaco

INSERT INTO wharf(latitude, longitude)
VALUES (-33.679573, 26.655839), -- Kenton
       (32.717975, -16.759959); -- Machico

INSERT INTO port(latitude, longitude)
VALUES (-33.958575, 25.635091), -- Port Elizabeth
       (36.140367, -5.436428),  -- Algeciras
       (55.954055, -4.760097);  -- Greenock

INSERT INTO boat(iso_code, cni, year, name, iso_code_owner, id_owner)
VALUES ('PT', '658457998', 1994, 'Estrela do Mar', 'PT', '15658898'),       -- Pedro Costa Rendeiro
       ('ES', '120000147315', 2003, 'Mi hermana', 'PT', '15658898'),        -- Pedro Costa Rendeiro
       ('ZA', '235145257', 2010, 'Fenix', 'PT', '15658898'),                -- Pedro Costa Rendeiro
       ('PT', '758457998', 1999, 'Sao Miguel', 'PT', '34558898'),           -- Joana Lopes Silva
       ('ES', '125452654778', 2015, 'Zaragoza mi amor', 'ES', '1587479C'),  -- Aida Garcia Sanchéz
       ('ES', '333452654778', 2005, 'Oh tio', 'ES', '1587479C'),            -- Aida Garcia Sanchéz
       ('GB', '111555888', 1990, 'Margareth', 'GB', '69957854ZZ'),          -- Margareth Hilda Tatcher
       ('ES', '120000333666', 1998, 'Super Margareth', 'GB', '69957854ZZ'); -- Margareth Hilda Tatcher

INSERT INTO boat_vhf(iso_code, cni, mmsi)
VALUES ('PT', '658457998', 263102054),    -- Estrela do Mar
       ('ES', '120000147315', 224147589), -- Mi hermana
       ('GB', '111555888', 225111020);    -- Margareth

INSERT INTO schedule(start_date, end_date)
VALUES ('2021-12-10', '2021-12-21'),
       ('2021-11-01', '2021-12-21'),
       ('2021-11-01', '2021-11-02'),
       ('2021-08-05', '2021-08-09');

INSERT INTO reservation(iso_code_boat, cni, start_date, end_date, iso_code_sailor, id_sailor)
VALUES ('PT', '658457998', '2021-11-01', '2021-12-21', 'PT', '15658898'),    -- Estrela do Mar, Pedro Costa Rendeiro
       ('PT', '658457998', '2021-08-05', '2021-08-09', 'PT', '15658898'),    -- Estrela do Mar, Pedro Costa Rendeiro
       ('ES', '120000147315', '2021-12-10', '2021-12-21', 'ES', '1587479C'), -- Mi hermana, Aida Garcia Sanchéz
       ('ES', '125452654778', '2021-11-01', '2021-11-02', 'ES', '1565889A'), -- Zaragoza mi amor, Alberto Gínes Lopez
       ('GB', '111555888', '2021-11-01', '2021-12-21', 'GB', '69957854ZZ');  -- Margareth, Margareth Hilda Tatcher

INSERT INTO trip(iso_code_boat, cni, start_date, end_date, iso_code_sailor, id_sailor, date, duration, start_latitude,
                 start_longitude, end_latitude, end_longitude)
VALUES ('PT', '658457998', '2021-11-01', '2021-12-21', 'PT', '15658898', '2021-11-01', 1, 38.692239, -9.419173,
        38.692239, -9.419173),  -- Estrela do Mar, Pedro Costa Rendeiro, Cascais, Cascais
       ('PT', '658457998', '2021-11-01', '2021-12-21', 'PT', '15658898', '2021-11-03', 30, 38.692239, -9.419173,
        32.717975, -16.759959), -- Estrela do Mar, Pedro Costa Rendeiro, Cascais, Machico
       ('PT', '658457998', '2021-11-01', '2021-12-21', 'PT', '15658898', '2021-12-10', 5, 32.717975, -16.759959,
        33.061985, -16.316764), -- Estrela do Mar, Pedro Costa Rendeiro, Machico, Porto Santo
       ('ES', '120000147315', '2021-12-10', '2021-12-21', 'ES', '1587479C', '2021-12-10', 7, 33.061985, -16.316764,
        32.717975, -16.759959), -- Mi hermana, Aida Garcia Sanchéz, Porto Santo, Machico
       ('GB', '111555888', '2021-11-01', '2021-12-21', 'GB', '69957854ZZ', '2021-11-01', 10, 36.140367, -5.436428,
        38.692239, -9.419173), -- Margareth, Algeciras, Cascais
       ('GB', '111555888', '2021-11-01', '2021-12-21', 'GB', '69957854ZZ', '2021-11-12', 5, 43.737288, 7.426913,
        38.692239, -9.419173); -- Margareth, Cascais, Monaco
COMMIT;