--------------
--- (IC-1) ---
--------------

-- Function
CREATE OR REPLACE FUNCTION check_reservations_schedules()
    RETURNS TRIGGER AS
$$
DECLARE
    cursor_reservation CURSOR FOR
        SELECT *
        FROM reservation
        WHERE iso_code_boat = new.iso_code_boat
          AND cni = new.cni;
BEGIN
    FOR reservation_row IN cursor_reservation
        LOOP
            -- (StartA <= EndB) and (EndA >= StartB) -> Overlap
            IF new.start_date <= reservation_row.end_date AND new.end_date >= reservation_row.start_date THEN
                RAISE EXCEPTION 'Reservation of boat CNI % - % from % to % overlaps with '
                    'reservation from % to %',
                    new.cni,new.iso_code_boat, new.start_date, new.end_date,
                    reservation_row.start_date, reservation_row.end_date;
            END IF;
        END LOOP;
    RETURN new;
END;
$$ LANGUAGE plpgsql;


-- Trigger
DROP TRIGGER IF EXISTS tg_check_reservations_schedules ON reservation;

CREATE TRIGGER tg_check_reservations_schedules
    BEFORE UPDATE OR INSERT
    ON reservation
    FOR EACH ROW
EXECUTE PROCEDURE check_reservations_schedules();



--------------
--- (IC-2) ---
--------------

-- Function
CREATE OR REPLACE FUNCTION check_specialized_location()
    RETURNS TRIGGER AS
$$
BEGIN
    -- Verify if there are not repeated specializations
    IF EXISTS(
    (SELECT latitude,longitude FROM marina
    UNION ALL
    SELECT latitude,longitude FROM wharf
    UNION ALL
    SELECT latitude,longitude FROM port)
    EXCEPT ALL
    SELECT latitude,longitude FROM location)

    OR

    -- Verify if all locations are specialized
    EXISTS(
    SELECT latitude,longitude FROM location
    EXCEPT ALL
    (SELECT latitude,longitude FROM marina
    UNION ALL
    SELECT latitude,longitude FROM wharf
    UNION ALL
    SELECT latitude,longitude FROM port))

    THEN
        RAISE EXCEPTION '(IC-2) Every location should be specialized and the specialization should be disjoint';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


-- Triggers
DROP TRIGGER IF EXISTS tg_check_specialized_location ON marina;
DROP TRIGGER IF EXISTS tg_check_specialized_location ON wharf;
DROP TRIGGER IF EXISTS tg_check_specialized_location ON port;
DROP TRIGGER IF EXISTS tg_check_specialized_location ON location;

CREATE CONSTRAINT TRIGGER tg_check_specialized_location
    AFTER UPDATE OR INSERT OR DELETE
    ON marina
    DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
EXECUTE PROCEDURE check_specialized_location();

CREATE CONSTRAINT TRIGGER tg_check_specialized_location
    AFTER UPDATE OR INSERT OR DELETE
    ON wharf
    DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
EXECUTE PROCEDURE check_specialized_location();

CREATE CONSTRAINT TRIGGER tg_check_specialized_location
    AFTER UPDATE OR INSERT OR DELETE
    ON port
    DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
EXECUTE PROCEDURE check_specialized_location();

CREATE CONSTRAINT TRIGGER tg_check_specialized_location
    AFTER UPDATE OR INSERT OR DELETE
    ON location
    DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
EXECUTE PROCEDURE check_specialized_location();




--------------
--- (IC-3) ---
--------------

-- Function
CREATE OR REPLACE FUNCTION check_boats_registered_country_with_location()
    RETURNS TRIGGER AS
$$
BEGIN
    IF EXISTS(
        SELECT iso_code FROM boat
        EXCEPT
        SELECT iso_code FROM location)
    THEN
        RAISE EXCEPTION '(IC-3) A country where a boat is registered must correspond - at least - to one location.';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


-- Triggers
DROP TRIGGER IF EXISTS tg_check_boats_registered_country_with_location ON boat;
DROP TRIGGER IF EXISTS tg_check_boats_registered_country_with_location ON location;

CREATE TRIGGER tg_check_boats_registered_country_with_location
    AFTER UPDATE OR INSERT
    ON boat
    FOR EACH ROW
EXECUTE PROCEDURE check_boats_registered_country_with_location();

CREATE TRIGGER tg_check_boats_registered_country_with_location
    AFTER DELETE OR UPDATE
    ON location
    FOR EACH ROW
EXECUTE PROCEDURE check_boats_registered_country_with_location();


