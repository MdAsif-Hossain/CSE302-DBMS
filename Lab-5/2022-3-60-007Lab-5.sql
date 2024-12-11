@C:\Users\Asif\Downloads\University.sql

--1. Find all customer-related information who have an account in a branch located in the same city where they live.
SELECT c.customer_name, c.customer_street, c.customer_city
FROM Customer c
JOIN Depositor d ON c.customer_name = d.customer_name
JOIN Account a ON d.account_number = a.account_number
JOIN Branch b ON a.branch_name = b.branch_name
WHERE c.customer_city = b.branch_city;

--With Sub Query
SELECT customer_name, customer_street, customer_city
FROM Customer
WHERE customer_city IN (
    SELECT branch_city
    FROM Branch b
    JOIN Account a ON b.branch_name = a.branch_name
    JOIN Depositor d ON a.account_number = d.account_number
    WHERE d.customer_name = Customer.customer_name
);

--2. Find all customer-related information who have a loan in a branch located in the same city where they live.
--Without using subqueries:
SELECT c.customer_name, c.customer_street, c.customer_city
FROM Customer c
JOIN Borrower bo ON c.customer_name = bo.customer_name
JOIN Loan l ON bo.loan_number = l.loan_number
JOIN Branch b ON l.branch_name = b.branch_name
WHERE c.customer_city = b.branch_city;

--With using subqueries:
SELECT customer_name, customer_street, customer_city
FROM Customer
WHERE customer_city IN (
    SELECT branch_city
    FROM Branch b
    JOIN Loan l ON b.branch_name = l.branch_name
    JOIN Borrower bo ON l.loan_number = bo.loan_number
    WHERE bo.customer_name = Customer.customer_name
);
--3. For each branch city, find the average balance of all accounts in that city. Exclude branch cities where the total balance is less than 1000.
--Without using HAVING:
SELECT b.branch_city, AVG(a.balance) AS avg_balance
FROM Branch b
JOIN Account a ON b.branch_name = a.branch_name
WHERE b.branch_city NOT IN (
    SELECT branch_city
    FROM (
        SELECT b_sub.branch_city, SUM(a_sub.balance) AS total_balance
        FROM Branch b_sub
        JOIN Account a_sub ON b_sub.branch_name = a_sub.branch_name
        GROUP BY b_sub.branch_city
    )
    WHERE total_balance < 1000
)
GROUP BY b.branch_city;



SELECT b.branch_city, AVG(a.balance) AS avg_balance
FROM Branch b
JOIN Account a ON b.branch_name = a.branch_name
GROUP BY b.branch_city
HAVING SUM(a.balance) >= 1000;

--4. For each branch city, find the average loan amount. Exclude branch cities where the average loan amount is less than 1500.
--Without using HAVING:
SELECT b.branch_city, AVG(l.amount) AS avg_loan_amount
FROM Branch b
JOIN Loan l ON b.branch_name = l.branch_name
WHERE b.branch_city NOT IN (
    SELECT branch_city
    FROM (
        SELECT b_sub.branch_city, AVG(l_sub.amount) AS avg_loan
        FROM Branch b_sub
        JOIN Loan l_sub ON b_sub.branch_name = l_sub.branch_name
        GROUP BY b_sub.branch_city
    )
    WHERE avg_loan < 1500
)
GROUP BY b.branch_city;

SELECT b.branch_city, AVG(l.amount) AS avg_loan_amount
FROM Branch b
JOIN Loan l ON b.branch_name = l.branch_name
GROUP BY b.branch_city
HAVING AVG(l.amount) >= 1500;

--5. Find the customer with the account having the highest balance.
--Without using ALL:
SELECT c.customer_name, c.customer_street, c.customer_city
FROM Customer c
JOIN Depositor d ON c.customer_name = d.customer_name
JOIN Account a ON d.account_number = a.account_number
WHERE a.balance = (SELECT MAX(balance) FROM Account);


SELECT c.customer_name, c.customer_street, c.customer_city
FROM Customer c
JOIN Depositor d ON c.customer_name = d.customer_name
JOIN Account a ON d.account_number = a.account_number
WHERE a.balance >= ALL (SELECT balance FROM Account);

--6. Find the customer with the loan having the lowest amount.
--Without using ALL:
SELECT c.customer_name, c.customer_street, c.customer_city
FROM Customer c
JOIN Borrower bo ON c.customer_name = bo.customer_name
JOIN Loan l ON bo.loan_number = l.loan_number
WHERE l.amount = (SELECT MIN(amount) FROM Loan);


SELECT c.customer_name, c.customer_street, c.customer_city
FROM Customer c
JOIN Borrower bo ON c.customer_name = bo.customer_name
JOIN Loan l ON bo.loan_number = l.loan_number
WHERE l.amount <= ALL (SELECT amount FROM Loan);

--7. Find distinct branches (name and city) that have both accounts and loans.
--Using IN:
SELECT DISTINCT b.branch_name, b.branch_city
FROM Branch b
WHERE b.branch_name IN (
    SELECT branch_name FROM Account
)
AND b.branch_name IN (
    SELECT branch_name FROM Loan
);

--Using EXISTS:
SELECT DISTINCT b.branch_name, b.branch_city
FROM Branch b
WHERE EXISTS (SELECT 1 FROM Account a WHERE a.branch_name = b.branch_name)
AND EXISTS (SELECT 1 FROM Loan l WHERE l.branch_name = b.branch_name);

--8. Find distinct customers who do not have loans but have accounts.
--Using IN:
SELECT DISTINCT c.customer_name, c.customer_city
FROM Customer c
JOIN Depositor d ON c.customer_name = d.customer_name
WHERE c.customer_name NOT IN (SELECT customer_name FROM Borrower);

SELECT DISTINCT c.customer_name, c.customer_city
FROM Customer c
JOIN Depositor d ON c.customer_name = d.customer_name
WHERE NOT EXISTS (SELECT 1 FROM Borrower bo WHERE bo.customer_name = c.customer_name);

SELECT b.branch_name
FROM Branch b
JOIN Account a ON b.branch_name = a.branch_name
GROUP BY b.branch_name
HAVING SUM(a.balance) > (SELECT AVG(total_balance) FROM (
    SELECT SUM(a.balance) AS total_balance
    FROM Branch b
    JOIN Account a ON b.branch_name = a.branch_name
    GROUP BY b.branch_name
));


WITH BranchBalances AS (
    SELECT b.branch_name, SUM(a.balance) AS total_balance
    FROM Branch b
    JOIN Account a ON b.branch_name = a.branch_name
    GROUP BY b.branch_name
),
AverageBalance AS (
    SELECT AVG(total_balance) AS avg_balance
    FROM BranchBalances
)
SELECT branch_name
FROM BranchBalances
WHERE total_balance > (SELECT avg_balance FROM AverageBalance);

SELECT b.branch_name
FROM Branch b
JOIN Loan l ON b.branch_name = l.branch_name
GROUP BY b.branch_name
HAVING SUM(l.amount) < (SELECT AVG(total_loan) FROM (
    SELECT SUM(l.amount) AS total_loan
    FROM Branch b
    JOIN Loan l ON b.branch_name = l.branch_name
    GROUP BY b.branch_name
));









