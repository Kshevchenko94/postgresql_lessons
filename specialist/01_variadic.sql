CREATE FUNCTION biggest (p1 anyelement, p2 anyelement)
RETURNS anyelement
AS
$$
        SELECT CASE WHEN p1 > p2 THEN P1 ELSE P2 END;
$$ IMMUTABLE
LANGUAGE sql;

SELECT biggest (99.6, 4.1);
SELECT biggest (99.6, 4);       -- не работает, почему?
SELECT biggest ('3', '6');      -- не работает, почему? (*: так могут быть представлены не только строки, но и json!)
-- необходимо что бы для используемого типа был определён оператор ">"

-- не самое корректное поведение - 
SELECT biggest (NULL, 4); 
SELECT biggest (4, NULL);
-- как исправить?



CREATE OR REPLACE FUNCTION biggest (p1 anyelement, p2 anyelement, p3 anyelement DEFAULT NULL)
RETURNS anyelement
AS
$$
    SELECT CASE
               WHEN p3 IS NULL THEN x
               ELSE
                   CASE WHEN x > p3 THEN x ELSE p3 END
           END
    FROM (
           SELECT CASE WHEN p1 > p2 THEN p1 ELSE p2 END
         ) choise(x);
$$ IMMUTABLE
LANGUAGE sql;

SELECT biggest (1, 4);  -- не работает, почему?
DROP FUNCTION IF EXISTS biggest(anyelement, anyelement);
SELECT biggest (4, 1, 99);
SELECT biggest (1, 7, -9);
--------------------------------------------------------------------------------------------
-- напишем такую же ф-цию для произвольного к-ва integer-значенй
DROP FUNCTION IF EXISTS biggest (integer[]);

CREATE OR REPLACE FUNCTION biggest(VARIADIC p_arr integer[])
RETURNS integer
AS
$$
DECLARE
    i           integer;
    max_of_ar    integer;
BEGIN
    FOREACH i IN ARRAY p_arr LOOP
        IF i IS NOT NULL AND (max_of_ar IS NULL OR i > max_of_ar) THEN
            max_of_ar = i;
        END IF;
    END LOOP;
    RETURN max_of_ar;
END;
$$ IMMUTABLE
LANGUAGE plpgsql;

SELECT biggest (1, 55, 43, 1, 2, 99, 101, 6, 3);
---------------------------------------------------------------------------------------------

-- Полиморфный вариант с VARIADIC, пробуем:  
CREATE OR REPLACE FUNCTION biggest(VARIADIC p_arr anyarray)
RETURNS anyelement
AS
$$
DECLARE
    x           anyelement;     -- так нельзя! anyelement ддопустим только в опредлении параметров ф-ции и/или выозвращаемых зныачений,
    max_of_ar    anyelement;     -- но не переменных. Переменные должны иметь реальный тип!         
BEGIN
    FOREACH x IN ARRAY p_arr
    LOOP
        IF x IS NOT NULL AND (max_of_ar IS NULL OR x > max_of_ar) THEN
            max_of_ar := x;
        END IF;
    END LOOP;
    
    RETURN max_of_ar;
END;
$$ IMMUTABLE
LANGUAGE plpgsql;
--- меняем определение:


DROP FUNCTION IF EXISTS biggest(anyarray);

CREATE OR REPLACE FUNCTION biggest(VARIADIC p_arr anyarray, OUT max_of_ar anyelement)     -- "RETURNS" убираем!
AS
$$
DECLARE
        -- как поступить с 
    --x           anyelement;
    x   max_of_ar%TYPE;         -- см. п. 42.3.3. Наследование типов данных
BEGIN
    FOREACH x IN ARRAY p_arr
    LOOP
        IF x IS NOT NULL AND (max_of_ar IS NULL OR x > max_of_ar)
        THEN
            max_of_ar := x;
        END IF;
    END LOOP;
    
    -- RETURN max_of_ar;        тоже убираем
END;
$$ IMMUTABLE
LANGUAGE plpgsql;

SELECT biggest (1, 55, 43, 1);
SELECT biggest (1., 55., 43::numeric, 1.11);
SELECT biggest ('one', 'TWO', 'three', 'Four');
SELECT biggest ('one'::varchar, 'TWO'::varchar, 'three'::varchar, 'Four'::varchar);
---------------------------------------------------------------------------------------------
