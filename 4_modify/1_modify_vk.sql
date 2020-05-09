USE vk;

CREATE TABLE configuration (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  user_id INT UNSIGNED NOT NULL,
  parol VARCHAR(50) NOT NULL UNIQUE,
  language VARCHAR(50) NOT NULL,
  verification BOOLEAN,
  url_adress VARCHAR(150) NOT NULL UNIQUE,
  visible_id TINYINT UNSIGNED NOT NULL
);
DROP TABLE configuration;

CREATE TABLE visibility (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  vis VARCHAR(255) NOT NULL
);
DROP TABLE visibility;

ALTER TABLE profiles ADD photo INT UNSIGNED FIRST;
ALTER TABLE profiles DROP COLUMN photo;

ALTER TABLE profiles ADD photo_id INT UNSIGNED AFTER user_id;


CREATE TABLE user_statuses (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(150) NOT NULL UNIQUE
);

INSERT user_statuses (id, name)
VALUES
  (1, 'active'),
  (2, 'blocked'),
  (3, 'deleted');

ALTER TABLE users ADD status_id INT UNSIGNED NOT NULL DEFAULT 1 AFTER phone;

ALTER TABLE profiles ADD is_private BOOLEAN DEFAULT FALSE AFTER country;

SELECT * FROM users LIMIT 10;
UPDATE users SET updated_at = CURRENT_TIMESTAMP WHERE created_at > updated_at;
SELECT * FROM users LIMIT 10;

SELECT * FROM profiles LIMIT 10;
UPDATE profiles SET photo_id = FLOOR(1 + RAND() * 100);

CREATE TEMPORARY TABLE genders (name CHAR(1));
INSERT INTO genders VALUES ('m'), ('w');
SELECT * FROM genders;
-- Обновляем пол
UPDATE profiles 
  SET gender = (SELECT name FROM genders ORDER BY RAND() LIMIT 1);
-- Проставляем приватность
UPDATE profiles SET is_private = TRUE WHERE user_id > FLOOR(1 + RAND() * 100);  


SELECT * FROM messages LIMIT 10;
-- все норм

SELECT * FROM media LIMIT 10;
DELETE FROM media_types;
INSERT INTO media_types (name) VALUES
  ('photo'),
  ('video'),
  ('audio')
;
TRUNCATE media_types;
INSERT INTO media_types (name) VALUES
  ('photo'),
  ('video'),
  ('audio')
;
UPDATE media SET media_type_id = FLOOR(1 + RAND() * 3);

-- Создаём временную таблицу форматов медиафайлов
CREATE TEMPORARY TABLE extensions (name VARCHAR(10));
-- Заполняем значениями
INSERT INTO extensions VALUES ('jpeg'), ('avi'), ('mpeg'), ('png');
-- Проверяем
SELECT * FROM extensions;

-- Обновляем ссылку на файл
UPDATE media SET filename = CONCAT('https://dropbox/vk/',
  filename,
  '.',
  (SELECT name FROM extensions ORDER BY RAND() LIMIT 1)
);
UPDATE media SET size = FLOOR(10000 + (RAND() * 1000000)) WHERE size < 1000;

UPDATE media SET metadata = CONCAT('{"owner":"', 
  (SELECT CONCAT(first_name, ' ', last_name) FROM users WHERE id = user_id),
  '"}');  
DESC media;
ALTER TABLE media MODIFY COLUMN metadata JSON;

SELECT * FROM friendship LIMIT 10;
-- все норм

-- Анализируем данные 
SELECT * FROM friendship_statuses;
TRUNCATE friendship_statuses;
-- Вставляем значения статусов дружбы
INSERT INTO friendship_statuses (name) VALUES
  ('Requested'),
  ('Confirmed'),
  ('Rejected');

UPDATE friendship SET status_id = FLOOR(1 + RAND() * 3); 

SELECT * FROM communities;
DELETE FROM communities WHERE id > 25;
