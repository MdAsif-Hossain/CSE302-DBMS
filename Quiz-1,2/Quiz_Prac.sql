-- Create Patient Table
CREATE TABLE Patient (
    patient_id VARCHAR2(10) PRIMARY KEY,
    name VARCHAR2(100),
    gender VARCHAR2(10),
    date_of_birth DATE,
    contact_number VARCHAR2(15),
    address VARCHAR2(255)
);

-- Create Doctor Table
CREATE TABLE Doctor (
    doctor_id VARCHAR2(10) PRIMARY KEY,
    name VARCHAR2(100),
    specialization VARCHAR2(50),
    contact_number VARCHAR2(15),
    email VARCHAR2(100),
    department_id VARCHAR2(10)
);

-- Create Appointments Table
CREATE TABLE Appointments (
    appointment_id NUMBER PRIMARY KEY,
    patient_id VARCHAR2(10),
    doctor_id VARCHAR2(10),
    appointment_date DATE,
    appointment_time VARCHAR2(10),
    reason_for_visit VARCHAR2(255),
    FOREIGN KEY (patient_id) REFERENCES Patient(patient_id),
    FOREIGN KEY (doctor_id) REFERENCES Doctor(doctor_id)
);

-- Create MedicalRecords Table
CREATE TABLE MedicalRecords (
    record_id NUMBER PRIMARY KEY,
    patient_id VARCHAR2(10),
    doctor_id VARCHAR2(10),
    date_of_visit DATE,
    diagnosis VARCHAR2(255),
    prescribed_medications VARCHAR2(255),
    FOREIGN KEY (patient_id) REFERENCES Patient(patient_id),
    FOREIGN KEY (doctor_id) REFERENCES Doctor(doctor_id)
);

-- Create Departments Table
CREATE TABLE Departments (
    department_id VARCHAR2(10) PRIMARY KEY,
    department_name VARCHAR2(100),
    department_head VARCHAR2(100),
    number_of_employees NUMBER
);


-- Insert Data into Patient Table
INSERT INTO Patient VALUES ('P-1', 'John Smith', 'Male', TO_DATE('1985-08-10', 'YYYY-MM-DD'), '1234567890', '123 Main St');
INSERT INTO Patient VALUES ('P-2', 'Jane Doe', 'Female', TO_DATE('1990-04-15', 'YYYY-MM-DD'), '9876543210', '456 Elm St');
INSERT INTO Patient VALUES ('P-3', 'Michael Johnson', 'Male', TO_DATE('1978-12-22', 'YYYY-MM-DD'), '5551234567', '789 Oak Ave');

-- Insert Data into Doctor Table
INSERT INTO Doctor VALUES ('D-1', 'Dr. Emily Adams', 'Cardiology', '5559876543', 'emily.adams@example.com', 'DEPT-1');
INSERT INTO Doctor VALUES ('D-2', 'Dr. Robert Davis', 'Pediatrics', '5551234567', 'robert.davis@example.com', 'DEPT-2');
INSERT INTO Doctor VALUES ('D-3', 'Dr. Sarah Wilson', 'Orthopedics', '5552223333', 'sarah.wilson@example.com', 'DEPT-3');

-- Insert Data into Appointments Table
INSERT INTO Appointments VALUES (1, 'P-1', 'D-1', TO_DATE('2023-07-17', 'YYYY-MM-DD'), '10:00 AM', 'Chest pain');
INSERT INTO Appointments VALUES (2, 'P-2', 'D-3', TO_DATE('2023-07-18', 'YYYY-MM-DD'), '2:30 PM', 'Broken arm');
INSERT INTO Appointments VALUES (3, 'P-3', 'D-2', TO_DATE('2023-07-19', 'YYYY-MM-DD'), '9:15 AM', 'Fever');

-- Insert Data into MedicalRecords Table
INSERT INTO MedicalRecords VALUES (101, 'P-1', 'D-1', TO_DATE('2023-07-17', 'YYYY-MM-DD'), 'Angina', 'Nitroglycerin');
INSERT INTO MedicalRecords VALUES (201, 'P-2', 'D-3', TO_DATE('2023-07-18', 'YYYY-MM-DD'), 'Fractured radius', 'Painkillers, Cast');
INSERT INTO MedicalRecords VALUES (301, 'P-3', 'D-2', TO_DATE('2023-07-19', 'YYYY-MM-DD'), 'Influenza', 'Antipyretics');

-- Insert Data into Departments Table
INSERT INTO Departments VALUES ('DEPT-1', 'Cardiology', 'Dr. Emily Adams', 5);
INSERT INTO Departments VALUES ('DEPT-2', 'Pediatrics', 'Dr. Robert Davis', 7);
INSERT INTO Departments VALUES ('DEPT-3', 'Orthopedics', 'Dr. Sarah Wilson', 4);

SELECT * FROM Patient;
SELECT * FROM Doctor;
SELECT * FROM Appointments;
SELECT * FROM MedicalRecords;

--1. Retrieve the names of patients who have appointments with doctors specializing in "Cardiology."

SELECT DISTINCT P.name
FROM Patient P
WHERE P.patient_id IN (
    SELECT A.patient_id
    FROM Appointments A
    WHERE A.doctor_id IN (
        SELECT D.doctor_id
        FROM Doctor D
        WHERE D.specialization = 'Cardiology'
    )
);

--2. Find the names of patients who have visited the same doctor more than once.

SELECT P.name
FROM Patient P
WHERE P.patient_id IN (
    SELECT A.patient_id
    FROM Appointments A
    GROUP BY A.patient_id, A.doctor_id
    HAVING COUNT(*) > 1
);

-- 3. Retrieve the names of patients who have not had any appointments.
SELECT P.name
FROM Patient P
WHERE P.patient_id NOT IN (
    SELECT A.patient_id
    FROM Appointments A
);

--4. Retrieve the names of doctors with more than the average number of appointments. Use the WITH clause.

/*SELECT COUNT(*) AS AppointmentCount
FROM Appointments
GROUP BY doctor_id;*/

WITH AvgAppointments AS (
    SELECT AVG(AppointmentCount) AS AvgCount
    FROM (
        SELECT COUNT(*) AS AppointmentCount
        FROM Appointments
        GROUP BY doctor_id
    )
)
SELECT D.name
FROM Doctor D
JOIN (
    SELECT doctor_id, COUNT(*) AS AppointmentCount
    FROM Appointments
    GROUP BY doctor_id
) A ON D.doctor_id = A.doctor_id
WHERE A.AppointmentCount > (SELECT AvgCount FROM AvgAppointments);

--5. List the names of doctors who have treated patients of both genders. Use nested subqueries in the FROM clause.
SELECT D.name
FROM Doctor D
WHERE D.doctor_id IN (
    SELECT doctor_id
    FROM (
        SELECT doctor_id, COUNT(DISTINCT gender) AS GenderCount
        FROM Appointments A
        JOIN Patient P ON A.patient_id = P.patient_id
        GROUP BY doctor_id
    ) T
    WHERE T.GenderCount = 2
);

--6. Find the department name with the least number of employees. Use the ALL keyword.
SELECT department_name
FROM Departments
WHERE number_of_employees <= ALL (
    SELECT number_of_employees
    FROM Departments
);


