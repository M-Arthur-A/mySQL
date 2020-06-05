USE vk;
-- (1.) Проанализировать какие запросы могут выполняться наиболее часто в процессе работы приложения и добавить необходимые индексы.
-- 			по profiles будут самые частые разбивки: возрастные, гендерные, по дате создания, по городу и по стране. 
-- 			Все остальное интересующее в основном и так цифры, либо первичные ключи (которые и так индексы по своей сути)
CREATE INDEX profiles_birthday_idx ON profiles(birthday);
CREATE INDEX profiles_gender_idx ON profiles(gender);
CREATE INDEX profiles_created_at_idx ON profiles(created_at);
CREATE INDEX profiles_city_idx ON profiles(city);
CREATE INDEX profiles_country_idx ON profiles(country);



-- (2.) Задание на оконные функции
-- Построить запрос, который будет выводить следующие столбцы:
-- - имя группы
-- - среднее количество пользователей в группах
-- - самый молодой пользователь в группе
-- - самый старший пользователь в группе
-- - общее количество пользователей в группе
-- - всего пользователей в системе
-- - отношение в процентах (общее количество пользователей в группе / всего пользователей в системе) * 100

-- Хотел сделать как удобнее, но это вообще не работает. Толи из-за представлений, толи я где-то ошибаюсь
CREATE OR REPLACE VIEW groups_view AS 
SELECT 
	c.name Group_name,
	CONCAT(u.first_name, ' ', u.last_name) User_name,
	p.birthday User_birth
FROM users u 
	JOIN profiles p 
		ON u.id = p.user_id 
	JOIN communities_users cu 
		ON u.id = cu.user_id 
	JOIN communities c 
		ON cu.community_id = c.id;

SELECT * FROM groups_view; -- не работает
SELECT 
	DISTINCT Group_name,
	(SELECT COUNT(*) / COUNT(DISTINCT Group_name) FROM groups_view) Group_average_users, --  AVG(COUNT(*) OVER w) - не работает
	LAST_VALUE(User_name) OVER w AS Youngest,
	FIRST_VALUE(User_name) OVER w AS Oldest,
	COUNT(User_name) OVER w AS Group_user_count 
FROM groups_view gv
WINDOW w AS (PARTITION BY Group_name ORDER BY User_birth);

-- Решил делать в лоб, сработало, но хотелось бы разобраться, почему не работало предыдущее
SELECT 
	DISTINCT communities.name AS Group_name,
	(SELECT COUNT(DISTINCT users.id) / COUNT(DISTINCT community_id) FROM (communities_users JOIN communities ON communities_users.community_id = communities.id JOIN profiles ON communities_users.user_id = profiles.user_id JOIN users ON communities_users.user_id = users.id ))*100 Group_average_users,
	FIRST_VALUE(CONCAT(users.first_name, ' ', users.last_name)) OVER (PARTITION BY communities_users.community_id ORDER BY profiles.birthday) AS 'Самый старший',
	FIRST_VALUE(CONCAT(users.first_name, ' ', users.last_name)) OVER (PARTITION BY communities_users.community_id ORDER BY profiles.birthday desc) AS 'Самый молодой',
	COUNT(communities_users.user_id) OVER (PARTITION BY communities_users.community_id ORDER BY communities.name) AS 'Пользователей в группе',
	(SELECT COUNT(users.id) from users) AS 'Всего пользователей системы',
	COUNT(communities_users.user_id) OVER (PARTITION BY communities_users.community_id ORDER BY communities.name) / (SELECT COUNT(*) FROM communities) * 100 AS 'Соотношение'
FROM (communities_users
	JOIN communities ON communities_users.community_id = communities.id
	JOIN profiles ON communities_users.user_id = profiles.user_id
	JOIN users ON communities_users.user_id = users.id );


