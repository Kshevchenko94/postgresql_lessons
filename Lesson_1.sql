/* Connect to DB

psql -d demo -U postgres

\dt // show tables and views

*/

/* Create a table */
CREATE TABLE aircrafts
( aircraft_code char(3) NOT NULL,
  model text NOT NULL,
  range integer NOT NULL,
  CHECK (range > 0),
  PRIMARY KEY (aircraft_code)
);

CREATE TABLE seats
(
    aircraft_code char(3) NOT NULL,
    seat_no varchar(4) NOT NULL,
    fare_conditions varchar(10) NOT NULL,
    CHECK (fare_conditions IN ('Economy', 'Comfort', 'Business')),
    PRIMARY KEY (aircraft_code, seat_no),
    FOREIGN KEY (aircraft_code)
        REFERENCES aircrafts(aircraft_code)
        ON DELETE CASCADE
);

/* Delete a table */

DROP TABLE aircrafts;

/* Insert into table */

INSERT INTO aircrafts (aircraft_code, model, range)
    VALUES ('SU9', 'Sukhoi SuperJet-100', 3000);

/* Select from table */

SELECT * FROM aircrafts;

SELECT model, aircraft_code, range
    FROM aircrafts
    ORDER BY model;

SELECT model, aircraft_code, range
    FROM aircrafts
    WHERE range >= 4000 AND range <= 6000;

SELECT * FROM aircrafts WHERE aircraft_code = 'SU9';

/* Insert into table more rows */

INSERT INTO aircrafts (aircraft_code, model, range)
    VALUES ('773', 'Boeing 777-300', 11100),
            ('763', 'Boeing 767-300', 7900),
            ('733', 'Boeing 737-300', 4200),
            ('320', 'Airbus A320-200', 5700),
            ('321', 'Airbus A321-200', 5600),
            ('319', 'Airbus A319-100', 6700),
            ('CN1', 'Cessna 208 Caravan', 1200),
            ('CR2', 'Bombardier CRJ-200', 2700);

INSERT INTO seats VALUES ('123', '1A', 'Business');

INSERT INTO seats VALUES
    ('SU9', '1A', 'Business'),
    ('SU9', '1B', 'Business'),
    ('SU9', '10A', 'Economy'),
    ('SU9', '10B', 'Economy'),
    ('SU9', '10F', 'Economy'),
    ('SU9', '20F', 'Economy');

/* Update table */

UPDATE aircrafts SET range = 3500
    WHERE aircraft_code = 'SU9';

/* Delete rows from table */

DELETE FROM aircrafts WHERE aircraft_code = 'CN1';

DELETE FROM aircrafts WHERE range > 10000 OR range < 3000;