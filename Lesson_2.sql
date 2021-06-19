/* Serial */
SELECT 0.1::real * 10 = 1.0::real;

CREATE TABLE name_table (name_column serial);

/* Эта команда эквивалентна следующей группе команд: */

CREATE SEQUENCE name_table_name_column_seq;
CREATE TABLE name_table
(
    name_column integer NOT NULL DEFAULT nextval('name_table_name_column_seq')
);
ALTER SEQUENCE name_table_name_column_seq OWNED BY name_table.name_column;

/* Символьные типы */

SELECT 'PostgreSQL';
SELECT 'PGDAY''17';
SELECT $$PGDAY$$;

/* Типы "Дата и время" */

SELECT '2016-09-12'::date;
SELECT 'Sep 12, 2016'::date;
SELECT current_date;
SELECT to_char(current_date, 'dd-mm-yyyy');

SELECT '21:15'::time;
SELECT '21:15:26'::time;
SELECT '10:15:16 am'::time;
SELECT '10:15:16 pm'::time;
SELECT current_time;

SELECT timestamp with time zone '2016-09-21 22:25:35';
SELECT timestamp '2016-09-21 22:25:35';
SELECT current_timestamp;

SELECT '1 years 2 months ago'::interval;
SELECT 'P0001-02-03T04:05:06'::interval;
SELECT ('2016-09-16'::timestamp - '2016-09-01'::timestamp)::interval;
SELECT (date_trunc('hour', current_timestamp));
SELECT extract('mon' FROM timestamp '1999-11-27 12:34:56.123459');

/* Логический тип */

CREATE TABLE databases (is_open_source boolean, dbms_name text);

INSERT INTO databases VALUES (TRUE, 'PostgreSQL');
INSERT INTO databases VALUES (FALSE, 'Oracle');
INSERT INTO databases VALUES (TRUE, 'MySQL');
INSERT INTO databases VALUES (FALSE, 'MS SQL Server');

SELECT * FROM databases;
SELECT * FROM databases WHERE is_open_source;

/* Массивы */

CREATE TABLE pilots
(
    pilot_name text,
    schedule integer[]
);

INSERT INTO pilots
    VALUES ('Ivan', '{1, 3, 5, 6, 7}'::integer[]),
           ('Petr', '{1, 2, 5, 7}'::integer[]),
           ('Pavel', '{2, 5}'::integer[]),
           ('Boris', '{3, 5, 6}'::integer[]);

SELECT * FROM pilots;

UPDATE pilots
    SET schedule = schedule || 7
    WHERE pilot_name = 'Boris';

UPDATE pilots
SET schedule = array_append(schedule, 6)
WHERE pilot_name = 'Pavel';

UPDATE pilots
SET schedule = array_prepend(1, schedule)
WHERE pilot_name = 'Pavel';

UPDATE pilots
SET schedule = array_remove(schedule, 5)
WHERE pilot_name = 'Ivan';

UPDATE pilots
SET schedule[1] = 2, schedule[2] = 3
WHERE pilot_name = 'Petr';

UPDATE pilots
SET schedule[1:2] = ARRAY[2, 3]
WHERE pilot_name = 'Petr';

SELECT * FROM pilots WHERE array_position(schedule, 3) IS NOT NULL;

SELECT * FROM pilots WHERE schedule @> '{1, 7}'::integer[];
SELECT * FROM pilots WHERE schedule && ARRAY[2,5];
SELECT * FROM pilots WHERE NOT (schedule && ARRAY[2,5]);

SELECT unnest(schedule) AS days_of_week FROM pilots WHERE pilot_name = 'Ivan';

/* JSON */

CREATE TABLE pilot_hobbies
(
    pilot_name text,
    hobbies jsonb
);

INSERT INTO pilot_hobbies
VALUES ( 'Ivan',
         '{ "sports": [ "футбол", "плавание" ],
           "home_lib": true, "trips": 3
         }'::jsonb ),
       ( 'Petr',
         '{ "sports": [ "теннис", "плавание" ],
           "home_lib": true, "trips": 2
         }'::jsonb
       ),
       ( 'Pavel',
         '{ "sports": [ "плавание" ],
           "home_lib": false, "trips": 4
         }'::jsonb ),
       ( 'Boris',
         '{ "sports": [ "футбол", "плавание", "теннис" ],
           "home_lib": true, "trips": 0
         }'::jsonb
       );

SELECT * FROM pilot_hobbies;

SELECT * FROM pilot_hobbies
WHERE hobbies @> '{ "sports": [ "футбол" ] }'::jsonb;

SELECT pilot_name, hobbies->'sports' AS sports
FROM pilot_hobbies
WHERE hobbies->'sports' @> '[ "футбол" ]'::jsonb;

SELECT count( * )
FROM pilot_hobbies
WHERE hobbies ? 'sport';

UPDATE pilot_hobbies
SET hobbies = hobbies || '{ "sports": [ "хоккей" ] }'
WHERE pilot_name = 'Boris';

SELECT pilot_name, hobbies
FROM pilot_hobbies
WHERE pilot_name = 'Boris';

UPDATE pilot_hobbies
SET hobbies = jsonb_set( hobbies, '{ sports, 1 }', '"футбол"' )
WHERE pilot_name = 'Boris';

SELECT pilot_name, hobbies
FROM pilot_hobbies
WHERE pilot_name = 'Boris';
