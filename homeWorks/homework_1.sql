CREATE OR REPLACE FUNCTION is_created_element(IN p_column varchar(255),
                                              IN p_table varchar(255),
                                              IN p_schema varchar(255),
                                              IN p_column_value varchar(255)
                                              )
RETURNS INTEGER
AS
$$
DECLARE
    v_result INTEGER;
BEGIN
    SELECT COUNT(p_column) INTO v_result FROM p_schema.p_table WHERE p_column = p_column_value;
    RETURN v_result;
END ;
$$ LANGUAGE plpgsql;

CREATE TYPE	tbl_user
AS
(
    username	text,
    user_password	text,
    last_name	text,
    first_name  text
);

CREATE OR REPLACE PROCEDURE sign_up(p_username text, p_user_password text, p_last_name text, p_first_name text)
    LANGUAGE plpgsql
AS $$
    IF is_created_element('id', 'users', 'public', 'username_1') == 0 THEN
        INSERT INTO users(username, user_password, last_name, first_name) VALUES (p_username, p_user_password, p_last_name, p_first_name);
    END IF;
$$;