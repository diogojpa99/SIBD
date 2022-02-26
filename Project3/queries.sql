-------------
----  1  ----
-------------
/*
It is selecting at most one per country. To select at least one, change '>' to '>='
*/
SELECT b1.iso_code, b1.iso_code_owner, b1.id_owner
FROM boat b1
GROUP BY b1.iso_code, b1.iso_code_owner, b1.id_owner
HAVING COUNT(*) >= ALL (SELECT COUNT(*)
                       FROM boat b2
                       WHERE b2.iso_code = b1.iso_code
                         AND NOT (b2.id_owner = b1.id_owner AND b2.iso_code_owner = b1.iso_code_owner)
                       GROUP BY iso_code_owner, id_owner)
ORDER BY b1.iso_code;


-------------
----  2  ----
-------------
SELECT iso_code_owner, id_owner
FROM boat
GROUP BY iso_code_owner, id_owner
HAVING COUNT(DISTINCT iso_code) >= 2;


-------------
----  3  ----
-------------
SELECT DISTINCT iso_code_sailor, id_sailor
FROM trip t1
WHERE NOT EXISTS(SELECT cl.latitude, cl.longitude
                 FROM location cl
                 WHERE iso_code = 'PT'
                 EXCEPT
                 SELECT t2.end_latitude, t2.end_longitude
                 FROM trip t2
                 WHERE t2.iso_code_sailor = t1.iso_code_sailor
                   AND t2.id_sailor = t1.id_sailor);


-------------
----  4  ----
-------------
SELECT iso_code_sailor, id_sailor, iso_code_boat, cni, start_date, end_date
FROM reservation
WHERE (iso_code_sailor, id_sailor) = ANY
      (SELECT t.iso_code_sailor, t.id_sailor
       FROM trip t
       GROUP BY t.iso_code_sailor, t.id_sailor
       HAVING COUNT(*) >= ALL (SELECT COUNT(*)
                               FROM trip
                               GROUP BY iso_code_sailor, id_sailor));


-------------
----  5  ----
-------------
SELECT iso_code_sailor, id_sailor, iso_code_boat, cni, start_date, end_date, SUM(duration) AS sum_durations
FROM trip
GROUP BY (iso_code_sailor, id_sailor, iso_code_boat, cni, start_date, end_date)
HAVING SUM(duration) >= ALL (SELECT SUM(duration)
                             FROM trip
                             GROUP BY (iso_code_sailor, id_sailor, iso_code_boat, cni, start_date, end_date));