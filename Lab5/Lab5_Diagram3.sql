-- Lab5 Diagram3 --

-- Drop tables
DROP TABLE IF EXISTS Course CASCADE;
DROP TABLE IF EXISTS Program CASCADE;
DROP TABLE IF EXISTS Student CASCADE;
DROP TABLE IF EXISTS Course_offering CASCADE;
DROP TABLE IF EXISTS Instructor CASCADE;
DROP TABLE IF EXISTS requires CASCADE;
DROP TABLE IF EXISTS comprise CASCADE;
DROP TABLE IF EXISTS registers CASCADE;
DROP TABLE IF EXISTS enrols CASCADE;
DROP TABLE IF EXISTS teaches CASCADE;


CREATE TABLE Course(
    course_num INTEGER,
    title VARCHAR(80) NOT NULL,
    syllabus TEXT NOT NULL,
    credits SMALLINT NOT NULL,
    PRIMARY KEY (course_num)
);


CREATE TABLE Program(
    name VARCHAR(80),
    PRIMARY KEY (name)
    -- Every program must be in the table 'comprises'
);


CREATE TABLE Student(
    sid INTEGER,
    name VARCHAR(80) NOT NULL,
    PRIMARY KEY (sid)
    -- Every student must be in the table 'registers'
);


CREATE TABLE Course_offering(
    year SMALLINT,
    semester SMALLINT,
    course_num INTEGER,
    PRIMARY KEY (course_num,year, semester),
    FOREIGN KEY (course_num) REFERENCES Course(course_num)
);


CREATE TABLE Instructor(
    id INTEGER,
    name VARCHAR(80) NOT NULL ,
    department VARCHAR(80) NOT NULL,
    PRIMARY KEY (id)
    -- Every teacher must be present in the table 'teaches'
);


CREATE TABLE requires(
    pre_course_num INTEGER,
    main_course_num INTEGER,
    PRIMARY KEY (pre_course_num, main_course_num),
    FOREIGN KEY (pre_course_num) REFERENCES Course(course_num),
    FOREIGN KEY (main_course_num) REFERENCES Course(course_num),
    CHECK( pre_course_num <> requires.main_course_num) -- (IC_1)
    -- (IC_2) Courses cannot require one another circularly: Acho que isto deve dar para fazer com CHECK e Nested queries
);


CREATE TABLE comprise (
    course_num INTEGER,
    name VARCHAR(80),
    PRIMARY KEY (course_num,name),
    FOREIGN KEY (course_num) REFERENCES Course(course_num),
    FOREIGN KEY (name) REFERENCES Program(name)
);


CREATE TABLE registers(
    name VARCHAR(80),
    sid INTEGER,
    PRIMARY KEY (name, sid),
    FOREIGN KEY (name) REFERENCES Program(name),
    FOREIGN KEY (sid) REFERENCES Student(sid)
);


CREATE TABLE enrols
(
    sid        INTEGER,
    course_num INTEGER,
    year       SMALLINT,
    semester   SMALLINT,
    grade  SMALLINT NOT NULL,
    PRIMARY KEY (sid, course_num, year, semester),
    FOREIGN KEY (sid) REFERENCES Student (sid),
    FOREIGN KEY (course_num, year, semester) REFERENCES course_offering(course_num, year, semester) -- Atenção

);


CREATE TABLE teaches(
    course_num INTEGER,
    year SMALLINT,
    semester SMALLINT,
    instructor_id INTEGER,
    PRIMARY KEY (course_num, year, semester),
    FOREIGN KEY (course_num, year, semester) REFERENCES course_offering(course_num, year, semester),
    FOREIGN KEY (instructor_id) REFERENCES Instructor(id)
);