-- Drop tables
DROP TABLE IF EXISTS country CASCADE;
DROP TABLE IF EXISTS person CASCADE;
DROP TABLE IF EXISTS sailor CASCADE;
DROP TABLE IF EXISTS owner CASCADE;
DROP TABLE IF EXISTS location CASCADE;
DROP TABLE IF EXISTS marina CASCADE;
DROP TABLE IF EXISTS wharf CASCADE;
DROP TABLE IF EXISTS port CASCADE;
DROP TABLE IF EXISTS boat CASCADE;
DROP TABLE IF EXISTS boat_vhf CASCADE;
DROP TABLE IF EXISTS schedule CASCADE;
DROP TABLE IF EXISTS reservation CASCADE;
DROP TABLE IF EXISTS trip CASCADE;

-- Create tables
CREATE TABLE country
(
    iso_code CHAR(3),
    name     VARCHAR(70)   NOT NULL,
    flag     VARCHAR(2083) NOT NULL,

    PRIMARY KEY (iso_code),
    UNIQUE (name),
    UNIQUE (flag)
);

CREATE TABLE person
(
    iso_code CHAR(3),
    id_card  VARCHAR(30),
    name     VARCHAR(80) NOT NULL,

    PRIMARY KEY (iso_code, id_card),
    FOREIGN KEY (iso_code) REFERENCES country (iso_code)

    -- Every element in table 'person' must exist either in the table 'sailor' or
    -- in the table 'owner';
);

CREATE TABLE sailor
(
    iso_code CHAR(3),
    id_card  VARCHAR(30),

    PRIMARY KEY (iso_code, id_card),
    FOREIGN KEY (iso_code, id_card) REFERENCES person (iso_code, id_card)
);

CREATE TABLE owner
(
    iso_code CHAR(3),
    id_card  VARCHAR(30),
    birthday DATE NOT NULL,

    PRIMARY KEY (iso_code, id_card),
    FOREIGN KEY (iso_code, id_card) REFERENCES person (iso_code, id_card)

    -- Every owner must exist in the table 'boat' refering to 'own';
);

CREATE TABLE location
(
    name      VARCHAR(70) NOT NULL,
    iso_code  CHAR(3)     NOT NULL,
    latitude  NUMERIC(8, 6),
    longitude NUMERIC(9, 6),

    PRIMARY KEY (latitude, longitude),
    FOREIGN KEY (iso_code) REFERENCES country (iso_code)

    -- Any two elements in table 'location' should be at least 1 mile apart;

    -- Every element in table 'location' must exist in one of the following tables:
    -- 'marina', 'wharf' or 'port';

    -- Each location can only exists at one of the following tables: 'marina',
    -- 'wharf' and 'port';
);

CREATE TABLE marina
(
    latitude  NUMERIC(8, 6),
    longitude NUMERIC(9, 6),

    PRIMARY KEY (latitude, longitude),
    FOREIGN KEY (latitude, longitude) REFERENCES location (latitude, longitude)
);

CREATE TABLE wharf
(
    latitude  NUMERIC(8, 6),
    longitude NUMERIC(9, 6),

    PRIMARY KEY (latitude, longitude),
    FOREIGN KEY (latitude, longitude) REFERENCES location (latitude, longitude)
);

CREATE TABLE port
(
    latitude  NUMERIC(8, 6),
    longitude NUMERIC(9, 6),

    PRIMARY KEY (latitude, longitude),
    FOREIGN KEY (latitude, longitude) REFERENCES location (latitude, longitude)
);

CREATE TABLE boat
(
    iso_code     CHAR(3),
    cni          NUMERIC(30),
    year         SMALLINT      NOT NULL,
    name         VARCHAR(70)   NOT NULL,
    length       NUMERIC(5, 1) NOT NULL,

    own_iso_code CHAR(3)       NOT NULL,
    own_id_card  VARCHAR(30)   NOT NULL,

    PRIMARY KEY (iso_code, cni),
    FOREIGN KEY (iso_code) REFERENCES country (iso_code),
    FOREIGN KEY (own_iso_code, own_id_card) REFERENCES owner (iso_code, id_card)
);

CREATE TABLE boat_vhf
(
    iso_code CHAR(3),
    cni      NUMERIC(30),
    mmsi     NUMERIC(9) NOT NULL,

    PRIMARY KEY (iso_code, cni),
    FOREIGN KEY (iso_code, cni) REFERENCES boat (iso_code, cni)
);

CREATE TABLE schedule
(
    start_date DATE,
    end_date   DATE,

    PRIMARY KEY (start_date, end_date),
    CHECK (end_date > start_date)

    -- Schedules must exist in the table 'reservation';
);

CREATE TABLE reservation
(
    boat_iso_code       CHAR(3),
    boat_cni            NUMERIC(30),

    schedule_start_date DATE,
    schedule_end_date   DATE,

    sailor_iso_code     CHAR(3),
    sailor_id_card      VARCHAR(30),

    PRIMARY KEY (boat_iso_code, boat_cni, schedule_start_date, schedule_end_date, sailor_iso_code, sailor_id_card),
    FOREIGN KEY (boat_iso_code, boat_cni) REFERENCES boat (iso_code, cni),
    FOREIGN KEY (schedule_start_date, schedule_end_date) REFERENCES schedule (start_date, end_date),
    FOREIGN KEY (sailor_iso_code, sailor_id_card) REFERENCES sailor (iso_code, id_card)

    -- Reservation schedules of a boat must not overlap;
);

CREATE TABLE trip
(
    boat_iso_code       CHAR(3),
    boat_cni            NUMERIC(30),
    schedule_start_date DATE,
    schedule_end_date   DATE,
    sailor_iso_code     CHAR(3),
    sailor_id_card      VARCHAR(30),

    date                DATE,
    duration            INTEGER NOT NULL,

    from_latitude       NUMERIC(8, 6) NOT NULL,
    from_longitude      NUMERIC(9, 6) NOT NULL,

    to_latitude         NUMERIC(8, 6) NOT NULL,
    to_longitude        NUMERIC(9, 6) NOT NULL,

    PRIMARY KEY (boat_iso_code, boat_cni, schedule_start_date, schedule_end_date, sailor_iso_code, sailor_id_card,
                 date),
    FOREIGN KEY (boat_iso_code, boat_cni, schedule_start_date, schedule_end_date, sailor_iso_code,
                 sailor_id_card) REFERENCES reservation (boat_iso_code, boat_cni, schedule_start_date,
                                                         schedule_end_date, sailor_iso_code, sailor_id_card),
    FOREIGN KEY (from_latitude, from_longitude) REFERENCES location (latitude, longitude),
    FOREIGN KEY (to_latitude, to_longitude) REFERENCES location (latitude, longitude),

    CHECK (duration > 0)

    -- Trips of a reservation must not overlap;
);