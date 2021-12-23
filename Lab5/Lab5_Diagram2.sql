-- Lab5 Diagram2 --

-- Drop tables
DROP TABLE IF EXISTS Person CASCADE;
DROP TABLE IF EXISTS Car CASCADE;
DROP TABLE IF EXISTS owns CASCADE;
DROP TABLE IF EXISTS involved_in CASCADE;
DROP TABLE IF EXISTS Accident CASCADE;



CREATE TABLE Person(
    driver_id INTEGER,
    address VARCHAR(255) NOT NULL,
    name VARCHAR(80) NOT NULL,
    PRIMARY KEY (driver_id),
    UNIQUE (address, name)
);


CREATE TABLE Car(
    license VARCHAR(10),
    model VARCHAR(30) NOT NULL,
    year SMALLINT NOT NULL,  -- SMALLINT em vez de DATE (Atenção)
    PRIMARY KEY(license)
);


CREATE TABLE owns(
    driver_id INTEGER,
    license VARCHAR(10),
    PRIMARY KEY (driver_id),
    FOREIGN KEY (driver_id) REFERENCES Person(driver_id),
    FOREIGN KEY (license) REFERENCES Car(license)
);


CREATE TABLE Accident(
    report_id INTEGER,
    location VARCHAR(255) NOT NULL,
    date DATE NOT NULL,
    PRIMARY KEY (report_id)
);


CREATE TABLE involved_in(
    report_id INTEGER,
    driver_id INTEGER,
    license VARCHAR(10),
    total_damage NUMERIC(16,4) NOT NULL,
    PRIMARY KEY (report_id, driver_id, license),
    FOREIGN KEY (driver_id) REFERENCES Person(driver_id),
    FOREIGN KEY (license) REFERENCES Car(license),
    FOREIGN KEY (report_id) REFERENCES Accident(report_id)
);