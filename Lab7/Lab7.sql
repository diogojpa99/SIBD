--- SIBD Lab7 ---

-- 1. Implement and test the following functionalities using PGPLSQL: --

-- a)

CREATE	OR	REPLACE	FUNCTION net_worth (client_name VARCHAR(80))
RETURNS INTEGER AS
$$
DECLARE abs_net_worth INTEGER;
BEGIN
    SELECT (COALESCE(SUM(total_balance),NULL) - COALESCE(SUM(total_debt),NULL)) INTO abs_net_worth
    FROM customer c
        LEFT OUTER JOIN(
            SELECT d.customer_name, COALESCE(SUM(a.balance),NULL) AS total_balance
            FROM depositor d NATURAL JOIN account a
            GROUP BY d.customer_name) AS bal
            ON c.customer_name = bal.customer_name
        LEFT OUTER JOIN(
            SELECT b.customer_Name, COALESCE(SUM(l.amount), NULL) AS total_debt
            FROM borrower b NATURAL JOIN loan l
            GROUP BY b.customer_name) AS debt
            ON c.customer_name = debt.customer_name
    WHERE c.customer_name = client_name;

    RETURN abs_net_worth;
END
$$ LANGUAGE plpgsql;

-- Testar:

SELECT customer_name
FROM customer;

SELECT net_worth('Brown');


-- b)


CREATE OR REPLACE FUNCTION branch_avg_diff (branch1 VARCHAR(80), branch2 VARCHAR(80))
RETURNS INTEGER AS
$$
DECLARE diff INTEGER;
BEGIN
    SELECT ( COALESCE(AVG(a1.balance),0) - COALESCE(AVG(a2.balance),0) ) INTO diff
    FROM account a1, account a2
    WHERE a1.branch_name = branch1 AND a2.branch_name = branch2;

    RETURN diff;
END
$$ LANGUAGE plpgsql;

-- Testar:

SELECT DISTINCT branch_name, balance
FROM account;

SELECT branch_avg_diff('Central', 'Downtown');


-- c)

SELECT b1.branch_name, b2.branch_name, branch_avg_diff(b1.branch_name, b2.branch_name)
FROM branch b1, branch b2
WHERE b1.branch_name <> b2.branch_name;


-- d)

SELECT DISTINCT b1.branch_name
FROM branch b1, branch b2
WHERE (b1.branch_name <> b2.branch_name) AND branch_avg_diff(b1.branch_name, b2.branch_name) >= ALL(
    SELECT MAX(branch_avg_diff(b1.branch_name, b2.branch_name))
    FROM branch b1,branch b2
    WHERE (b1.branch_name <> b2.branch_name));




-- 2. Trigger-like behaviour --

--  a)

CREATE OR REPLACE FUNCTION delete_depositor()
RETURNS TRIGGER AS
$$
BEGIN
    DELETE
    FROM depositor d
    WHERE d.account_number = OLD.account_number;
    return OLD;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tg_delete_account
    BEFORE DELETE
    ON account
    FOR EACH ROW
EXECUTE PROCEDURE delete_depositor();

-- Tests

select * from account;
select * from depositor;

insert into account values ('Z-555', 'Downtown', 1000.0);
insert into depositor values ('Cook', 'Z-555');

delete
from account
where account_number = 'Z-555';

drop trigger tg_delete_account on account;

-- b)

INSERT INTO account VALUES ('B-100','Downtown', 100);
INSERT INTO depositor VALUES ('Cook','B-100');

SELECT * FROM depositor;
SELECT * FROM account;

DELETE FROM account
WHERE account_number = 'B-100';

SELECT * FROM depositor;
SELECT * FROM account;


-- c)

DROP TRIGGER tg_delete_account ON account;


-- d)


ALTER TABLE depositor DROP CONSTRAINT fk_depositor_account;

ALTER TABLE depositor ADD CONSTRAINT fk_depositor_account
    FOREIGN KEY(account_number) REFERENCES account(account_number)
ON DELETE CASCADE;

-- Voltar ao original
ALTER TABLE depositor ADD CONSTRAINT fk_depositor_account
    FOREIGN KEY (account_number) REFERENCES account (account_number);


-- e)
-- Run b) : Basicamente temos que correr o código da alínea b), mas depois de ter feito a alínea d)
--          Funciona normalmente




-- f)

INSERT INTO loan VALUES ('B-100','Downtown', 100);
INSERT INTO borrower VALUES ('Cook','B-100');

