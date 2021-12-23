-- Lab5 Diagram5 --


-- Drop tables
DROP TABLE IF EXISTS Instrument CASCADE;
DROP TABLE IF EXISTS Musician CASCADE;
DROP TABLE IF EXISTS Address CASCADE;
DROP TABLE IF EXISTS Music CASCADE;
DROP TABLE IF EXISTS Album CASCADE;
DROP TABLE IF EXISTS plays CASCADE;
DROP TABLE IF EXISTS participates CASCADE;
DROP TABLE IF EXISTS consits_of CASCADE;


CREATE TABLE Instrument(
    name VARCHAR(80),
    tonality VARCHAR(80) NOT NULL,
    PRIMARY KEY (name)
);



CREATE TABLE Address(
    postal_code VARCHAR(12),
    street VARCHAR(255),
    city VARCHAR(30),
    country VARCHAR(70),
    line_phone VARCHAR(15) NOT NULL,
    PRIMARY KEY (postal_code, street, city, country),
    UNIQUE (line_phone)
    -- Every Address must exist in the table 'Musician'
);


CREATE TABLE Musician(
    idc INTEGER,
    phone_number VARCHAR(15) NOT NULL,
    address_postal_code VARCHAR(12) NOT NULL,
    address_street VARCHAR(255) NOT NULL,
    address_city VARCHAR(30) NOT NULL,
    address_country VARCHAR(70) NOT NULL,
    PRIMARY KEY (idc),
    UNIQUE (phone_number),
    FOREIGN KEY (address_city,address_country, address_postal_code, address_street) REFERENCES Address(postal_code, street, city, country)
);


CREATE TABLE Music(
    title VARCHAR(80),
    author VARCHAR(80),
    PRIMARY KEY (title, author)
    -- Every Music must exist in the table 'participates'
);


CREATE TABLE Album(
    id INTEGER,
    release_date DATE NOT NULL,
    title VARCHAR(80) NOT NULL,
    producer_idc INTEGER NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (producer_idc) REFERENCES Musician(idc)
    -- Every Album must exist in the table 'consists_of'
);


CREATE TABLE plays(
    instrument_name VARCHAR(80),
    idc INTEGER,
    PRIMARY KEY (instrument_name,idc),
    FOREIGN KEY (instrument_name) REFERENCES Instrument(name),
    FOREIGN KEY (idc) REFERENCES Musician(idc)
);


CREATE TABLE participates(
    idc INTEGER,
    title VARCHAR(80),
    author VARCHAR(80),
    PRIMARY KEY (idc, title, author),
    FOREIGN KEY (idc) REFERENCES Musician(idc),
    FOREIGN KEY (title, author) REFERENCES Music(title, author)
);

CREATE TABLE consists_of(
    title VARCHAR(80),
    author VARCHAR(80),
    album_id INTEGER NOT NULL,
    PRIMARY KEY(title, author),
    FOREIGN KEY (title, author) REFERENCES Music(title, author),
    FOREIGN KEY (album_id) REFERENCES Album(id)
);