-- Практическое задание по теме “Хранимые процедуры и функции, триггеры"
-- 
-- (1.) Создайте хранимую функцию hello(), которая будет возвращать приветствие, в зависимости от текущего времени суток. 
-- С 6:00 до 12:00 функция должна возвращать фразу "Доброе утро", с 12:00 до 18:00 функция должна возвращать фразу 
-- "Добрый день", с 18:00 до 00:00 — "Добрый вечер", с 00:00 до 6:00 — "Доброй ночи".
DELIMITER // -- в DBEAVER не получилось даже через настройки. Пришлось функцию создавать в консоли через ssh
CREATE FUNCTION hello()
RETURNS TEXT DETERMINISTIC
BEGIN
  	RETURN CASE
    WHEN HOUR(NOW()) >= 18 THEN 'Добрый вечер!'
    WHEN HOUR(NOW()) >= 12 THEN 'Добрый день!'
    WHEN HOUR(NOW()) >= 6 THEN 'Доброе утро!'
    WHEN HOUR(NOW()) >= 0 THEN 'Добрый вечер!'
	END;
END//
DELIMITER ;
SELECT hello();
-- вывод:
-- Добрый день!



-- (2.) В таблице products есть два текстовых поля: name с названием товара и description с его описанием. 
-- Допустимо присутствие обоих полей или одно из них. Ситуация, когда оба поля принимают неопределенное значение NULL неприемлема.
-- Используя триггеры, добейтесь того, чтобы одно из этих полей или оба поля были заполнены.
-- При попытке присвоить полям NULL-значение необходимо отменить операцию.
USE hw5;
DELIMITER //
CREATE TRIGGER product_not_null BEFORE INSERT ON products
FOR EACH ROW
BEGIN
  IF (NEW.name IS NULL) AND (NEW.desription IS NULL)
 	THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Ситуация, когда name с названием товара и description с его описанием принимают неопределенное значение NULL неприемлема!';
  END IF;
END//

CREATE TRIGGER product_not_null_u BEFORE UPDATE ON products
FOR EACH ROW
BEGIN
  IF (NEW.name IS NULL) AND (NEW.desription IS NULL)
 	THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Ситуация, когда name с названием товара и description с его описанием принимают неопределенное значение NULL неприемлема!';
  END IF;
END//
DELIMITER ;

INSERT INTO products (name, desription) VALUES (NULL, NULL);
-- вывод
-- SQL Error [1644] [45000]: Ситуация, когда name с названием товара и description с его описанием принимают неопределенное значение NULL неприемлема!
UPDATE products SET name=NULL, desription=NULL WHERE id=7;
-- вывод
-- SQL Error [1644] [45000]: Ситуация, когда name с названием товара и description с его описанием принимают неопределенное значение NULL неприемлема!