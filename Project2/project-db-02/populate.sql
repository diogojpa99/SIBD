INSERT INTO country
VALUES ('PRT', 'Portugal', 'https://www.nationsonline.org/flags_big/Portugal_lgflag.gif'),
       ('PRI', 'Puerto Rico', 'https://www.nationsonline.org/flags_big/Puerto_Rico_lgflag.gif'),
       ('ZAF', 'South Africa', 'https://www.nationsonline.org/flags_big/South_Africa_lgflag.gif'),
       ('ESP', 'Spain', 'https://www.nationsonline.org/flags_big/Spain_lgflag.gif'),
       ('GBR', 'United Kingdom', 'https://www.nationsonline.org/flags_big/United_Kingdom_lgflag.gif'),
       ('MCO', 'Monaco', 'https://www.nationsonline.org/flags_big/Monaco_lgflag.gif');

INSERT INTO person
VALUES ('PRT', '15658898', 'Pedro Costa Rendeiro'),
       ('PRT', '34558898', 'Joana Lopes Silva'),
       ('PRT', '15658655', 'Maria de Jesus Rendeiro'),
       ('ESP', '1565889A', 'Alberto Gínes Lopez'),
       ('ESP', '1587479C', 'Aida Garcia Sanchéz');

INSERT INTO sailor
VALUES ('PRT', '15658898'), -- Pedro Costa Rendeiro
       ('PRT', '15658655'), -- Maria de Jesus Rendeiro
       ('ESP', '1565889A'), -- Alberto Gínes Lopez
       ('ESP', '1587479C'); -- Aida Garcia Sanchéz


INSERT INTO owner
VALUES ('PRT', '15658898', '1960-10-05'),  -- Pedro Costa Rendeiro
       ('PRT', '34558898', '1995-07-03'),  -- Joana Lopes Silva
       ('ESP', '1587479C', '1990-12-25');  -- Aida Garcia Sanchéz

INSERT INTO location
VALUES ('Cascais', 'PRT', 38.692239, -9.419173),
       ('Porto Santo', 'PRT', 33.061985, -16.316764),
       ('Machico', 'PRT', 32.717975, -16.759959),
       ('Kenton', 'ZAF', -33.679573, 26.655839),
       ('Port Elizabeth', 'ZAF', -33.958575, 25.635091),
       ('Monaco', 'MCO', 43.737288, 7.426913);

INSERT INTO marina
VALUES (38.692239, -9.419173),  -- Cascais
       (33.061985, -16.316764), -- Porto Santo
       (43.737288, 7.426913);   -- Monaco

INSERT INTO wharf
VALUES (-33.679573, 26.655839), -- Kenton
       (32.717975, -16.759959); -- Machico

INSERT INTO port
VALUES (-33.958575, 25.635091); -- Port Elizabeth

INSERT INTO boat
VALUES ('PRT', 658457998, 1994, 'Estrela do Mar', 90.0, 'PRT', '15658898'),       -- Pedro Costa Rendeiro
       ('ESP', 120000147315, 2003, 'Mi hermana', 50.0, 'PRT', '15658898'),        -- Pedro Costa Rendeiro
       ('ZAF', 235145257, 2010, 'Fenix', 70.0, 'PRT', '15658898'),                -- Pedro Costa Rendeiro
       ('PRT', 758457998, 1999, 'São Miguel', 20.0, 'PRT', '34558898'),           -- Joana Lopes Silva
       ('ESP', 125452654778, 2015, 'Zaragoza mi amor', 30.0, 'ESP', '1587479C');  -- Aida Garcia Sanchéz

INSERT INTO boat_vhf
VALUES ('PRT', 658457998, 263102054),    -- Estrela do Mar
       ('ESP', 120000147315, 224147589); -- 'Mi hermana'

INSERT INTO schedule
VALUES ('2021-12-10', '2021-12-21'),
       ('2021-11-01', '2021-12-21'),
       ('2021-11-01', '2021-11-02'),
       ('2021-08-05', '2021-08-09');

INSERT INTO reservation
VALUES ('PRT', 658457998, '2021-11-01', '2021-12-21', 'PRT', '15658898'),    -- Estrela do Mar, Pedro Costa Rendeiro
       ('PRT', 658457998, '2021-08-05', '2021-08-09', 'PRT', '15658898'),    -- Estrela do Mar, Pedro Costa Rendeiro
       ('ESP', 120000147315, '2021-12-10', '2021-12-21', 'ESP', '1587479C'), -- Mi hermana, Aida Garcia Sanchéz
       ('ESP', 125452654778, '2021-11-01', '2021-11-02', 'ESP', '1565889A'); -- Zaragoza mi amor, Alberto Gínes Lopez

INSERT INTO trip
VALUES ('PRT', 658457998, '2021-11-01', '2021-12-21', 'PRT', '15658898', '2021-11-01', 1, 38.692239, -9.419173,
        38.692239, -9.419173),  -- Estrela do Mar, Pedro Costa Rendeiro, Cascais, Cascais
       ('PRT', 658457998, '2021-11-01', '2021-12-21', 'PRT', '15658898', '2021-11-03', 30, 38.692239, -9.419173,
        32.717975, -16.759959), -- Estrela do Mar, Pedro Costa Rendeiro, Cascais, Machico
       ('PRT', 658457998, '2021-11-01', '2021-12-21', 'PRT', '15658898', '2021-12-10', 5, 32.717975, -16.759959,
        33.061985, -16.316764), -- Estrela do Mar, Pedro Costa Rendeiro, Machico, Porto Santo
       ('ESP', 120000147315, '2021-12-10', '2021-12-21', 'ESP', '1587479C', '2021-12-10', 7, 33.061985, -16.316764,
        32.717975, -16.759959); -- Mi hermana, Aida Garcia Sanchéz, Porto Santo, Machico