USE vk;
-- 3. Подсчитать общее количество лайков десяти самым молодым пользователям (сколько лайков получили 10 самых молодых пользователей).
SELECT * FROM profiles;
SELECT * FROM likes;

SELECT -- не сработало
	(SELECT CONCAT(first_name, ' ', last_name) FROM users u WHERE u.id = l.user_id) name,
	MAX(SELECT TIMESTAMPDIFF(YEAR, birthday, NOW()) FROM profiles p WHERE p.user_id = l.user_id) age,
	COUNT(user_id)
FROM likes l GROUP BY name;


SELECT -- работает
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


-- 4. Определить кто больше поставил лайков (всего) - мужчины или женщины?
SELECT 
(SELECT gender FROM profiles p2 WHERE p2.user_id = l.user_id) gender, 
COUNT(user_id) like_count
FROM likes l
GROUP BY gender
ORDER BY like_count DESC
LIMIT 1;
-- ответ - мужчины (109 лайков)

-- 5. Найти 10 пользователей, которые проявляют наименьшую активность в использовании социальной сети (критерии активности необходимо определить самостоятельно).
-- Активность будет замеряться количеством лайков и постов.
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
