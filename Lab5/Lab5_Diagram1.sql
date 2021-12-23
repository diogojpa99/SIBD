-- Lab5 Diagram1 --

-- Drop tables
DROP TABLE IF EXISTS Department CASCADE;
DROP TABLE IF EXISTS Freelancer CASCADE;
DROP TABLE IF EXISTS works_at CASCADE;
DROP TABLE IF EXISTS Contract CASCADE;
DROP TABLE IF EXISTS Permanent CASCADE;
DROP TABLE IF EXISTS Employee CASCADE;

CREATE TABLE Employee (
    eid INTEGER,
    name VARCHAR(80) NOT NULL,
    birthdate DATE NOT NULL,
    PRIMARY KEY (eid)
    -- (IC_1) Every employee birthdate must be smaller than the 'since' DATE referenced in the works_at table
    -- Every employee must be either in the table Freelancer or (exclusive) the table Permanent
);

CREATE TABLE Department(
    did INTEGER,
    name VARCHAR (80) NOT NULL,
    budget NUMERIC (16,4) NOT NULL,
    PRIMARY KEY (did)
);

CREATE TABLE works_at(
    did INTEGER,
    eid INTEGER,
    since DATE NOT NULL,
    PRIMARY KEY (eid),
    FOREIGN KEY (eid) REFERENCES Employee(eid),
    FOREIGN KEY (did) REFERENCES Department(did)
    -- (IC_1) 'since' DATE must be after the 'birthdate' referenced in the table Employee
);

CREATE TABLE Freelancer(
    eid INTEGER,
    job VARCHAR(30) NOT NULL,
    hour_rate NUMERIC(16,4) NOT NULL,
    PRIMARY KEY (eid),
    FOREIGN KEY (eid) REFERENCES Employee (eid)
);

CREATE TABLE Permanent(
    eid INTEGER,
    PRIMARY KEY (eid),
    FOREIGN KEY (eid) REFERENCES Employee (eid)
);

CREATE TABLE Contract(
    eid INTEGER,
    role VARCHAR (30),
    salary NUMERIC (12,4) NOT NULL,
    PRIMARY KEY (role, eid),
    FOREIGN KEY (eid) REFERENCES Permanent (eid)
);