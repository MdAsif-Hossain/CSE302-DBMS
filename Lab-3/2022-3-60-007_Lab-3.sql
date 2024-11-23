@C:\Users\Asif\Downloads\banking.sql

select * from account;

--1) Find all branch names and cities with assets more than 1000000. (on single table)

SELECT branch_name, branch_city
FROM branch
WHERE assets > 1000000;

--2) Find all account numbers and their balance which are opened in ‘Downtown’ branch or
--which have balance in between 600 and 750. (on single table)
SELECT account_number, balance
FROM account
WHERE branch_name = 'Downtown' OR (balance BETWEEN 600 AND 750);

--3) Find all account numbers which are opened in a branch located in ‘Rye’ city. (multipletables)

SELECT a.account_number
FROM account a
JOIN branch b ON a.branch_name = b.branch_name
WHERE b.branch_city = 'Rye';

--4) Find all loan numbers which have amount greater than or equal to 1000 and their customers
--are living in ‘Harrison’ city. (multiple tables)

SELECT l.loan_number
FROM loan l
JOIN borrower bo ON l.loan_number = bo.loan_number
JOIN customer c ON bo.customer_name = c.customer_name
WHERE l.amount >= 1000 AND c.customer_city = 'Harrison';

--5) Display the account related information based on the descending order of the balance. (order by clause)
SELECT *
FROM account
ORDER BY balance DESC;

--6) Display the customer related information in alphabetic order of customer cities. (order by clause)

SELECT *
FROM customer
ORDER BY customer_city;

--7) Find all customer names who have an account as well as a loan. (intersect)
SELECT customer_name
FROM depositor
INTERSECT
SELECT customer_name
FROM borrower;

--8) Find all customer related information who have an account or a loan. (union)
SELECT *
FROM customer
WHERE customer_name IN (
    SELECT customer_name FROM depositor
    UNION
    SELECT customer_name FROM borrower
);

--9) Find all customer names and their cities who have a loan but not an account. (minus)
SELECT customer.customer_name, customer.customer_city
FROM customer
WHERE customer.customer_name IN (
    SELECT customer_name FROM borrower
    MINUS
    SELECT customer_name FROM depositor
);

--10) Find the total assets of all branches. (aggregate function)
SELECT SUM(assets) AS total_assets
FROM branch;

--11) Find the average balance of accounts at each branch. (aggregate function)

SELECT branch_name, AVG(balance) AS avg_balance
FROM account
GROUP BY branch_name;

--12) Find the average balance of accounts at each branch city. (aggregate function)
SELECT b.branch_city, AVG(a.balance) AS avg_balance
FROM account a
JOIN branch b ON a.branch_name = b.branch_name
GROUP BY b.branch_city;

--13) Find the lowest amount of loan at each branch. (aggregate function)
SELECT branch_name, MIN(amount) AS lowest_loan
FROM loan
GROUP BY branch_name;

--14) Find the total number of loans at each branch. (aggregate function)
SELECT branch_name, COUNT(*) AS total_loans
FROM loan
GROUP BY branch_name;

--15) Find the customer name and account number of the account which has the highest balance. (aggregate function)
SELECT d.customer_name, a.account_number
FROM depositor d
JOIN account a ON d.account_number = a.account_number
WHERE balance = (SELECT MAX(balance) FROM account);


