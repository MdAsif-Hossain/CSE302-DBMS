CREATE TABLE INSTRUCTOR_2022360007(
    ID NUMBER,
    NAME VARCHAR2(30),
    DEPT_NAME VARCHAR2(30),
    SALARY NUMBER
);
select * from INSTRUCTOR_2022360007;

CREATE TABLE COURSE_2022360007(
    COURSE_ID VARCHAR2(10),
    TITLE VARCHAR2(30),
    DEPT_NAME VARCHAR2(20),
    CREDITS NUMBER
);

INSERT INTO INSTRUCTOR_2022360007 VALUES(10101,'Srinivasan','Comp. Sci.',65000);
INSERT INTO INSTRUCTOR_2022360007 VALUES(12121,'Wu','Finance',90000);
INSERT INTO INSTRUCTOR_2022360007 VALUES(15151,'Mozart','Music',40000);
INSERT INTO INSTRUCTOR_2022360007 VALUES(22222,'Einstein','Physics',95000);
INSERT INTO INSTRUCTOR_2022360007 VALUES(32343,'EI Said','History',60000);
INSERT INTO INSTRUCTOR_2022360007 VALUES(33456,'Gold','Physics',87000);
INSERT INTO INSTRUCTOR_2022360007 VALUES(45565,'Katz','Comp. Sci.',75000);
INSERT INTO INSTRUCTOR_2022360007 VALUES(58583,'Califieri','History',62000);
INSERT INTO INSTRUCTOR_2022360007 VALUES(76543,'Singh','Finance',80000);
INSERT INTO INSTRUCTOR_2022360007 VALUES(76766,'Crick','Biology',72000);
INSERT INTO INSTRUCTOR_2022360007 VALUES(83821,'Brandt','Comp. Sci.',80000);
INSERT INTO INSTRUCTOR_2022360007 VALUES(98345,'Kim','Elec. Eng.',80000);


INSERT ALL
    INTO COURSE_2022360007 (COURSE_ID, TITLE, DEPT_NAME, CREDITS) VALUES ('BIO-101', 'Intro. to Biology', 'Biology', 4)
    INTO COURSE_2022360007 (COURSE_ID, TITLE, DEPT_NAME, CREDITS) VALUES ('BIO-301', 'Genetics', 'Biology', 4)
    INTO COURSE_2022360007 (COURSE_ID, TITLE, DEPT_NAME, CREDITS) VALUES ('BIO-399', 'Computational Biology', 'Biology', 3)
    INTO COURSE_2022360007 (COURSE_ID, TITLE, DEPT_NAME, CREDITS) VALUES ('CS-101', 'Intro. to Computer Science', 'Comp. Sci.', 4)
    INTO COURSE_2022360007 (COURSE_ID, TITLE, DEPT_NAME, CREDITS) VALUES ('CS-190', 'Game Design', 'Comp. Sci.', 4)
    INTO COURSE_2022360007 (COURSE_ID, TITLE, DEPT_NAME, CREDITS) VALUES ('CS-315', 'Robotics', 'Comp. Sci.', 3)
    INTO COURSE_2022360007 (COURSE_ID, TITLE, DEPT_NAME, CREDITS) VALUES ('CS-319', 'Image Processing', 'Comp. Sci.', 3)
    INTO COURSE_2022360007 (COURSE_ID, TITLE, DEPT_NAME, CREDITS) VALUES ('CS-347', 'Database System Concepts', 'Comp. Sci.', 3)
    INTO COURSE_2022360007 (COURSE_ID, TITLE, DEPT_NAME, CREDITS) VALUES ('EE-181', 'Intro. to Digital Systems', 'Elec. Eng.', 3)
    INTO COURSE_2022360007 (COURSE_ID, TITLE, DEPT_NAME, CREDITS) VALUES ('FIN-201', 'Investment Banking', 'Finance', 3)
    INTO COURSE_2022360007 (COURSE_ID, TITLE, DEPT_NAME, CREDITS) VALUES ('HIS-351', 'World History', 'History', 3)
    INTO COURSE_2022360007 (COURSE_ID, TITLE, DEPT_NAME, CREDITS) VALUES ('MU-199', 'Music Video Production', 'Music', 3)
    INTO COURSE_2022360007 (COURSE_ID, TITLE, DEPT_NAME, CREDITS) VALUES ('PHY-101', 'Physical Principles', 'Physics', 4)
SELECT * FROM dual;

select * from course_2022360007;

-- I. Show instructor name only.

SELECT NAME FROM INSTRUCTOR_2022360007;

-- II. Show course id and title only.
SELECT COURSE_ID, TITLE FROM COURSE_2022360007;

--III. Find instructor name and department of the instructor with id = 22222.
SELECT NAME, DEPT_NAME FROM INSTRUCTOR_2022360007
    WHERE ID = 22222;

--IV. Find course title and credits of the courses offered by ‘Comp. Sci.’ department.
SELECT TITLE ,CREDITS FROM COURSE_2022360007
    WHERE DEPT_NAME = 'Comp. Sci.';
    
    
--V. Find name and department of instructors who have a salary more than 70000.
SELECT NAME, DEPT_NAME FROM INSTRUCTOR_2022360007
    WHERE SALARY > 70000;
--VI. Find course title of the courses which are not less than 4 credits.
SELECT TITLE FROM COURSE_2022360007
    WHERE CREDITS >= 4
    
--VII. Find name and department of instructors who have a salary in between 80000 and 100000 (bounds
--are inclusive).

SELECT NAME, DEPT_NAME FROM INSTRUCTOR_2022360007
    WHERE Salary BETWEEN 80000 AND 100000;
    
    
--VIII. Find course titles and credits of the courses not offered by ‘Comp. Sci.’ department.

SELECT TITLE, CREDITS FROM COURSE_2022360007
    WHERE DEPT_NAME != 'Comp. Sci.';
    
-- IX. Display all records of instructor table.
SELECT * FROM INSTRUCTOR_2022360007;

--X. Find all courses (display all columns) which are offered by ‘Biology’ department
--and credits is not 4.
SELECT * FROM COURSE_2022360007
where DEPT_NAME = 'Biology' and CREDITS != 4
