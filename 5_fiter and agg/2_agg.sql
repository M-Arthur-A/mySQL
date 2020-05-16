-- 1 задание
USE hw5;
ALTER TABLE users ADD age INT UNSIGNED DEFAULT 1;
UPDATE users SET age = 25 WHERE id = 1;
UPDATE users SET age = 19 WHERE id = 2;
UPDATE users SET age = 49 WHERE id = 3;
-- DELETE FROM users where id > 3;
SELECT * FROM users;
SELECT AVG(age) FROM users;

-- 2 задание
ALTER TABLE users ADD birthday_At DATETIME;
-- считаем год
UPDATE users SET birthday_At = NOW() - INTERVAL age YEAR WHERE id = 1;
UPDATE users SET birthday_At = NOW() - INTERVAL age YEAR WHERE id = 2;
UPDATE users SET birthday_At = NOW() - INTERVAL age YEAR WHERE id = 3;
-- считаем день
UPDATE users SET birthday_At = birthday_At - INTERVAL 25 DAY WHERE id = 1;
UPDATE users SET birthday_At = birthday_At - INTERVAL 65 DAY WHERE id = 2;
UPDATE users SET birthday_At = birthday_At + INTERVAL 6 DAY WHERE id = 3;
SELECT * FROM users;
SELECT DATE(CONCAT_WS('-', YEAR(NOW()), MONTH(birthday_At), DAY(birthday_At))) AS Bday FROM users;
SELECT DATE_FORMAT(DATE(CONCAT_WS('-', YEAR(NOW()), MONTH(birthday_At), DAY(birthday_At))), '%W') AS Bday, COUNT(*) AS total FROM users GROUP BY Bday ORDER BY total DESC;