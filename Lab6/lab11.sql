----------------------
---- OLAP Queries ----
----------------------

--- 1. ---

-- (i) perceber o que está a acontecer

select * from date_dimension;

-- Ex:
SELECT b.building_id, d.week_day_type, AVG(reading)
FROM meter_readings r, building_dimension b, date_dimension d
WHERE r.date_id = d.date_id AND r.building_id = b.building_id
GROUP BY b.building_id, d.week_day_type;
-- Porque é que tenho estes erros, mas corre na mesma ?


--- Dúvidas : Average consuption é suposto ser o quê ? O reading?

------------------------ Acho que é isto -----------------------------------
select d.week_day_name, avg(r.reading)
from meter_readings r, date_dimension d
WHERE r.date_id = d.date_id
group by d.week_day_name;
------------------------------------------------------------------------------



--- Quais os dias que têm maior e menor consumo:
--- Todos os dias da semana têm o mesmo consumo médio ?? faltava o WHERE !! [ATENÇÃO]

select d.week_day_name, avg(r.reading)
from meter_readings r, date_dimension d
WHERE r.date_id = d.date_id
group by d.week_day_name
having avg(r.reading) >= ALL (
        select avg(r1.reading)
        from meter_readings r1, date_dimension d1
        WHERE r1.date_id = d1.date_id
        group by d1.week_day_name)
    or
    avg(r.reading) <= ALL (
        select avg(r2.reading)
        from meter_readings r2, date_dimension d2
        WHERE r2.date_id = d2.date_id
        group by d2.week_day_name);


--- 2. ---

select week_number from date_dimension;
select month_number from date_dimension;
select * from date_dimension;

--- Estou com dúvidas na parte de: "during the last three weeks of the year"
--- Mas acho que vou ter que ser esperto e fazer aqui umas de date
--- últimas três semanas do ano -> where date_time >



------------------------ Acho que é isto -----------------------------------
select b.building_id, d.week_number, avg(r.reading)
from meter_readings r, building_dimension b, date_dimension d
where r.building_id = b.building_id and r.date_id = d.date_id
        and d.week_number > (
            select distinct d.week_number
            from date_dimension d
            where week_number >= ALL (
                    select distinct d1.week_number
                    from date_dimension d1)) - 3
group by b.building_id, d.week_number
order by d.week_number;
------------------------------------------------------------------------------



-- Não sei porquê mas está a dar erro.
select distinct month_end_date from date_dimension where month_number=12;
select datediff(week, 3, (select distinct month_end_date from date_dimension where month_number=12 ));
-- aux
SELECT DATEADD(year, '2017/08/25', '2011/08/25');

-- outra forma:
select distinct d.week_number
from date_dimension d
where week_number >= ALL (
        select distinct d1.week_number
        from date_dimension d1
        );


--- 3. ROLLUP ---

-- visto que rollup significa 'generalizar' um parâmetro, então penso que esta alínea se esteja a referir
-- à alínea 1

select d.week_number, avg(r.reading)
from meter_readings r, date_dimension d
WHERE r.date_id = d.date_id
group by d.week_number
order by d.week_number asc;

-- Isto está correto, porque é que saltamos da semana 1 para a semana 48 ?




--- 4. ---

select b.building_id, avg(r.reading)
from meter_readings r, building_dimension b
where r.building_id = b.building_id
group by b.building_id
order by avg(r.reading) asc;



--- 5.DRILL DOWN ---- (Não será igual à 1.?)

--- DRILL DOWN: Basicamente 'especificar' um parâmetro


--- Será isto que eles querem ?
select b.building_id, d.week_day_name, avg(r.reading)
from meter_readings r, building_dimension b, date_dimension d
where r.building_id = b.building_id and r.date_id = d.date_id
group by b.building_id, d.week_day_name
order by b.building_id;



--- 6.DRILL DOWN ----

select * from time_dimension;

select b.building_id, t.day_period, avg(r.reading)
from meter_readings r, building_dimension b, time_dimension t
where r.building_id = b.building_id and r.time_id = t.time_id
group by b.building_id, t.day_period
order by b.building_id;


---- 7. ----

-- Será isto ?
select b.building_id, t.day_period, t.hour_of_day, avg(r.reading)
from meter_readings r, building_dimension b, time_dimension t
where r.building_id = b.building_id and r.time_id = t.time_id
group by b.building_id, rollup (t.day_period,t.hour_of_day)
order by b.building_id;


----- 8. -----

DROP TABLE IF EXISTS results;

CREATE TABLE results (
 building_name VARCHAR(20),
day_period VARCHAR(20),
hour_of_day INTEGER,
avg_reading BIGINT);


INSERT INTO results
select b.building_id, t.day_period, t.hour_of_day, avg(r.reading)
from meter_readings r, building_dimension b, time_dimension t
where r.building_id = b.building_id and r.time_id = t.time_id
group by b.building_id, rollup (t.day_period,t.hour_of_day)
order by b.building_id;



----- 9. -----

/* Fazer depois */




----- 10. -----

-- É isto ? ---
select b.building_id, t.day_period, t.hour_of_day, avg(r.reading)
from meter_readings r, building_dimension b, time_dimension t
where r.building_id = b.building_id and r.time_id = t.time_id
group by b.building_id, cube (t.day_period,t.hour_of_day)
order by b.building_id;