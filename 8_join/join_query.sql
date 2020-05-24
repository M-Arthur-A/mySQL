USE vk;

-- Задание 1. Подсчитать общее количество лайков десяти самым молодым пользователям (сколько лайков получили 10 самых молодых пользователей).
SELECT * FROM profiles;
SELECT * FROM likes;

-- старое решение с вложенным запросом (неисправленное):
SELECT 
 name, MAX(age) as age
FROM
(SELECT
	user_id,
	(SELECT CONCAT(first_name, ' ', last_name) FROM users u WHERE u.id = l.user_id) name,
	(SELECT TIMESTAMPDIFF(YEAR, birthday, NOW()) FROM profiles p WHERE p.user_id = l.user_id) age
FROM likes l WHERE target_type_id = 2) ll
GROUP BY name
ORDER BY age
LIMIT 10;

-- Комментарии преподавателя: "likes.user_id это тот кто поставил лайк, в данном случае нужно проверять target_id".
-- Исправленная версия с вложенным запросом, но внутри SELECT, а не FROM:
SELECT
	(SELECT CONCAT(first_name, ' ', last_name) FROM users u WHERE u.id = l.target_id) "Имя",
	(SELECT TIMESTAMPDIFF(YEAR, birthday, NOW()) FROM profiles p WHERE p.user_id = l.target_id) "Возраст",
	count(*) "Получил лайков"
FROM likes l
GROUP BY l.target_id
ORDER BY "Возраст"
LIMIT 10;

-- Вывод:
-- Jillian Volkman	11	4
-- Paul Bradtke	47	3
-- Devyn Lowe	27	3
-- Jamir Olson	26	4
-- Myriam Tremblay	29	5
-- Cindy Murray	46	2
-- Susana Hyatt	19	2
-- Jaden Bogisich	45	2
-- Alexis Okuneva	21	1
-- Karl Reilly	49	5

-- решение с JOIN:
SELECT 
	CONCAT(u.first_name, ' ', u.last_name) "Имя",
	TIMESTAMPDIFF(YEAR, p.birthday, NOW()) "Возраст",
	COUNT(l.id) "Получил лайков"
	FROM 
		likes l 
		JOIN profiles p
			ON l.target_id = p.user_id
		JOIN users u
			ON l.target_id = u.id
GROUP BY l.target_id
ORDER BY "Возраст"
LIMIT 10;

-- Вывод:
-- Jillian Volkman	11	4
-- Paul Bradtke	47	3
-- Devyn Lowe	27	3
-- Jamir Olson	26	4
-- Myriam Tremblay	29	5
-- Cindy Murray	46	2
-- Susana Hyatt	19	2
-- Jaden Bogisich	45	2
-- Alexis Okuneva	21	1
-- Karl Reilly	49	5



-- 2. Определить кто больше поставил лайков (всего) - мужчины или женщины?

-- старое решение с вложенным запросом
SELECT 
(SELECT gender FROM profiles p2 WHERE p2.user_id = l.user_id) gender, 
COUNT(user_id) like_count
FROM likes l
GROUP BY gender
ORDER BY like_count DESC
LIMIT 1;
-- ответ - мужчины (109 лайков)

-- новое решение с JOIN:
SELECT 
	p.gender "Пол",
	COUNT(l.user_id) "Поставленные лайки"
FROM
	likes l 
	JOIN profiles p
	ON l.user_id = p.user_id
GROUP BY p.gender
ORDER BY p.gender
LIMIT 1;
-- Вывод: - мужчины (109 лайков)



-- 3. Найти 10 пользователей, которые проявляют наименьшую активность в использовании социальной сети (критерии активности необходимо определить самостоятельно).
-- Активность буду замерять количеством лайков и постов.

-- старое решение с вложенным запросом (неисправленное):
SELECT 
	name, SUM(activity_count) activity
FROM
(
(SELECT (SELECT CONCAT(first_name, ' ', last_name) FROM users u WHERE u.id = l.user_id) name, COUNT(*) activity_count FROM likes l GROUP BY name) 
UNION
(SELECT (SELECT CONCAT(first_name, ' ', last_name) FROM users u WHERE u.id = p.user_id) name, COUNT(*) activity_count FROM posts p GROUP BY name)
) activities
GROUP BY name
ORDER BY activity LIMIT 10;

-- Вывод:
-- Donnell Zieme	1
-- Roberto Rogahn	1
-- Haley Parker	1
-- Jose Schiller	1
-- Winona Keebler	1
-- Giovani Mayer	1
-- Sabrina Wyman	1
-- Dortha Greenholt	1
-- Rhoda Mante	1
-- Alexis Okuneva	1

-- Комментарии преподавателя: при таком подходе из отчёта выпадут пользователи с нулевой активностью.
-- Исправленная версия с вложенным запросом, но внутри SELECT, а не FROM:
SELECT 
	CONCAT(first_name, ' ', last_name) Name,
	((SELECT COUNT(*) FROM likes l WHERE l.user_id = u.id) + (SELECT COUNT(*) FROM posts p WHERE p.user_id = u.id)) Activity
FROM users u
ORDER BY Activity
LIMIT 10;

-- Вывод:
-- Angelica Klein	0
-- Jillian Volkman	0
-- Ahmad Stark	0
-- Anibal Quitzon	0
-- Felicita Wolf	0
-- Clarissa VonRueden	0
-- Susana Hyatt	1
-- Haley Parker	1
-- Shaina O'Keefe	1
-- Dortha Greenholt	1

-- новое решение с JOIN:
SELECT 
	CONCAT(u.first_name, ' ', u.last_name) Name,
	COUNT(l.user_id) + COUNT(p.user_id) Activity
FROM users u
	LEFT JOIN likes l
		ON l.user_id = u.id
	LEFT JOIN posts p
		ON p.user_id = u.id
GROUP BY Name
ORDER BY Activity
LIMIT 10;

-- Вывод:
-- Angelica Klein	0
-- Jillian Volkman	0
-- Ahmad Stark	0
-- Anibal Quitzon	0
-- Felicita Wolf	0
-- Clarissa VonRueden	0
-- Susana Hyatt	1
-- Haley Parker	1
-- Shaina O'Keefe	1
-- Dortha Greenholt	1

-- Вывод отличается, но пользователи, не проявляющие активности полностью совпали. Значит дело в особенностях сортировки повторяющихся 1.
