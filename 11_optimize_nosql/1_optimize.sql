-- Практическое задание по теме “Оптимизация запросов”
-- (1.) Создайте таблицу logs типа Archive. Пусть при каждом создании записи в таблицах users, catalogs и products в таблицу logs 
-- помещается время и дата создания записи, название таблицы, идентификатор первичного ключа и содержимое поля name.
USE hw5;
CREATE TABLE logs (
	id INT(11) AUTO_INCREMENT NOT NULL PRIMARY KEY,
	tbl VARCHAR(255),
	tbl_id INT,
	tbl_name VARCHAR(255),
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP) ENGINE=Archive;

-- DROP TRIGGER IF EXISTS user_logging;
DELIMITER //
CREATE TRIGGER user_logging AFTER INSERT ON users
FOR EACH ROW
BEGIN
	INSERT INTO logs (tbl,tbl_id, tbl_name) VALUES ('users', NEW.id, NEW.name);
END//

CREATE TRIGGER catalog_logging AFTER INSERT ON catalogs
FOR EACH ROW
BEGIN
	INSERT INTO logs (tbl,tbl_id, tbl_name) VALUES ('catalogs', NEW.id, NEW.name);
END//

CREATE TRIGGER products_logging AFTER INSERT ON products
FOR EACH ROW
BEGIN
	INSERT INTO logs (tbl,tbl_id, tbl_name) VALUES ('products', NEW.id, NEW.name);
END//
DELIMITER ;

INSERT INTO users(name) VALUES ('Андрей');
SELECT * FROM logs;
-- Вывод:
-- |id         |tbl        |tbl_id     |tbl_name     |created_at         |
-- |-----------|-----------|-----------|-------------|-------------------|
-- |1          |users      |19         |Андрей       |2020-06-05 21:45:17|
