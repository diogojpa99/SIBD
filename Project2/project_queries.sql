-- Project Part 2 Queries --

-- A. All boats that have been reserved at least once
SELECT DISTINCT b.name
FROM Boat b JOIN Reservation r
ON b.iso_code = r.boat_iso_code AND b.cni = r.boat_cni;

-- B. All sailors that have reserved boats registered in the country 'Portugal'
SELECT DISTINCT p.name
FROM Person p
JOIN Sailor s
ON p.iso_code = s.iso_code AND p.id_card = s.id_card
JOIN Reservation r
ON s.iso_code = r.sailor_iso_code AND s.id_card = r.sailor_id_card
JOIN Boat b
ON r.boat_iso_code = b.iso_code AND r.boat_cni = b.cni
JOIN Country c
ON b.iso_code = c.iso_code
WHERE c.name = 'Portugal';

-- C. All reservations longer than 5 days
SELECT DISTINCT *
FROM reservation
WHERE end_date > reservation.start_date + '5 days';

-- D. Name and CNI of all boats registered in 'South Africa' whose owner name ends with 'Rendeiro'.
SELECT DISTINCT b.name, b.cni
FROM Boat b
JOIN Country c
ON b.iso_code = c.iso_code
JOIN Owner o
ON b.owner_iso_code = o.iso_code AND b.owner_id_card = o.id_card
JOIN Person p
ON c.iso_code = p.iso_code
WHERE c.name = 'South Africa' AND p.name LIKE '% Rendeiro';