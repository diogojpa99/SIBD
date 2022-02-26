-- 1. Queries using IN and NOT IN --

-- a) Which clients live in cities that have bank branches?

SELECT DISTINCT customer_name
FROM customer
WHERE customer_city IN (
    SELECT branch_city FROM branch)
ORDER BY customer_name ASC;


-- b) What are the names and addresses of clients who have a bank account but no loans?

SELECT customer_name, customer_street, customer_city
FROM customer
WHERE customer_name IN(
        SELECT customer_name FROM depositor)
    AND customer_name NOT IN(
        SELECT customer_name FROM borrower)
ORDER BY customer_name ASC;


-- c) Who are the clients who have a loan at a branch in the same city where they live?

SELECT *
FROM branch;


-- DÚVIDA: Usando JOIN's ... Mas eu quero é usar IN/ NOT IN ...
SELECT c.customer_name, c.customer_city
FROM customer c
JOIN borrower b
    ON c.customer_name = b.customer_name
JOIN loan l
    ON b.loan_number = l.loan_number
JOIN branch
    ON l.branch_name = branch.branch_name
WHERE c.customer_city = branch.branch_city
ORDER BY c.customer_name ASC;


-- d) Which clients have at least one bank account and a loan?

SELECT customer_name
FROM customer
WHERE customer_name IN(
        SELECT customer_name FROM borrower)
    AND customer_name IN(
        SELECT customer_name FROM depositor)
ORDER BY customer_name ASC;

-- 2. Simple aggregation queries --

-- a) What is the total amount of account balances in branches of the city of Amadora?

SELECT SUM(a.balance)
FROM account a JOIN branch b
    ON a.branch_name = b.branch_name
WHERE b.branch_city= 'Amadora';


-- b) What is the maximum balance for an Amadora account?

SELECT MAX(a.balance)
FROM account a JOIN branch b
    ON a.branch_name = b.branch_name
WHERE b.branch_city = 'Amadora';


-- c) How many clients live in the same city of a branch where they have an account?

SELECT COUNT( DISTINCT c.customer_city)
FROM customer c
JOIN depositor d
    ON c.customer_name = d.customer_name
JOIN account a
    ON d.account_number = a.account_number
JOIN branch b
    ON a.branch_name = b.branch_name
WHERE b.branch_city = c.customer_city;

-- d) How many clients have at least one bank account and no loan?

SELECT COUNT( DISTINCT customer_name)
FROM customer
WHERE customer_name IN(
    SELECT customer_name FROM depositor)
    AND customer_name NOT IN(
    SELECT customer_name FROM borrower);


-- 3. Queries using GROUP BY --

-- a) What is the maximum balance per city?

SELECT b.branch_city, MAX(a.balance)
FROM account a JOIN branch b
    ON a.branch_name = b.branch_name
GROUP BY b.branch_city
ORDER BY branch_city ASC;


-- b) What is the average balance per city?

SELECT b.branch_city, AVG(a.balance)
FROM account a JOIN branch b
ON a.branch_name = b.branch_name
GROUP BY b.branch_city
ORDER BY branch_city ASC;


-- c) What is the number of accounts per branch?

SELECT branch_name, COUNT(*)
FROM account
GROUP BY branch_name
ORDER BY branch_name ASC;


-- d) What is the number of accounts on each city that has a branch?

SELECT b.branch_city, COUNT(a.account_number)
FROM branch b JOIN account a
    ON b.branch_name = a.branch_name
GROUP BY b.branch_city
ORDER BY b.branch_city ASC;


-- e) What is the total balance per customer?

SELECT d.customer_name, SUM(a.balance)
FROM depositor d JOIN account a
    ON d.account_number = a.account_number
GROUP BY d.customer_name
ORDER BY d.customer_name ASC;


-- f) Which clients have more than one loan?

SELECT customer_name, COUNT(*)
FROM borrower
GROUP BY customer_name
HAVING COUNT(*)>1
ORDER BY customer_name ASC;


-- g) List, alphabetically, the names of customers who have more than two bank accounts

SELECT customer_name, COUNT(*)
FROM depositor
GROUP BY customer_name
HAVING COUNT(*) > 2
ORDER BY customer_name ASC;


-- 4. Nested/Correlated Queries --

-- a) Which branches have fewer recorded assets (branch assets) than liabilities (total amount of loans)?

SELECT b.branch_name
FROM branch b
NATURAL JOIN (
    SELECT branch_name, SUM(amount) AS sum_loan
    FROM loan
    GROUP BY branch_name
    ) AS l
WHERE b.assets < l.sum_loan;

-- Fazer alínea (a) de outra forma:

