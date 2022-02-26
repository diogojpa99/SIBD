CREATE VIEW trip_info AS
SELECT c_origin.iso_code AS country_iso_origin,
       c_origin.name     AS country_name_origin,
       c_dest.iso_code   AS country_iso_dest,
       c_dest.name       AS country_name_dest,
       l_origin.name     AS loc_name_origin,
       l_dest.name       AS loc_name_dest,
       t.cni             AS cni_boat,
       t.iso_code_boat   AS country_iso_boat,
       c_boat.name       AS country_name_boat,
       t.start_date      AS trip_start_date
FROM trip t
         JOIN location l_origin ON t.start_latitude = l_origin.latitude AND t.start_longitude = l_origin.longitude
         JOIN country c_origin ON l_origin.iso_code = c_origin.iso_code
         JOIN location l_dest ON t.end_latitude = l_dest.latitude AND t.end_longitude = l_dest.longitude
         JOIN country c_dest ON l_dest.iso_code = c_dest.iso_code
         JOIN country c_boat ON t.iso_code_boat = c_boat.iso_code;


