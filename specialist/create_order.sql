/*
CREATE OR REPLACE FUNCTION shop.create_order	(
						IN p_client_login	varchar(31),
						IN p_details		shop.order_detail[]
						)
RETURNS integer
AS
$$
BEGIN
	WITH ins_main
	AS
	(
	-- правильный вариант INSERT INTO order_main (client_login) VALUES (p_client_login) RETURNING order_id
	INSERT INTO order_main (client_login, order_no)
	VALUES (
		p_client_login,
		-- Неправильное определение номера. После создания триггера - удалить
		lpad(currval('order_main_order_cnt_seq'::regclass)::text, 5, '0') || '/' ||
			date_part('year', current_date)::text || '-' ||
			to_char(current_date, 'mon')
		)
	RETURNING order_id
	)
	INSERT INTO order_detail (order_id, book_id, qty, price_category_no)
	SELECT M.order_id, D.book_id, D.qty, D.price_category_no
	FROM 	ins_main M,
		unnest (p_details) D;

	RETURN 0;
END;
$$
LANGUAGE plpgsql
	VOLATILE
	SECURITY DEFINER
	STRICT
	SET search_path = 'shop', 'public'
	COST 100;
*/

CREATE OR REPLACE PROCEDURE shop.create_order	(
                                                IN p_client_login	varchar(31),
                                                IN p_details		shop.order_detail[] -- тип!
                                                )
AS
$$
DECLARE
    v_order_id  integer;
BEGIN
    SET search_path = 'shop', 'public';

	INSERT INTO shop.order_main (client_login, order_no)
	VALUES (
		    p_client_login,
		    -- Неправильное определение номера. После создания триггера - удалить
		    lpad(currval('order_main_order_cnt_seq'::regclass)::text, 5, '0') || '/' ||
			    date_part('year', current_date)::text || '-' ||
                to_char(current_date, 'mon')
		    )
	RETURNING order_id INTO v_order_id;

    RAISE NOTICE 'v_order_id = %', v_order_id;

    IF v_order_id > 900
    THEN
       ROLLBACK;
	   RETURN;
    END IF;

 	INSERT INTO shop.order_detail (order_id, book_id, qty, price_category_no)
	SELECT v_order_id, D.book_id, D.qty, D.price_category_no
	FROM unnest (p_details) D;


    --COMMIT;
END;
$$
LANGUAGE plpgsql
    --SECURITY DEFINER
    --SET search_path = 'shop', 'public'
;

CALL shop.create_order('Ivanoff', ARRAY[(NULL, 1, 2, 2), (NULL, 2, 1, 1), (NULL, 4, 1, 2)]::shop.order_detail[])

SELECT * FROM shop.order_main ORDER BY order_id DESC;