SELECT b.branch_name
FROM branch b
WHERE b.assets
    < ( SELECT COALESCE(SUM(amount),0)
        FROM loan);




-- b) Which branches have fewer real assets (sum of all balances of all accounts) than liabilities (total
-- amount of loans)?

SELECT b.branch_name
FROM branch b
WHERE ( SELECT COALESCE(SUM(balance),0) AS total_assets
        FROM account )
    < ( SELECT COALESCE(SUM(amount),0) AS liabilities
        FROM loan);




-- c) What are the branch names and the difference between the total balance of their accounts and the
-- total amount of their loans?


SELECT b.branch_name, (COALESCE(total_assets,0) - COALESCE(total_liabilities,0)) AS difference
FROM branch b
    LEFT OUTER JOIN(
        SELECT branch_name, COALESCE(SUM(balance),0) AS total_assets
        FROM account
        GROUP BY branch_name) AS a
        ON b.branch_name = a.branch_name
    LEFT OUTER JOIN(
        SELECT branch_name, COALESCE(SUM(amount),0) AS total_liabilities
        FROM loan
        GROUP BY branch_name) AS l
        ON b.branch_name = l.branch_name
ORDER BY branch_name ASC;


-- Auxiliar:
SELECT branch_name
FROM branch
ORDER BY branch_name ASC;



-- d) For each customer, what are their names, total in loans and total in balances?

SELECT c.customer_name, COALESCE(total_loans,NULL) AS total_loans, COALESCE(total_balance,NULL) AS total_balance
FROM customer c
    LEFT OUTER JOIN(
        SELECT d.customer_name, COALESCE(SUM(a.balance),NULL) AS total_balance
        FROM depositor d NATURAL JOIN account a
        GROUP BY d.customer_name) AS bal
        ON c.customer_name = bal.customer_name
    LEFT OUTER JOIN(
        SELECT b.customer_Name, COALESCE(SUM(l.amount),NULL) AS total_loans
        FROM borrower b NATURAL JOIN loan l
        GROUP BY b.customer_name) AS loa
        ON c.customer_Name = loa.customer_name
ORDER BY c.customer_name ASC;



-- e) Who are the customers whose total of their debts (loans) is greater than the total of their assets
-- (accounts)?

-- NOTA:
-- Estou a considerar que os customers que não têm assets têm os seus balances a zero.
-- Caso fosse para ignorar esses casos seria: WHERE total_loans > total_balance


SELECT c.customer_name, COALESCE(total_loans,0) AS total_debt, COALESCE(total_balance,0) AS total_assets
FROM customer c
    LEFT OUTER JOIN (
        SELECT d.customer_name, COALESCE(SUM(a.balance),0) AS total_balance
        FROM depositor d NATURAL JOIN account a
        GROUP BY d.customer_name ) AS assets
        ON c.customer_name = assets.customer_name
    LEFT OUTER JOIN (
        SELECT b.customer_name, COALESCE(SUM(l.amount),0) AS total_loans
        FROM borrower b NATURAL JOIN loan l
        GROUP BY b.customer_name) AS debt
        ON c.customer_name = debt.customer_name
WHERE COALESCE(total_loans,0) > COALESCE(total_balance,0)
ORDER BY c.customer_name ASC;



-- 5. Queries to determine the distinctive element --

-- a) What is the name of the customer that owes the most money to the bank (in its total loans)?

select b.customer_name, SUM(l.amount)
FROM borrower b natural join loan l
group by b.customer_name
having sum(l.amount) >= all(
    select sum(amount)
    from borrower natural join loan
    group by borrower.customer_name
    );


-- b) Which branch has the most accounts?

select a.branch_name, count(*)
from account a
group by a.branch_name
having count(*) >= all(
    select count(*)
    from account a
    group by a.branch_name
    );

-- test

select * from account;


-- c) Which branch has the highest account average balance (among all agencies)?

select a.branch_name, avg(a.balance)
from account a
group by a.branch_name
having avg(a.balance) >= ALL (
    select avg(a.balance)
    from account a
    group by a.branch_name
    );

-- test
select * from account;


-- d) How many customers exist per branch city (considering all branches)?

-- Querie em baixo está errada.
-- select b.branch_city, coalesce(count(c.customer_name),0) as number_of_customers
-- from branch b
--     left outer join account a
--     on b.branch_name = a.branch_name
--     left outer join depositor d
--     on a.account_number = d.account_number
--     left outer join customer c
--     on d.customer_name = c.customer_name
-- group by b.branch_city
-- order by branch_city asc;



