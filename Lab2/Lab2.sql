-- (a) --

SELECT DISTINCT customer_name
FROM customer
WHERE customer_city = 'Lisbon';

-- (b) --

SELECT account_number
FROM account
WHERE balance>500;

-- (c) --

SELECT account_number ,  balance * 1.277 AS new_balance
FROM account
WHERE branch_name = 'Downtown';

-- (d) --

SELECT DISTINCT customer_name
FROM depositor NATURAL JOIN account
WHERE balance > 500;

-- or --

SELECT DISTINCT customer_name
FROM depositor d JOIN account a
    ON d.account_number = a.account_number
WHERE balance > 500;

-- (e) --

SELECT DISTINCT customer_city
FROM customer c
JOIN borrower b
ON c.customer_name = b.customer_name
JOIN  loan l
ON b.loan_number = l.loan_number
WHERE amount BETWEEN 1000 AND 2000;

-- (f) --

SELECT DISTINCT balance
FROM account a
JOIN depositor d
ON a.account_number = d.account_number
JOIN borrower b
        ON d.customer_name = b.customer_name
WHERE loan_number = 'L-15';

-- (g) --

SELECT branch_name
FROM account a JOIN depositor d
ON a.account_number = d.account_number
WHERE customer_name LIKE 'J%' AND  customer_name LIKE '%n';

-- (h) --

SELECT  amount
FROM  loan l
JOIN borrower b
ON l.loan_number = b.loan_number
JOIN customer c
ON b.customer_name = c.customer_name
WHERE LENGTH (Trim(customer_city))=6;

-- (i) --

SELECT amount
FROM loan l
JOIN borrower b
ON l.loan_number = b.loan_number
JOIN customer c
ON b.customer_name = c.customer_name
WHERE customer_city LIKE '% %';


-- (j) --

SELECT   b.branch_name , assets
FROM branch b
JOIN account a
ON b.branch_name = a.branch_name
JOIN depositor d
ON a.account_number = d.account_number
WHERE customer_name = 'Johnson';


-- (k) --

SELECT DISTINCT c.customer_name
FROM customer c
JOIN borrower b
ON c.customer_name = b.customer_name
JOIN loan l
ON b.loan_number = l.loan_number
JOIN branch
ON l.branch_name = branch.branch_name
WHERE c.customer_city = branch.branch_city;


-- (l) --

SELECT DISTINCT c.customer_name , b.branch_city
FROM customer c JOIN branch b
        ON c.customer_city = b.branch_city;


-- (m) --

SELECT DISTINCT  d.customer_name
FROM depositor d JOIN borrower b
        ON d.customer_name = b.customer_name;

-- (n) --

SELECT  DISTINCT customer_name, customer_city FROM customer
WHERE customer_city NOT IN(
SELECT branch_city FROM branch);


-- (o) --

SELECT SUM(balance)
FROM account a JOIN branch b
ON a.branch_name = b.branch_name
WHERE b.branch_city = 'Lisbon';