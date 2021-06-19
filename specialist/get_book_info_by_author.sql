CREATE OR REPLACE FUNCTION book_store.get_book_info_by_author   (
                                                                IN p_author_name varchar,
                                                                OUT p_book_id integer,
                                                                OUT p_p_book_name varchar,
                                                                OUT p_book_isbn varchar,
                                                                OUT p_genre_name varchar,
                                                                OUT p_price_base numeric (8, 2),
                                                                OUT p_price_vip numeric (8, 2),
                                                                OUT p_price_promo numeric (8, 2)
                                                                )
RETURNS setof record
AS
$INF$
    SELECT B.book_id, B.book_name, B.isbn, G.genre_name,
           book_store.get_actual_price(B.book_id, 1),
           book_store.get_actual_price(B.book_id, 2),
           book_store.get_actual_price(B.book_id, 3)
    FROM book_store.book B
    INNER JOIN book_store.book_author BA ON BA.book_id = B.book_id
    INNER JOIN book_store.author A ON A.author_id = BA.author_id
    INNER JOIN book_store.genre G ON B.genre_id = G.genre_id
    WHERE author_name = p_author_name;
$INF$ LANGUAGE sql;

SELECT * FROM book_store.get_book_info_by_author('Мартин Фаулер');
SELECT * FROM book_store.get_book_info_by_author('Леонид Анциелович');

-- вариации:
CREATE OR REPLACE FUNCTION book_store.get_book_info_by_author   (
                                                                IN p_author_name varchar,
                                                                OUT p_book_id integer,
                                                                OUT p_p_book_name varchar,
                                                                OUT p_book_isbn varchar,
                                                                OUT p_genre_name varchar,
                                                                OUT p_price_base numeric (8, 2),
                                                                OUT p_price_vip numeric (8, 2),
                                                                OUT p_price_promo numeric (8, 2)
                                                                )
RETURNS setof record
AS
$INF$
BEGIN
    RETURN QUERY
    SELECT B.book_id, B.book_name, B.isbn, G.genre_name,
           book_store.get_actual_price(B.book_id, 1),
           book_store.get_actual_price(B.book_id, 2),
           book_store.get_actual_price(B.book_id, 3)
    FROM book_store.book B
    INNER JOIN book_store.book_author BA ON BA.book_id = B.book_id
    INNER JOIN book_store.author A ON A.author_id = BA.author_id
    INNER JOIN book_store.genre G ON B.genre_id = G.genre_id
    WHERE author_name = p_author_name;
END;
$INF$ LANGUAGE plpgsql;

DROP FUNCTION IF EXISTS book_store.get_book_info_by_author(varchar);

DROP TYPE IF EXISTS book_info CASCADE;

CREATE TYPE book_info
AS  (
    book_id integer,
    p_book_name varchar,
    book_isbn varchar,
    genre_name varchar,
    price_base numeric,     -- !NB
    price_vip numeric,      -- !NB
    price_promo numeric     -- !NB
    );

CREATE OR REPLACE FUNCTION book_store.get_book_info_by_author   (IN p_author_name varchar)
RETURNS setof book_info
AS
$INF$
BEGIN
    RETURN QUERY
    SELECT B.book_id, B.book_name, B.isbn, G.genre_name,
           book_store.get_actual_price(B.book_id, 1),
           book_store.get_actual_price(B.book_id, 2),
           book_store.get_actual_price(B.book_id, 3)
    FROM book_store.book B
    INNER JOIN book_store.book_author BA ON BA.book_id = B.book_id
    INNER JOIN book_store.author A ON A.author_id = BA.author_id
    INNER JOIN book_store.genre G ON B.genre_id = G.genre_id
    WHERE author_name = p_author_name;
END;
$INF$ LANGUAGE plpgsql;


SELECT * FROM book_store.get_book_info_by_author('Мартин Фаулер');
SELECT * FROM book_store.get_book_info_by_author('Леонид Анциелович');


DROP FUNCTION IF EXISTS book_store.get_book_info_by_author(varchar);

CREATE OR REPLACE FUNCTION book_store.get_book_info_by_author   (IN p_author_name varchar)
RETURNS table   (
                book_id integer,
                p_book_name varchar,
                book_isbn varchar,
                genre_name varchar,
                price_base numeric(8, 2),
                price_vip numeric(8, 2),
                price_promo numeric(8, 2)
                )
AS
$INF$
    SELECT B.book_id, B.book_name, B.isbn, G.genre_name,
           book_store.get_actual_price(B.book_id, 1),
           book_store.get_actual_price(B.book_id, 2),
           book_store.get_actual_price(B.book_id, 3)
    FROM book_store.book B
    INNER JOIN book_store.book_author BA ON BA.book_id = B.book_id
    INNER JOIN book_store.author A ON A.author_id = BA.author_id
    INNER JOIN book_store.genre G ON B.genre_id = G.genre_id
    WHERE author_name = p_author_name;
$INF$ LANGUAGE sql;

SELECT * FROM book_store.get_book_info_by_author('Мартин Фаулер');
SELECT * FROM book_store.get_book_info_by_author('Леонид Анциелович');