-- Querie em baixo está errada.
-- select b.branch_city, coalesce(count(c.customer_name),0) as number_of_customers
-- from customer c
--     left outer join depositor d
--     on c.customer_name= d.customer_name
--     left outer join account a
--     on a.account_number = d.account_number
--     left outer join branch b
--     on a.branch_name = b.branch_name
-- group by b.branch_city
-- order by branch_city asc;


-- Não é isto.
-- select customer_city, count(*) as number_of_customers
-- from customer
-- where customer_city in(select branch_city from branch)
-- group by customer_city
-- order by customer_city asc;
-- Basicamente o que eu estou a fazer aqui é:
-- contar o numero de customers que vivem em cada branch_city


-- Acho que é esta a solução que os profs queriam :
SELECT branch_city, COUNT(DISTINCT customer_name) AS number_of_customers
FROM (
 SELECT customer_name, branch_city
 FROM depositor d
 INNER JOIN account a ON d.account_number = a.account_number
 INNER JOIN branch b ON b.branch_name = a.branch_name
 UNION
SELECT customer_name, branch_city
 FROM borrower b
 INNER JOIN loan l ON l.loan_number = b.loan_number
 INNER JOIN branch c ON c.branch_name = l.branch_name
 ) AS customer_contracts
GROUP BY branch_city;

-- Okay, isto por acaso até faz sentido.
-- Basicamente, vamos contar todos os clientes de todas as branches
-- quer sejam depositors ou borrowers
-- fazer a união dos dois grupos
-- e agrupá-los por branch_city


-- test
select distinct branch_city from branch order by branch_city asc;
select distinct customer_city from customer order by customer_city asc;
select * from customer order by customer_city asc;




-- e) Which branch city has the most customers (considering all its branches)?

select c.branch_city, count(distinct c.customer_name)
from(
    select d.customer_name, b.branch_city
    from depositor d
        natural join account a
        natural join branch b
    union
    select bor.customer_name, bra.branch_city
    from borrower bor
        natural join loan l
        natural join branch bra
) as c
group by c.branch_city
having count(distinct customer_name) >= ALL (
    select count(distinct c.customer_name)
    from(
        select d.customer_name, b.branch_city
        from depositor d
            natural join account a
            natural join branch b
        union
        select bor.customer_name, bra.branch_city
        from borrower bor
            natural join loan l
            natural join branch bra
    ) as c
    group by c.branch_city
);


-- f) What is the name and address of the customer who has the greatest total balance?

-- esta froma está a dar o resultado correto, mas não é lá muito intuitiva
select c.customer_name, c.customer_street, c.customer_city, SUM(a.balance)
from account a
    natural join depositor d
    natural join customer c
group by c.customer_name, c.customer_street, c.customer_city
having sum(a.balance) >= ALL(
    select SUM(a.balance)
    from account a
        natural join depositor d
        natural join customer c
    group by c.customer_name, c.customer_street, c.customer_city
);


--- Melhor forma de fazer:
SELECT customer_name, customer_city, customer_street
FROM customer
WHERE customer_name IN (
    SELECT d.customer_name
    FROM depositor d NATURAL JOIN account a
    GROUP BY d.customer_name
    HAVING SUM(a.balance) >= ALL
        (SELECT SUM(a.balance)
        FROM depositor d NATURAL JOIN account a
        GROUP BY d.customer_name));

--- Perceber muito bem esta querie de cima! É simples, mas é muito intuitiva. Não complicar as coisas.


-- test
select * from customer;


--- 6. Queries with UNIQUE and EXISTS ---

-- a) Which accounts have only one owner (one depositor)?

-- select A.account_number
-- from account as A
-- where UNIQUE(
--     select d.customer_name
--     from depositor d
--     where d.account_number = A.account_number
-- );


-- O QUE É QUE ESTÁ MAL?? R: Não resulta no Postgres... Como é que fazemos ?


-- Não é isto
-- select one_owner_account.account_number
-- from(
--     select dep.account_number
--     from depositor dep
--     EXCEPT
--     select d.account_number
--     from depositor d
-- ) as one_owner_account;

-- contar quais as contas que se repetem
-- select d.account_number, count(*)
-- from depositor d
-- group by d.account_number
-- having count(*)>1;


-- agora é retirar estas do geral:



--Solução:
select d.account_number
from depositor d
EXCEPT
select dep.account_number
from depositor dep
group by dep.account_number
having count(*)>1
order by account_number asc;


-- test:
select account_number from depositor order by account_number asc;
select distinct a.account_number
from account a;


-- b) Which cities have a branch?

select distinct branch_city
from branch;

-- which cities have exactly one branch ?

