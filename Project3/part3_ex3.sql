

-- 1. Who is the owner with the most boats per country?

-- (i) boats per country:
select b.iso_code, count(*)
from boat b
group by b.iso_code;

-- (ii) the owner with the most boats in one country
select b.iso_code, b.id_owner, b.iso_code_owner, count(*)
from boat b
group by b.iso_code, b.id_owner, b.iso_code_owner
having count(*) >= all(
    select count(*)
    from boat b1
    group by b1.iso_code, b1.iso_code_owner, b1.id_owner);

-- test:

select * from boat;

-- dúvida acerca desta questão

SELECT  b1.iso_code_owner, b1.id_owner, count(*)
FROM boat b1
GROUP BY  b1.iso_code_owner, b1.id_owner;



-- 2. List all the owners that have at least two boats in distinct countries.

select * from boat;

-- Okay, vamos ter que mexer no iso_code, id_owner e iso_code_owner
-- Query em baixo está errada, mas dá o resultado certo
select b1.id_owner, b1.iso_code_owner, count(b1.id_owner)
from boat b1, boat b2
where b1.id_owner = b2.id_owner AND b1.iso_code_owner = b2.iso_code_owner
        AND b1.iso_code<> b2.iso_code
group by b1.id_owner, b1.iso_code_owner
having count(b1.id_owner) >= 2;




-- 3. Who are the sailors that have sailed to every location in 'Portugal'?



-- errado
select distinct res.id_sailor, res.iso_code_sailor
from reservation res
where not exists(
    select l.iso_code
    from location l natural join trip t
    where l.iso_code = 'PT'
    except
    select loc.iso_code
    from location loc
        natural join trip
        natural join reservation r
    where r.id_sailor = res.id_sailor and r.iso_code_sailor = res.iso_code_sailor);


-- teste:
select * from sailor;
select * from reservation;
select * from trip;
select * from location where iso_code= 'PT';

select id_sailor, iso_code_sailor, l.iso_code, count(*)
from trip t natural join location l
where l.iso_code='PT'
group by id_sailor, iso_code_sailor, l.iso_code;

select id_sailor, iso_code_sailor, l.name, l.iso_code
from trip t natural join location l
where l.iso_code='PT';




-- 4. List the sailors with the most trips along with their reservations

-- Não é isto... Rafael está certo
select t.iso_code_sailor, t.id_sailor, t.cni, t.iso_code_boat, t.start_date, t.end_date, count(*)
from trip t
group by t.iso_code_sailor, t.id_sailor, t.cni, t.iso_code_boat, t.start_date, t.end_date
having count(*) >= ALL (
    select count(*)
    from trip t1
    group by t1.iso_code_sailor, t1.id_sailor, t1.cni, t1.iso_code_boat, t1.start_date, t1.end_date);


-- Solução
SELECT iso_code_sailor, id_sailor, iso_code_boat, cni, start_date, end_date
FROM reservation
WHERE (iso_code_sailor, id_sailor) IN
      (SELECT t.iso_code_sailor, t.id_sailor
       FROM trip t
       GROUP BY t.iso_code_sailor, t.id_sailor
       HAVING COUNT(*) >= ALL (SELECT COUNT(*)
                               FROM trip
                               GROUP BY iso_code_sailor, id_sailor));


-- 5. List the sailors with the longest duration of trips (sum of trip durations) for the same
-- single reservation; display also the sum of the trip durations.

select * from trip;

-- será que primeiro temos que agrupar as trips por reservation ?

select id_sailor, iso_code_sailor, sum(duration) as trip_duration
from trip
group by cni, iso_code_boat, id_sailor, iso_code_sailor, start_date, end_date
having sum(duration) >= ALL (
    select sum(duration)
    from trip
    group by cni, iso_code_boat, id_sailor, iso_code_sailor, start_date, end_date
    );

-- or

SELECT iso_code_sailor, id_sailor, iso_code_boat, cni, start_date, end_date, SUM(duration) AS sum_durations
FROM trip
GROUP BY (iso_code_sailor, id_sailor, iso_code_boat, cni, start_date, end_date)
HAVING SUM(duration) >= ALL (SELECT SUM(duration)
                             FROM trip
                             GROUP BY (iso_code_sailor, id_sailor, iso_code_boat, cni, start_date, end_date));



-- test
select * from trip;