-- Lab5 Diagram4 --


-- Drop tables
DROP TABLE IF EXISTS Pharmacy CASCADE;
DROP TABLE IF EXISTS Laboratory CASCADE;
DROP TABLE IF EXISTS Supervisor CASCADE;
DROP TABLE IF EXISTS appoints CASCADE;
DROP TABLE IF EXISTS contract CASCADE;
DROP TABLE IF EXISTS supervises CASCADE;


CREATE TABLE Pharmacy(
    tin VARCHAR(20),
    name VARCHAR(80) NOT NULL,
    address VARCHAR(255) NOT NULL,
    phone VARCHAR(15) NOT NULL,
    PRIMARY KEY (tin),
    UNIQUE (address),
    UNIQUE (phone)
);


CREATE TABLE Laboratory(
    name VARCHAR(80),
    phone VARCHAR(15) NOT NULL,
    PRIMARY KEY (name),
    UNIQUE (phone)
);


CREATE TABLE Supervisor(
    name VARCHAR(80),
    PRIMARY KEY (name)
);


CREATE TABLE appoints (
    tin VARCHAR(20),
    supervisor_name VARCHAR(80),
    appointment_date DATE NOT NULL,
    PRIMARY KEY (tin,supervisor_name),
    FOREIGN KEY (tin) REFERENCES Pharmacy(tin),
    FOREIGN KEY (supervisor_name) REFERENCES Supervisor(name)
    -- A Supervisor can only supervise Pharmacies for which he has been appointed
);


CREATE TABLE contract(
    tin VARCHAR(20),
    lab_name VARCHAR(80),
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    text TEXT NOT NULL,
    PRIMARY KEY (tin, lab_name),
    FOREIGN KEY (tin) REFERENCES Pharmacy(tin),
    FOREIGN KEY (lab_name) REFERENCES Laboratory(name)
    -- A Supervisor can only supervise Pharmacies for which he has been appointed
);


CREATE TABLE supervises(
    tin VARCHAR(20),
    lab_name VARCHAR(80),
    supervisor_name VARCHAR(80),
    PRIMARY KEY (tin, lab_name, supervisor_name),
    FOREIGN KEY (supervisor_name) REFERENCES Supervisor(name),
    FOREIGN KEY (tin, lab_name) REFERENCES contract(tin, lab_name)
    -- A Supervisor can only supervise Pharmacies for which he has been appointed
);