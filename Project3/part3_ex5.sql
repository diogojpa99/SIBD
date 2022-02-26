

--- 5. Application Development ---

-- a) Register and remove owners

-- Remove --

-- Para remover um owner:
-- caso esse owner não seja um sailor, remove-se essa instancia em person
-- remover todos os barcos que pertecem ao owner que vai ser removido
-- remover todas as reservas dos respetivos barcos
-- remover todos os schedule das reservas e todas as trips

CREATE OR REPLACE PROCEDURE delete_owner(owner_iso_code VARCHAR(2), owner_id VARCHAR(20))
RETURNS VOID AS
$$
DECLARE cursor_sailor CURSOR FOR
        SELECT *
        FROM owner o
            NATURAL JOIN person p
            NATURAL JOIN sailor s
        WHERE o.id = owner_id AND o.iso_code = owner_iso_code;
DECLARE sailor_row sailor%ROWTYPE;
DECLARE boat_cni AS VARCHAR(15);
DECLARE boat_iso_code AS VARCHAR(2);
DECLARE cursor_boat CURSOR FOR
        SELECT *
        FROM boat b
        WHERE b.id_owner = owner_id AND b.iso_code_owner = owner_iso_code;
BEGIN
    IF owner_id EXISTS (SELECT id FROM owner)
        AND owner_iso_code EXISTS (SELECT iso_code FROM owner) THEN

        -- APAGAR OWNER DA TABLE PERSON SE NÃO EXISTIR NA TABLE SAILOR
        OPEN cursor_sailor;
        LOOP
            FETCH cursor_sailor INTO sailor_row;
            IF NOT FOUND THEN
                DELETE FROM person
                WHERE id = owner_id AND iso_code = owner_iso_code;
            END IF;
        END LOOP;
        CLOSE cursor_sailor;

        -- APAGAR RESPETIVOS BARCOS
        OPEN cursor_boat;
        LOOP
            FETCH cursor_boat INTO sailor_row;

            END IF;
        END LOOP;
        CLOSE cursor_boat;

    END IF;

    RETURN;

END;
$$ LANGUAGE plpgsql;


-- Dúvida: returns void ou returns NULL ?

--- AUX ---

--         IF owner_id EXISTS (SELECT o.id FROM owner o
--                     NATURAL JOIN person p
--                     NATURAL JOIN sailor s) AND owner_iso_code EXISTS (SELECT o.iso_code FROM owner o
--                                                                 NATURAL JOIN person p
--                                                                 NATURAL JOIN sailor s) THEN
--                 -- NÃO APAGAMOS O OWNER DE TABELA PERSON
--         ELSE
--             DELETE FROM person
--             WHERE id = owner_id AND iso_code = owner_iso_code;
--         END IF;