-- вывод - сделал через экспорт резульата в буфер-обмена:
|Group_name                                                                                          |Group_average_users          |Самый старший                                                                                       |Самый молодой                                                                                       |Пользователей в группе|Всего пользователей системы|Соотношение                  |
|----------------------------------------------------------------------------------------------------|-----------------------------|----------------------------------------------------------------------------------------------------|----------------------------------------------------------------------------------------------------|----------------------|---------------------------|-----------------------------|
|Rowe-Rogahn                                                                                         |36.0000                      |Grover Welch                                                                                        |Taryn Welch                                                                                         |9                     |100                        |36.0000                      |
|Bernhard, Simonis and Smitham                                                                       |36.0000                      |Francisca Veum                                                                                      |Taryn Welch                                                                                         |7                     |100                        |28.0000                      |
|Anderson, Beier and Watsica                                                                         |36.0000                      |Francisca Veum                                                                                      |Taryn Welch                                                                                         |5                     |100                        |20.0000                      |
|Schaefer LLC                                                                                        |36.0000                      |Francisca Veum                                                                                      |Taryn Welch                                                                                         |8                     |100                        |32.0000                      |
|Koch LLC                                                                                            |36.0000                      |Ansel Torphy                                                                                        |Taryn Welch                                                                                         |8                     |100                        |32.0000                      |
|Kirlin-O'Hara                                                                                       |36.0000                      |Ansel Torphy                                                                                        |Darius Rosenbaum                                                                                    |7                     |100                        |28.0000                      |
|Vandervort, Gerhold and Murray                                                                      |36.0000                      |Ansel Torphy                                                                                        |Tyreek Schinner                                                                                     |7                     |100                        |28.0000                      |
|Ruecker LLC                                                                                         |36.0000                      |Ansel Torphy                                                                                        |Taryn Welch                                                                                         |8                     |100                        |32.0000                      |
|Kohler-Quitzon                                                                                      |36.0000                      |Francisca Veum                                                                                      |Taryn Welch                                                                                         |8                     |100                        |32.0000                      |
|Schulist Ltd                                                                                        |36.0000                      |Francisca Veum                                                                                      |Taryn Welch                                                                                         |9                     |100                        |36.0000                      |
|Larson Group                                                                                        |36.0000                      |Francisca Veum                                                                                      |Yolanda Reinger                                                                                     |4                     |100                        |16.0000                      |
|Zemlak-Predovic                                                                                     |36.0000                      |Ansel Torphy                                                                                        |Taryn Welch                                                                                         |4                     |100                        |16.0000                      |
|Brekke and Sons                                                                                     |36.0000                      |Francisca Veum                                                                                      |Darius Rosenbaum                                                                                    |9                     |100                        |36.0000                      |
|Crist-Ernser                                                                                        |36.0000                      |Grover Welch                                                                                        |Taryn Welch                                                                                         |4                     |100                        |16.0000                      |
|Kub and Sons                                                                                        |36.0000                      |Francisca Veum                                                                                      |Taryn Welch                                                                                         |6                     |100                        |24.0000                      |
|Lemke-Schoen                                                                                        |36.0000                      |Francisca Veum                                                                                      |Tyreek Schinner                                                                                     |8                     |100                        |32.0000                      |
|Gottlieb-Greenholt                                                                                  |36.0000                      |Francisca Veum                                                                                      |Taryn Welch                                                                                         |8                     |100                        |32.0000                      |
|Ullrich Inc                                                                                         |36.0000                      |Grover Welch                                                                                        |Jessy Raynor                                                                                        |4                     |100                        |16.0000                      |
|Wilderman, Quitzon and Upton                                                                        |36.0000                      |Francisca Veum                                                                                      |Jessy Raynor                                                                                        |8                     |100                        |32.0000                      |
|Block, Kerluke and Gusikowski                                                                       |36.0000                      |Francisca Veum                                                                                      |Taryn Welch                                                                                         |13                    |100                        |52.0000                      |
|Quigley-Sipes                                                                                       |36.0000                      |Ansel Torphy                                                                                        |Tyreek Schinner                                                                                     |7                     |100                        |28.0000                      |
|Lindgren Ltd                                                                                        |36.0000                      |Ansel Torphy                                                                                        |Jessy Raynor                                                                                        |7                     |100                        |28.0000                      |
|Roob, Roob and Schimmel                                                                             |36.0000                      |Francisca Veum                                                                                      |Tyreek Schinner                                                                                     |5                     |100                        |20.0000                      |
|Fahey-Gerhold                                                                                       |36.0000                      |Ansel Torphy                                                                                        |Jessy Raynor                                                                                        |10                    |100                        |40.0000                      |
|Kshlerin LLC                                                                                        |36.0000                      |Francisca Veum                                                                                      |Taryn Welch                                                                                         |10                    |100                        |40.0000                      |

