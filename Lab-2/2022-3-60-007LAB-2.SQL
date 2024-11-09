DROP TABLE customer CASCADE CONSTRAINTS;
DROP TABLE depositor CASCADE CONSTRAINTS;
DROP TABLE account CASCADE CONSTRAINTS;

-- Table: account
CREATE TABLE account (
    account_no CHAR(5) PRIMARY KEY,
    balance NUMBER NOT NULL CHECK (balance >= 0)
);

-- Table: customer
CREATE TABLE customer (
    customer_no CHAR(5) PRIMARY KEY,
    customer_name VARCHAR2(20) NOT NULL,
    customer_city VARCHAR2(10)
);

-- Table: depositor
CREATE TABLE depositor (
    account_no CHAR(5),
    customer_no CHAR(5),
    PRIMARY KEY (account_no, customer_no),
    FOREIGN KEY (account_no) REFERENCES account(account_no),
    FOREIGN KEY (customer_no) REFERENCES customer(customer_no)
);


-- i. Add a new attribute 'date_of_birth' (DATE type) in the customer table
ALTER TABLE customer
ADD date_of_birth DATE;

-- ii. Drop the attribute 'date_of_birth' from the customer table
ALTER TABLE customer
DROP COLUMN date_of_birth;

-- iii. Rename the attribute 'account_no' and 'customer_no' in depositor table to 'a_no' and 'c_no', respectively
ALTER TABLE depositor
RENAME COLUMN account_no TO a_no;

ALTER TABLE depositor
RENAME COLUMN customer_no TO c_no;
------
select * from account;
select * from depositor;

SELECT constraint_name, constraint_type
FROM user_constraints
WHERE table_name = 'DEPOSITOR';

-- Drop the existing foreign key constraints with system-generated names
ALTER TABLE depositor
DROP CONSTRAINT SYS_C007489;

ALTER TABLE depositor
DROP CONSTRAINT SYS_C007490;
-- Add foreign key constraint 'depositor_fk1' on a_no referencing account(account_no)
ALTER TABLE depositor
ADD CONSTRAINT depositor_fk1 FOREIGN KEY (a_no) REFERENCES account(account_no);
-- Add foreign key constraint 'depositor_fk2' on c_no referencing customer(customer_no);
ALTER TABLE depositor
ADD CONSTRAINT depositor_fk2 FOREIGN KEY (c_no) REFERENCES customer(customer_no);



-- Insert records into the account table
INSERT INTO account (account_no, balance) VALUES ('A-101', 12000);
INSERT INTO account (account_no, balance) VALUES ('A-102', 6000);
INSERT INTO account (account_no, balance) VALUES ('A-103', 2500);

-- Insert records into the customer table
INSERT INTO customer (customer_no, customer_name, customer_city) VALUES ('C-101', 'Alice', 'Dhaka');
INSERT INTO customer (customer_no, customer_name, customer_city) VALUES ('C-102', 'Annie', 'Dhaka');
INSERT INTO customer (customer_no, customer_name, customer_city) VALUES ('C-103', 'Bob', 'Chittagong');
INSERT INTO customer (customer_no, customer_name, customer_city) VALUES ('C-104', 'Charlie', 'Khulna');

-- Insert records into the depositor table
INSERT INTO depositor (a_no, c_no) VALUES ('A-101', 'C-101');
INSERT INTO depositor (a_no, c_no) VALUES ('A-103', 'C-102');
INSERT INTO depositor (a_no, c_no) VALUES ('A-103', 'C-104');
INSERT INTO depositor (a_no, c_no) VALUES ('A-102', 'C-103');


--i. Display customer name and customer city only.
SELECT customer_name, customer_city
FROM customer;

--ii. Display the unique customer city. No repetitions are allowed.
SELECT DISTINCT customer_city
FROM customer;

--iii. Find account numbers with balance more than 7000.
SELECT account_no
FROM account
WHERE balance > 7000;

--iv. Find customer number and customer name who live in Khulna.
SELECT customer_no, customer_name
FROM customer
WHERE customer_city = 'Khulna';

--v. Find customer number and customer name who do not live in Dhaka.
SELECT customer_no, customer_name
FROM customer
WHERE customer_city <> 'Dhaka';

--vi. Find customer name and customer city who have accounts with balance more than 7000.
SELECT c.customer_name, c.customer_city
FROM customer c
JOIN depositor d ON c.customer_no = d.c_no
JOIN account a ON d.a_no = a.account_no
WHERE a.balance > 7000;

--vii. Find customer name and customer city who have accounts with balance more than 7000 and do not live in Khulna.
SELECT c.customer_name, c.customer_city
FROM customer c
JOIN depositor d ON c.customer_no = d.c_no
JOIN account a ON d.a_no = a.account_no
WHERE a.balance > 7000 AND c.customer_city <> 'Khulna';

--viii. Find account number and balance for those accounts which belong to a customer with ID 'C-102'.

SELECT a.account_no, a.balance
FROM account a
JOIN depositor d ON a.account_no = d.a_no
WHERE d.c_no = 'C-102';


--ix. Find all account numbers and balances for those accounts which belong to customers of Dhaka and Khulna city.
SELECT a.account_no, a.balance
FROM account a
JOIN depositor d ON a.account_no = d.a_no
JOIN customer c ON d.c_no = c.customer_no
WHERE c.customer_city IN ('Dhaka', 'Khulna');

--x. Find the customer who have no accounts. [Result of this query will be empty for this dataset, but the correct SQL is as follows]

SELECT customer_no, customer_name
FROM customer
WHERE customer_no NOT IN (SELECT c_no FROM depositor);








