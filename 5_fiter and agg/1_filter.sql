-- 1 задание
CREATE DATABASE hw5;
USE hw5;
CREATE TABLE users (id SERIAL PRIMARY KEY, name VARCHAR(255), created_at DATETIME, updated_at DATETIME);

INSERT INTO users(name, created_at, updated_at) VALUES ('Сергей', NULL, NULL), ('Алексей', NULL, NULL), ('Михаил', NULL, NULL);

UPDATE users SET created_at = NOW(), updated_at = NOW();
SELECT * FROM users;

-- 2 задание
DROP TABLE users; 
CREATE TABLE users (id SERIAL PRIMARY KEY, name VARCHAR(255), created_at VARCHAR(255), updated_at VARCHAR(255));
INSERT INTO users(name, created_at, updated_at) VALUES ('Сергей', '20.10.2017 8:10', '20.10.2017 8:10'), ('Алексей', CONCAT('20.10.2017 8:', FLOOR(10 + RAND(1) * 60)), CONCAT('20.10.2017 8:', FLOOR(10 + RAND(1) * 60))), ('Михаил', CONCAT('20.10.2017 8:', FLOOR(10 + RAND(1) * 60)), CONCAT('20.10.2017 8:', FLOOR(10 + RAND(1) * 60)));
SELECT STR_TO_DATE(created_at, '%d.%m.%Y %k:%i') FROM users;
UPDATE users SET created_at = STR_TO_DATE(created_at, '%d.%m.%Y %k:%i'), updated_at = STR_TO_DATE(updated_at, '%d.%m.%Y %k:%i');
SELECT * FROM users;
DESC users;
ALTER TABLE users CHANGE created_at created_at DATETIME;
ALTER TABLE users CHANGE updated_at updated_at DATETIME;


-- 3 задание
CREATE TABLE storehouses_products (id SERIAL PRIMARY KEY, value INT UNSIGNED);
SELECT * FROM storehouses_products;
dESC storehouses_products;
INSERT INTO storehouses_products(value) VALUES (1), (1), (2), (215), (0), (1551), (1244);
SELECT * FROM storehouses_products ORDER BY value;
SELECT id, value, IF(value > 0, 0, 1) AS empties FROM storehouses_products ORDER BY empties, value;





