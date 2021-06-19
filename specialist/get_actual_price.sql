/*
пока (до изучения темы "триггеры") удалим ограничения uq_price и fk_order_detail_price
на таблицах book_store.price и shop.order_detail соотвественно
 */
ALTER TABLE shop.order_detail DROP CONSTRAINT fk_order_detail_price
ALTER TABLE book_store.price DROP CONSTRAINT uq_price;

-- Подготовим данные (неактуальные цены)
INSERT INTO book_store.price (book_id, price_category_no, price_value, price_expired)
VALUES (3, 1, 1500.50, '2020-12-31'),
       (3, 2, 1200.00, '2020-12-31'),
       (3, 3, 4000.00, '2020-12-31'),
       (4, 1, 900.00, '2020-12-31'),
       (4, 2, 880.00, '2020-12-31'),
       (4, 3, 810.00, '2020-12-31'),
       (6, 1, 450.00, '2021-03-31'),
       (6, 2, 400.00, '2021-03-31'),
       (6, 3, 400.00, '2021-03-31'),
       (6, 1, 410.00, '2020-12-31'),
       (6, 2, 400.00, '2020-12-31'),
       (6, 3, 395.00, '2020-12-31');

CREATE OR REPLACE FUNCTION book_store.get_actual_price  (
                                                        IN p_book_id integer,
                                                        IN p_price_category_no integer,
                                                        IN p_date_actual date DEFAULT NULL  -- что предпочтителнее NULL или now()?
                                                        )
RETURNS numeric(8, 2)
AS
$$
DECLARE
    v_date_to_search  date;
    v_result_price    numeric(8, 2);

BEGIN
    SELECT MIN(price_expired)
    INTO v_date_to_search
    FROM book_store.price
    WHERE price_expired > p_date_actual
      AND book_id = p_book_id
      AND price_category_no = p_price_category_no;


    SELECT price_value
    INTO v_result_price
    FROM book_store.price
    WHERE book_id = p_book_id
      AND price_category_no = p_price_category_no
      AND price_expired IS NOT DISTINCT FROM v_date_to_search;

    RETURN v_result_price;

 END;
$$ LANGUAGE plpgsql;


SELECT book_store.get_actual_price (6, 1, '2021-02-23');
SELECT book_store.get_actual_price (6, 1, '2018-02-23');
SELECT book_store.get_actual_price (6, 1, now()::date);
SELECT book_store.get_actual_price (6, 1)


-- вариант без v_result_price:
CREATE OR REPLACE FUNCTION book_store.get_actual_price  (
                                                        IN p_book_id integer,
                                                        IN p_price_category_no integer,
                                                        IN p_date_actual date DEFAULT NULL  -- что предпочтителнее NULL или now()?
                                                        )
RETURNS numeric(8, 2)
AS
$$
DECLARE
    v_date_to_search  date;

BEGIN
    SELECT MIN(price_expired)
    INTO v_date_to_search
    FROM book_store.price
    WHERE price_expired > p_date_actual
      AND book_id = p_book_id
      AND price_category_no = p_price_category_no;

RETURN (
        SELECT price_value
