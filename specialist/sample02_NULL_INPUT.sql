
CREATE OR REPLACE FUNCTION get_book_id (p_book_name varchar(255))
RETURNS integer
AS
$$
        SELECT book_id FROM book_store.book WHERE book_name = p_book_name;
$$
LANGUAGE sql
;

SELECT get_book_id ('Введение в системы баз данных');
SELECT get_book_id ('Книга, которой нет');
SELECT get_book_id ('NULL');

CREATE OR REPLACE FUNCTION get_book_id (p_book_name varchar(255))
RETURNS integer
AS
$$
        SELECT book_id FROM book_store.book WHERE book_name = p_book_name;
$$
LANGUAGE sql
RETURNS NULL ON NULL INPUT
;

--Как убедиться, что тело аункции не выполняется?