-- Практическое задание по теме “Транзакции, переменные, представления”
-- 
-- (1.) В базе данных shop (в моем случае hw5) и sample присутствуют одни и те же таблицы, учебной базы данных. 
-- Переместите запись id = 1 из таблицы shop.users в таблицу sample.users. Используйте транзакции.

CREATE TABLE sample.users (
	id SERIAL,
	name VARCHAR(255),
	created_at DATETIME,
	updated_at DATETIME,
	age INT UNSIGNED,
	birthday_at DATETIME
);

START TRANSACTION;
INSERT INTO sample.users SELECT * FROM hw5.users WHERE id = 1;
COMMIT;
SELECT * FROM sample.users;
-- Вывод:
-- 1	Сергей	2017-10-20 08:10:00	2017-10-20 08:10:00	25	1995-04-21 16:03:53



-- (2.) Создайте представление, которое выводит название name товарной позиции из таблицы products и 
-- соответствующее название каталога name из таблицы catalogs.
USE hw5; -- hw5 = shop
CREATE VIEW products_view AS
SELECT 
	p.name "Name", 
	p.desription "Desription", 
	p.price "Price", 
	c.name "Type" 
FROM products p JOIN catalogs c 
ON p.catalog_id = c.id;

SHOW TABLES;
SELECT * FROM products_view;
-- Вывод:
-- Intel Core i3-8100	Процессор для настольных персональных компьютеров, основанных на платформе Intel.	7890.00	Процессоры
-- Intel Core i5-7400	Процессор для настольных персональных компьютеров, основанных на платформе Intel.	12700.00	Процессоры
-- AMD FX-8320E	Процессор для настольных персональных компьютеров, основанных на платформе AMD.	4780.00	Процессоры
-- AMD FX-8320	Процессор для настольных персональных компьютеров, основанных на платформе AMD.	7120.00	Процессоры
-- ASUS ROG MAXIMUS X HERO	Материнская плата ASUS ROG MAXIMUS X HERO, Z370, Socket 1151-V2, DDR4, ATX	19310.00	Материнские платы
-- Gigabyte H310M S2H	Материнская плата Gigabyte H310M S2H, H310, Socket 1151-V2, DDR4, mATX	4790.00	Материнские платы
-- MSI B250M GAMING PRO	Материнская плата MSI B250M GAMING PRO, B250, Socket 1151, DDR4, mATX	5060.00	Материнские платы



-- (3.) Пусть имеется таблица с календарным полем created_at. 
-- В ней размещены разряженые календарные записи за август 2018 года '2018-08-01', '2016-08-04', '2018-08-16' и 2018-08-17. 
-- Составьте запрос, который выводит полный список дат за август, выставляя в соседнем поле значение 1, 
-- если дата присутствует в исходном таблице и 0, если она отсутствует.

CREATE TEMPORARY TABLE august (created_at DATETIME);
CREATE TEMPORARY TABLE august_all (created_at DATETIME);
INSERT INTO august(created_at) VALUES ('2018-08-01'), ('2016-08-04'), ('2018-08-16'), ('2018-08-17');
DELIMITER // -- в DBEAVER не получилось даже через настройки. Пришлось процудуру создавать в консоли через ssh
CREATE PROCEDURE fill() 
	BEGIN
		DECLARE i INT DEFAULT 1;
		WHILE i <= 9 DO
    		INSERT INTO august_all(created_at) VALUES (CONCAT('2018-08-0', i));
    		SET i = i + 1;
		END WHILE;
		BEGIN
			WHILE i <= 31 DO
    			INSERT INTO august_all(created_at) VALUES (CONCAT('2018-08-', i));
    			SET i = i + 1;
			END WHILE;
		END;
	END//
DELIMITER ;
CALL fill();

SELECT aa.created_at, IF(a.created_at IS NULL, 0, 1)
FROM august a RIGHT JOIN august_all aa ON a.created_at = aa.created_at; 
-- вывод:
-- 2018-08-01 00:00:00	1
-- 2018-08-02 00:00:00	0
-- 2018-08-03 00:00:00	0
-- 2018-08-04 00:00:00	0
-- 2018-08-05 00:00:00	0
-- 2018-08-06 00:00:00	0
-- 2018-08-07 00:00:00	0
-- 2018-08-08 00:00:00	0
-- 2018-08-09 00:00:00	0
-- 2018-08-10 00:00:00	0
-- 2018-08-11 00:00:00	0
-- 2018-08-12 00:00:00	0
-- 2018-08-13 00:00:00	0
-- 2018-08-14 00:00:00	0
-- 2018-08-15 00:00:00	0
-- 2018-08-16 00:00:00	1
-- 2018-08-17 00:00:00	1
-- 2018-08-18 00:00:00	0
-- 2018-08-19 00:00:00	0
-- 2018-08-20 00:00:00	0
-- 2018-08-21 00:00:00	0
-- 2018-08-22 00:00:00	0
-- 2018-08-23 00:00:00	0
-- 2018-08-24 00:00:00	0
-- 2018-08-25 00:00:00	0
-- 2018-08-26 00:00:00	0
-- 2018-08-27 00:00:00	0
-- 2018-08-28 00:00:00	0
-- 2018-08-29 00:00:00	0
-- 2018-08-30 00:00:00	0
-- 2018-08-31 00:00:00	0



-- (4.) Пусть имеется любая таблица с календарным полем created_at. 
-- Создайте запрос, который удаляет устаревшие записи из таблицы, оставляя только 5 самых свежих записей.
SELECT * FROM august_all;
ALTER TABLE august_all ADD id INT; -- добавляем маркер id
UPDATE august_all SET id = DAY(created_at); -- заполняем маркер id в качестве дня 
SELECT @max := (COUNT(*)-5) FROM august_all; -- опеределяем id для отсечения и записываем его в переменную @max
DELETE FROM august_all WHERE id <= @max; -- удаляем все до точки отсечения включительно
SELECT * FROM august_all;
-- вывод:
-- 2018-08-27 00:00:00	27
-- 2018-08-28 00:00:00	28
-- 2018-08-29 00:00:00	29
-- 2018-08-30 00:00:00	30
-- 2018-08-31 00:00:00	31