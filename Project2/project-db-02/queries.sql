-- (A)  All boats that have been reserved at least once
SELECT DISTINCT name, iso_code, cni
FROM reservation r
     JOIN boat b ON b.iso_code = r.boat_iso_code AND b.cni = r.boat_cni;


-- (B) All sailors that have reserved boats registered in the country 'Portugal'
SELECT DISTINCT p.name, s.iso_code, s.id_card
FROM sailor s
     JOIN person p ON s.iso_code = p.iso_code AND s.id_card = p.id_card
     JOIN reservation r ON s.iso_code = r.sailor_iso_code AND s.id_card = r.sailor_id_card
     JOIN boat b ON b.iso_code = r.boat_iso_code AND b.cni = r.boat_cni
     JOIN country c ON b.iso_code = c.iso_code
WHERE c.name = 'Portugal';


-- (C) All reservations longer than 5 days
SELECT *
FROM reservation
WHERE schedule_end_date - schedule_start_date > 5 ;


-- (D) Name and CNI of all boats registered in 'South Africa' whose owner name ends with 'Rendeiro'
SELECT DISTINCT b.name, b.cni
FROM boat b
     JOIN owner o ON b.own_iso_code = o.iso_code AND b.own_id_card = o.id_card
     JOIN person p ON o.iso_code = p.iso_code AND o.id_card = p.id_card
WHERE b.iso_code = 'ZAF' AND p.name LIKE '%Rendeiro';

