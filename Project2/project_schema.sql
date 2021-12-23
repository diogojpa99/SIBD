-- Project Part 2 Schema --

DROP TABLE IF EXISTS Location CASCADE;
DROP TABLE IF EXISTS Marina CASCADE;
DROP TABLE IF EXISTS Warf CASCADE;
DROP TABLE IF EXISTS Port CASCADE;
DROP TABLE IF EXISTS Country CASCADE;
DROP TABLE IF EXISTS Schedule CASCADE;
DROP TABLE IF EXISTS Boat CASCADE;
DROP TABLE IF EXISTS Boat_with_VHF CASCADE;
DROP TABLE IF EXISTS Person CASCADE;
DROP TABLE IF EXISTS Owner CASCADE;
DROP TABLE IF EXISTS Sailor CASCADE;
DROP TABLE IF EXISTS reservation CASCADE;
DROP TABLE IF EXISTS Trip CASCADE;


CREATE TABLE Country(
    iso_code VARCHAR(3),
    name VARCHAR(70) NOT NULL,
    flag VARCHAR(2083) NOT NULL,
    PRIMARY KEY (iso_code),
    UNIQUE (name),
    UNIQUE (flag)
);

CREATE TABLE Location (
    latitude NUMERIC(8,6),
    longitude NUMERIC(9,6),
    name VARCHAR(30) NOT NULL,
    authority_iso_code VARCHAR(3) NOT NULL,
    PRIMARY KEY (latitude, longitude),
    FOREIGN KEY (authority_iso_code) REFERENCES Country (iso_code)
    -- Every location must be either in the table 'Marina', 'Warf' or 'Port'
    -- No location can exist in the tree (or two out of those tree) tables ('Marina', 'Warf' or 'Port') at the same time;
    -- (IC_3): Acho que poderia dar para fazer com Queries, pode ser algo interessante para colocar no relatório
);


CREATE TABLE Marina(
    latitude NUMERIC(8,6),
    longitude NUMERIC(9,6),
    PRIMARY KEY (latitude, longitude),
    FOREIGN KEY (latitude,longitude) REFERENCES Location (latitude, longitude)
);


CREATE TABLE Warf(
    latitude NUMERIC(8,6),
    longitude NUMERIC(9,6),
    PRIMARY KEY (latitude, longitude),
    FOREIGN KEY (latitude,longitude) REFERENCES Location (latitude, longitude)
);


CREATE TABLE Port(
    latitude NUMERIC(8,6),
    longitude NUMERIC(9,6),
    PRIMARY KEY (latitude, longitude),
    FOREIGN KEY (latitude,longitude) REFERENCES Location (latitude, longitude)
);


CREATE TABLE  Schedule(
    start_date DATE,
    end_date DATE,
    PRIMARY KEY (start_date, end_date),
    CHECK(end_date > start_date)
    -- (IC_1): Reservation schedules of a boat must not overlap; Será que se pode fazer mais alguma coisa aqui ??
    -- Every Schedule must be in the table 'reservation'
);



CREATE TABLE Person(
    iso_code VARCHAR(3),
    id_card INTEGER,
    name VARCHAR(80) NOT NULL,
    PRIMARY KEY (iso_code, id_card),
    FOREIGN KEY (iso_code) REFERENCES Country (iso_code)
    -- Every person must exist in the table 'Sailor' or 'Owner'
);


CREATE TABLE Owner(
    iso_code VARCHAR(3),
    id_card INTEGER,
    birthdate DATE NOT NULL,
    PRIMARY KEY (iso_code, id_card),
    FOREIGN KEY (iso_code, id_card) REFERENCES Person (iso_code, id_card)
    -- Every Owner must exist in the table 'Boat'
);


CREATE TABLE Sailor(
    iso_code VARCHAR(3),
    id_card INTEGER,
    PRIMARY KEY (iso_code, id_card),
    FOREIGN KEY (iso_code, id_card) REFERENCES Person (iso_code, id_card)
);

CREATE TABLE Boat(
    iso_code VARCHAR(3),
    cni INTEGER,
    name VARCHAR(80) NOT NULL,
    year SMALLINT NOT NULL,
    length NUMERIC(6,4) NOT NULL,
    owner_id_card INTEGER NOT NULL,
    owner_iso_code VARCHAR(3) NOT NULL,
    PRIMARY KEY (iso_code,cni),
    FOREIGN KEY (iso_code) REFERENCES Country (iso_code),
    FOREIGN KEY (owner_iso_code,owner_id_card) REFERENCES Owner (iso_code, id_card)
);

CREATE TABLE Boat_with_VHF(
    iso_code VARCHAR(3),
    cni INTEGER,
    mmsi INTEGER NOT NULL ,
    PRIMARY KEY (iso_code,cni),
    FOREIGN KEY (iso_code, cni) REFERENCES Boat (iso_code, cni)
);


CREATE TABLE reservation(
    boat_iso_code VARCHAR(3),
    boat_cni INTEGER,
    sailor_iso_code VARCHAR(3),
    sailor_id_card INTEGER,
    start_date DATE,
    end_date DATE,
    PRIMARY KEY (boat_iso_code, boat_cni, sailor_iso_code, sailor_id_card, start_date, end_date),
    FOREIGN KEY (sailor_iso_code, sailor_id_card) REFERENCES Sailor (iso_code, id_card),
    FOREIGN KEY (boat_iso_code, boat_cni) REFERENCES Boat (iso_code, cni),
    FOREIGN KEY (start_date, end_date) REFERENCES Schedule (start_date, end_date)
    -- (IC_1): Reservation schedules of a boat must not overlap;
    -- (IC_2): Trips of a reservation must not overlap;
);


CREATE TABLE Trip(
    boat_iso_code VARCHAR(3),
    boat_cni INTEGER,
    sailor_iso_code VARCHAR(3),
    sailor_id_card INTEGER,
    reservation_start_date DATE,
    reservation_end_date DATE,
    date DATE,
    duration DATE NOT NULL,
    to_latitude NUMERIC(8,6) NOT NULL,
    to_longitude NUMERIC(9,6) NOT NULL,
    from_latitude NUMERIC(8,6) NOT NULL,
    from_longitude NUMERIC(9,6) NOT NULL,
    PRIMARY KEY (boat_iso_code, boat_cni, sailor_iso_code, sailor_id_card, reservation_start_date, reservation_end_date, date),
    FOREIGN KEY (boat_iso_code, boat_cni, sailor_iso_code, sailor_id_card, reservation_start_date, reservation_end_date)
                 REFERENCES reservation (boat_iso_code, boat_cni, sailor_iso_code, sailor_id_card, start_date, end_date),
    FOREIGN KEY (to_latitude, to_longitude) REFERENCES Location(latitude, longitude),
    FOREIGN KEY (from_latitude, from_longitude) REFERENCES Location(latitude, longitude)

    -- Trips of a reservation must not overlap;
);