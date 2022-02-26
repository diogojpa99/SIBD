

--- 1) Perceber o que são views

CREATE VIEW account_stats(name,	num_accts)
AS
SELECT	customer_name,	COUNT(*)	AS	num_accts
FROM	depositor
GROUP	BY	customer_name;

SELECT	*
FROM	account_stats;

--- Basicamente Views são tabelas virtuais, criadas através de queries
--- Mas atenção temos updatable views e non-updatable views
--- Também temos materialized view


------ Part3_Ex6 -------

------------------------
---------- 1 -----------
------------------------

--- 1) Primeiro temos smepre de perceber com o que é que estamos a trabalhar
select * from trip_info;

-------------------------------------------- Solução -------------------------------------------------------------
select extract(year from t.trip_start_date) as year, extract(month from t.trip_start_date) as month, t.trip_start_date as exact_date, count(*) as nr_of_trips
from trip_info t
group by grouping sets ( (extract(year from t.trip_start_date)) , (extract(month from t.trip_start_date)), (t.trip_start_date));
-------------------------------------------------------------------------------------------------------------------



--- Secalhar era melhor fazer união, como está nos slides. Ou seja usar UNION OF GROUP BY
--- Preferia a solução de baixo, mas está a dar erro...
select extract(year from trip_start_date) as year, CAST(NULL AS date), CAST(NULL AS date) , count(*) as nr_of_trips
from trip_info
group by extract(year from trip_start_date)
union
select CAST(NULL AS date), extract(month from trip_start_date) as month, CAST(NULL AS date), count(*) as nr_of_trips
from trip_info
group by extract(month from trip_start_date)
union
select CAST(NULL AS date), CAST(NULL AS date), trip_start_date as exact_date, count(*) as nr_of_trips
from trip_info
group by trip_start_date
union
select CAST(NULL AS date), CAST(NULL AS date), CAST(NULL AS date), count(*) as nr_of_trips
from trip_info;


------------------------
---------- 2 -----------
------------------------

---- ROLLUP ----

select t.country_name_origin as country , t.loc_name_origin as location, count(*) as nr_of_trips
from trip_info t
group by rollup (t.country_name_origin, t.loc_name_origin);