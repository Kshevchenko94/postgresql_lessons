-- Задача: разрешить сотруднику изменять оклады только по некоторым подразделениям

-- работаем под логином student

-- Оклады (иллюстрация, реальная таблица, конечно же, выглядела бы по-другому):
CREATE TABLE IF NOT EXISTS salaries
(
	department_name		varchar(63) NOT NULL,
	employe_name		varchar(127) NOT NULL,
	salary			numeric (8, 2) NOT NULL,
	
	CONSTRAINT pk_salaries PRIMARY KEY (department_name, employe_name)
);

TRUNCATE TABLE salaries;

INSERT INTO salaries (department_name, employe_name, salary)
VALUES 	('Логистика', 'Иванов', 85000.00),
	('Логистика', 'Петров', 70000.00),
	('Склад', 'Сидоров', 40000.00),
	('Склад', 'Johnson', 65000.00),
	('Управление', 'Семенов', 125000.00),
	('Управление', 'Семенова', 120000.00);


CREATE OR REPLACE FUNCTION updt_salary (p_department_name varchar(3), p_employe_name varchar(127), p_salary numeric (8, 2))
RETURNS void 
AS
$$
	UPDATE salaries
	SET salary = p_salary
	WHERE department_name 	= p_department_name
	  AND employe_name	= p_employe_name
          AND department_name IN ('Логистика', 'Склад');
	  
$$ 	LANGUAGE sql
	SECURITY INVOKER; 

-- REVOKE CONNECT ON DATABASE test_db FROM book_keeper;
DROP ROLE IF EXISTS book_keeper;
CREATE ROLE book_keeper LOGIN PASSWORD 'keeper';
GRANT CONNECT ON DATABASE BookShop TO book_keeper;

/*
	Создадим еще одно подключение к БД - под логином book_keeper
	(проще и быстрее всего - в командной строке с помощью psql):
	
			psql -hlocalhost -dBookShop -Ubook_keeper
			
	и попробуем выполнить UPDATE
	UPDATE salaries SET salary = 1.00 WHERE department_name = 'Управление' AND employe_name like ('Семенов%');
	Получим сообщение об ошибке: ОШИБКА:  нет доступа к отношению salaries
*/

-- если дать пользователю book_keeper права на UPDATE таблицы salaries - он сможет менять любые записи в обход ф-ции updt_salary.
-- Дадим ему только права на выполнение ф-ции updt_salary
GRANT EXECUTE ON FUNCTION updt_salary TO book_keeper;

/*
        Опять не работает:
        SELECT updt_salary ('Логистика', 'Петров', 100000.00);
        ОШИБКА:  нет доступа к отношению salaries
        КОНТЕКСТ:  SQL-функция "updt_salary", оператор 1
*/
-- Изменим атрибут SECURITY для ф-ции
ALTER FUNCTION updt_salary SECURITY DEFINER;
-- Всё заработало