SELECT * FROM borrower;
SELECT * FROM loan;

DELETE FROM loan
WHERE loan_number = 'B-100';

SELECT * FROM borrower;
SELECT * FROM loan;

ALTER TABLE borrower DROP CONSTRAINT fk_borrower_loan;

ALTER TABLE borrower ADD CONSTRAINT fk_borrower_loan
    FOREIGN KEY(loan_number) REFERENCES loan(loan_number)
ON DELETE CASCADE;

-- Voltar ao original
ALTER TABLE borrower ADD CONSTRAINT fk_borrower_loan
    FOREIGN KEY (loan_number) REFERENCES loan (loan_number);


-- 3.Triggers --

-- a)

CREATE OR REPLACE FUNCTION del_neg_loan()
RETURNS TRIGGER AS
$$
BEGIN
    IF NEW.amount <= 0 THEN

        IF NEW.amount <0 THEN
            UPDATE branch
            SET assets = assets - NEW.amount
            WHERE branch_name = NEW.branch_name;
        END IF;

        DELETE
        FROM borrower b
        WHERE b.loan_number = NEW.loan_number;

        DELETE
        FROM loan l
        WHERE l.loan_number = NEW.loan_number;

    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tg_update_loan
    AFTER UPDATE OR INSERT ON loan
    FOR EACH ROW
EXECUTE PROCEDURE del_neg_loan();


-- Delete:
DROP TRIGGER tg_update_loan ON loan;
DROP FUNCTION del_neg_loan();

-- b)

-- Clean up any existing rows if needed
DELETE FROM borrower WHERE loan_number ='1111';
DELETE FROM loan WHERE loan_number ='1111';

-- Insert the new values
INSERT INTO loan VALUES('1111', 'Central', 100);
INSERT INTO borrower VALUES('Adams', '1111');

-- Check the new versions if the tables ‘loan’, ‘borrower’, and ‘branch’
SELECT * FROM loan;
SELECT * FROM borrower;
SELECT * FROM branch;

-- Update ‘loan’
UPDATE loan
SET amount = amount - 101
WHERE loan_number = '1111';

-- Check ‘branch’ again...
SELECT * FROM branch;


-- c)

--CREATE OR REPLACE FUNCTION block_loan()
--RETURNS TRIGGER AS
--$$
--BEGIN
--    IF NEW.customer_name NOT IN(
--            SELECT d.customer_name
--            FROM depositor d NATURAL JOIN account a
--            WHERE a.branch_name = NEW.branch_name)
--    THEN
--
--        DELETE
--        FROM borrower b
--        WHERE b.loan_number = NEW.loan_number;
--
--        DELETE
--        FROM loan l
--        WHERE l.loan_number = NEW.loan_number;

--        RAISE EXCEPTION 'To get a loan, you need to have an account in this branch';

--    END IF;

--    RETURN NEW;
--END;
--$$ LANGUAGE plpgsql;


--CREATE TRIGGER tg_verify_account
--    AFTER UPDATE OR INSERT ON loan
--    FOR EACH ROW
--EXECUTE PROCEDURE block_loan();


-- Delete:
--DROP TRIGGER tg_verify_account ON loan;
--DROP FUNCTION block_loan();

-- ! Dúvida !
-- Pensava que era necessário o cliente ter uma conta no banco onde tem o empréstimo.
-- Mas pelos visto basta apenas ter uma conta, em qualquer banco.
-- ! Dúvida ! como é que se faz o que eu queria fazer ???


CREATE OR REPLACE FUNCTION block_loan()
RETURNS TRIGGER AS
$$
BEGIN
    IF NEW.customer_name NOT IN(
        SELECT d.customer_name
        FROM depositor d  NATURAL JOIN account a
        )
    THEN
    RAISE EXCEPTION 'To get a loan, you need to have an account in this branch';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tg_verify_account
    BEFORE INSERT ON borrower
    FOR EACH ROW
EXECUTE PROCEDURE block_loan();


-- Delete:
DROP TRIGGER tg_verify_account ON borrower;
DROP FUNCTION block_loan();


-- Test:

select distinct b.customer_name from borrower b join depositor d on b.customer_name = d.customer_name;
select * from borrower;

-- Insert the new values
INSERT INTO loan
VALUES ('C-444', 'Central', 10000);
INSERT INTO borrower
VALUES ('Davis', 'C-444');


-- DELETE:
DELETE from loan
WHERE loan_number='C-444';
Delete from borrower
where loan_number='C-444';

select * from loan;