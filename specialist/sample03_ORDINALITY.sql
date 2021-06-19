CREATE TYPE ord	AS	(
			order_id integer,
			client_login varchar(31),
			order_no char(14),
			order_date date
			);

			
CREATE OR REPLACE FUNCTION shop.get_orders_by_client (p_client_login varchar(31))
RETURNS setof ord
AS
$$
	SELECT order_id, client_login, order_no, order_date
	FROM shop.order_main
	WHERE client_login = p_client_login
	ORDER BY order_date, order_id;
$$
LANGUAGE sql
	STABLE 
	SECURITY DEFINER
	STRICT
	COST 100;

-- SELECT * FROM shop.get_orders_by_client ('Peter I') WITH ORDINALITY;
-- SELECT * FROM shop.get_orders_by_client ('Peter I') WITH ORDINALITY ORDER BY ordinality DESC;