select br.branch_city
from branch br
EXCEPT
select b.branch_city
from branch b
group by b.branch_city
having count(*)>1;


-- test:
select branch_city
from branch;


-- c) Which cities have a branch with more than 1 account?

-- Errado
-- select distinct b.branch_city
-- from branch b
--     inner join ( select a.branch_name
--         from account a
--         group by a.branch_name
--         having count(*)>1
--         ) as more_account
--     on b.branch_name = more_account.branch_name;



--Acho que é isto:
select b.branch_city
from account a natural join branch b
group by b.branch_city
having count(*)>1
order by b.branch_city asc;


-- test:
select *
from account a natural join branch b;




-- d) Which branches have an account with more than one owner?

select a.branch_name
from account a
    inner join (
    select d.account_number
    from depositor d
    group by d.account_number
    having count(*)>1) as o
        on a.account_number = o.account_number;

-- Acho que a solução de cima é mais intuitiva, pois:
-- Estamos a ver quais as branches das accounts que têm mais que um owner
-- ou seja:
--     select d.account_number
--     from depositor d
--     group by d.account_number
-- Esta query basicamente faz com que vejamos quantos owners é que cada account tem
-- Perceber bem isto

-- or

SELECT branch_name
FROM branch b
WHERE EXISTS(
    SELECT *
    FROM account a
    WHERE a.branch_name = b.branch_name
    AND 1 < (SELECT COUNT(*)
    FROM depositor d
    WHERE d.account_number = a.account_number));


----- 7. Queries with OUTER JOIN -----

-- a) List the customer names and streets, along with their loans numbers, if they exist, of the customers
-- that live in Lisbon

select c.customer_name, c.customer_street, coalesce(l.loan_number,NULL)
from customer c
    left outer join borrower b
    on c.customer_name = b.customer_name
    left outer join loan l
    on l.loan_number = b.loan_number
where c.customer_city = 'Lisbon'
order by customer_name asc;

--- test:

select customer_name, customer_street
from customer
where customer_city='Lisbon';





-- b) List all customer names and cities along with their highest loan, and biggest account, if they exist


SELECT c.customer_name, c.customer_street, max_loan.loan_number,
max_account.account_number
FROM customer c
     LEFT OUTER JOIN (
         SELECT customer_name, loan_number
         FROM borrower b NATURAL JOIN loan l
         WHERE l.amount = (
         SELECT MAX(amount)
         FROM borrower natural JOIN loan
         WHERE customer_name = b.customer_name)) max_loan
             ON max_loan.customer_name = c.customer_name
     LEFT OUTER JOIN (
         SELECT customer_name, account_number
         FROM depositor d NATURAL JOIN account a
         WHERE a.balance = (
         SELECT MAX(balance)
         FROM depositor NATURAL JOIN account
         WHERE customer_name = d.customer_name)) max_account
             ON max_account.customer_name = c.customer_name;


-- Dúvida! Qual a diferença entre:

 SELECT customer_name, loan_number
 FROM borrower b NATURAL JOIN loan l
 WHERE l.amount = (
     SELECT MAX(amount)
     FROM borrower natural JOIN loan
     WHERE customer_name = b.customer_name)
order by customer_name asc;

-- vs.

 SELECT customer_name, loan_number
 FROM borrower b NATURAL JOIN loan l
 WHERE l.amount >= ALL (
     SELECT amount
     FROM borrower natural JOIN loan
     WHERE customer_name = b.customer_name)
order by customer_name asc;




--- 8. Queries that test for coverage (Division) ---

-- a) Who are the clients that have accounts at all branches of the bank?


select distinct dp.customer_name
from depositor dp
where not exists(
    select branch_name
    from branch
    except
    select ac.branch_name
    from ( account A join depositor D
    on A.account_number= D.account_number) as ac
    where ac.customer_name = dp.customer_name);



-- b) Who are the clients that have accounts at all branches of Lisbon?

select distinct dp.customer_name
from depositor dp
where not exists(
    select branch_name
    from branch
    where branch_city='Lisbon'
    except
    select ac.branch_name
    from( account a join depositor d
        on a.account_number = d.account_number) as ac
    where ac.customer_name = dp.customer_name);



-- c) Who are the clients who have accounts at all branches in the same city where they live?

SELECT DISTINCT c.customer_name
FROM depositor d JOIN customer c
ON d.customer_name = c.customer_name
WHERE NOT EXISTS (
    SELECT branch_name
    FROM branch
    WHERE branch_city = c.customer_city
    EXCEPT
    SELECT branch_name
    FROM depositor d JOIN account a
     ON d.account_number = a.account_number
    WHERE d.customer_name = c.customer_name);


