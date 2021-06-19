/*
CREATE TABLE book_info_table
(
	book_id integer,
	book_name character varying,
	book_isbn character varying,
	genre_name character varying,
	price_base numeric(8,2),
	price_vip numeric(8,2),
	price_promo numeric(8,2)
);

INSERT INTO book_info_table (book_id, book_name, book_isbn, genre_name, price_base, price_vip, price_promo)
SELECT f.book_id, f.book_name, f.book_isbn, f.genre_name, f.price_base, f.price_vip, f.price_promo 
FROM book_store.get_book_info_by_author('Леонид Анциелович') f;

SELECT * FROM book_info_table;
*/
DROP FUNCTION IF EXISTS book_store.get_book_info_by_author(varchar);

CREATE OR REPLACE FUNCTION book_store.get_book_info_by_author   (IN p_author_name varchar)
RETURNS setof book_info_table
AS
$INF$
BEGIN
	RETURN QUERY
    SELECT B.book_id, B.book_name, B.isbn, G.genre_name,
           book_store.get_actual_price(B.book_id, 1)::numeric(8,2),
           book_store.get_actual_price(B.book_id, 2)::numeric(8,2),
           book_store.get_actual_price(B.book_id, 3)::numeric(8,2)
    FROM book_store.book B
    INNER JOIN book_store.book_author BA ON BA.book_id = B.book_id
    INNER JOIN book_store.author A ON A.author_id = BA.author_id
    INNER JOIN book_store.genre G ON B.genre_id = G.genre_id
    WHERE author_name = p_author_name;
END;
$INF$ LANGUAGE plpgsql;


SELECT * FROM book_store.get_book_info_by_author('Мартин Фаулер');
SELECT * FROM book_store.get_book_info_by_author('Леонид Анциелович');













