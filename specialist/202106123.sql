/*
CREATE TYPE	tbl_desk
AS
(
table_name	text,		-- полное имя таблицы (включая схему)
column_name	text,
column_str	text
);
*/
DROP FUNCTION IF EXISTS get_all_names (text);

CREATE OR REPLACE FUNCTION public.get_all_names (p_serach_string text)
RETURNS setof tbl_desk
AS
$BODY$
DECLARE
	v_table_name	text;
	v_column_name	text;
	v_query			text;
	v_filter		text;

BEGIN
	-- DROP TABLE IF EXISTS tmp_results;

	CREATE TEMP TABLE tmp_results	(
									table_name	text,		-- полное имя таблицы (включая схему)
									column_name	text,
									column_str	text
									)ON COMMIT DROP;
									
	
	 v_filter = $F2$ ilike '%$F2$ || p_serach_string || $F2$%'$F2$;

	FOR v_table_name, v_column_name
	IN
		SELECT table_schema || '.' || table_name AS table_name, column_name
		FROM information_schema.columns C
		WHERE C.column_name LIKE '%name'		-- должно соблюдаться правило именования столбцов
		  AND C.table_schema NOT LIKE 'pg_%'
		  AND C.table_schema <> 'information_schema'
	LOOP
			v_query = 'SELECT ' || quote_literal(v_table_name) || ', ' || quote_literal(v_column_name) || ', ' || v_column_name || ' FROM ' || v_table_name || ' WHERE '|| v_column_name || v_filter || ';';
			v_query = 'INSERT INTO tmp_results (table_name, column_name, column_str) ' || v_query;
			RAISE NOTICE 'v_query = %', v_query;
			
			EXECUTE v_query;
	END LOOP;

	RETURN QUERY
	SELECT T.table_name, T.column_name, T.column_str FROM tmp_results T;
END;
$BODY$
	LANGUAGE plpgsql
	VOLATILE
	SECURITY DEFINER
;	

SELECT * FROM public. get_all_names ('Сикорский');
SELECT * FROM public. get_all_names ('истор');
   























