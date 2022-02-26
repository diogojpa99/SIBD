
--- (IC-1) ---

CREATE OR REPLACE FUNCTION check_reservation()
RETURNS TRIGGER AS
$$
BEGIN
    IF NEW.start_date >= (SELECT r.start_date FROM reservation r
        WHERE r.cni = NEW.cni AND r.iso_code_boat = NEW.iso_code_boat)
            AND NEW.start_date < (SELECT r.end_date FROM reservation r
                WHERE r.cni = NEW.cni AND r.iso_code_boat = NEW.iso_code_boat)
                    THEN
                        RAISE EXCEPTION ' Two reservations for the same boat can not have their corresponding date intervals intersecting.';
    ELSEIF NEW.end_date <= (SELECT r.end_date FROM reservation r
        WHERE r.cni = NEW.cni AND r.iso_code_boat = NEW.iso_code_boat)
            AND NEW.end_date > (SELECT r.start_date FROM reservation r
                WHERE r.cni = NEW.cni AND r.iso_code_boat = NEW.iso_code_boat)
                    THEN
                        RAISE EXCEPTION ' Two reservations for the same boat can not have their corresponding date intervals intersecting.';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tg_verify_reservation
    BEFORE INSERT ON reservation
    FOR EACH ROW
EXECUTE PROCEDURE check_reservation();

-- Delete:
DROP TRIGGER tg_verify_reservation ON reservation;
DROP FUNCTION check_reservation();




--- (IC-2) ---

CREATE OR REPLACE FUNCTION check_location()
RETURNS TRIGGER AS
$$
BEGIN
    IF NEW.latitude IN (SELECT m.latitude FROM marina m)
        AND NEW.longitude IN (SELECT m.latitude FROM marina m)
            THEN
                RETURN NEW;
    ELSEIF NEW.latitude IN (SELECT w.latitude FROM warf w)
        AND NEW.longitude IN (SELECT w.latitude FROM warf w)
            THEN
                RETURN NEW;
    ELSEIF NEW.latitude IN (SELECT p.latitude FROM port p)
        AND NEW.longitude IN (SELECT p.latitude FROM port p)
            THEN
                RETURN NEW;
    ELSE
        RAISE EXCEPTION 'Any location must be specialized in one of three - disjoint - entities: marina, wharf, or port.';
    END IF;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tg_verify_location
    BEFORE INSERT ON location
    FOR EACH ROW
EXECUTE PROCEDURE check_location();

-- Delete:
DROP TRIGGER tg_verify_location ON location;
DROP FUNCTION check_location();


--- (IC-3) ---


-- Primeiro perceber o que está a acontecer:
select * from boat;
select * from location;

---

CREATE OR REPLACE FUNCTION check_reg()
RETURNS TRIGGER AS
$$
BEGIN
    IF NEW.iso_code NOT IN (
        select l.iso_code
        from location l
        )
    then
        RAISE EXCEPTION 'A country where a boat is registered must correspond - at least - to one location.';
    end if;
END;
$$LANGUAGE plpgsql;

CREATE TRIGGER tg_verify_registration
    AFTER UPDATE OR INSERT ON boat
    FOR EACH ROW EXECUTE PROCEDURE check_reg();

-- Delete:
DROP TRIGGER tg_verify_registration ON boat;
DROP FUNCTION check_reg();
