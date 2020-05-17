USE vk;
-- Задание 1
ALTER TABLE users MODIFY COLUMN status_id INT UNSIGNED;
ALTER TABLE users 
  ADD CONSTRAINT users_status_id_fk
  FOREIGN KEY (status_id) REFERENCES user_statuses(id)
    ON DELETE SET NULL;

ALTER TABLE communities_users MODIFY COLUMN community_id INT UNSIGNED;
ALTER TABLE communities_users DROP PRIMARY KEY; 
UPDATE communities_users SET community_id = FLOOR(1 + RAND() * 25);

ALTER TABLE communities_users 
	ADD CONSTRAINT communities_users_user_id_fk
	FOREIGN KEY (user_id) REFERENCES users(id),
	ADD CONSTRAINT communities_users_community_id_fk
	FOREIGN KEY (community_id) REFERENCES communities(id);

ALTER TABLE friendship 
	ADD CONSTRAINT friendship_user_id_fk
	FOREIGN KEY (user_id) REFERENCES users(id),
	ADD CONSTRAINT friendship_friend_id_fk
	FOREIGN KEY (friend_id) REFERENCES users(id),
	ADD CONSTRAINT friendship_status_id_fk
	FOREIGN KEY (status_id) REFERENCES friendship_statuses(id);


ALTER TABLE profiles MODIFY COLUMN photo_id INT(10) UNSIGNED;
ALTER TABLE profiles
  ADD CONSTRAINT profiles_user_id_fk 
    FOREIGN KEY (user_id) REFERENCES users(id)
      ON DELETE CASCADE,
  ADD CONSTRAINT profiles_photo_id_fk
    FOREIGN KEY (photo_id) REFERENCES media(id)
      ON DELETE SET NULL;

ALTER TABLE media
  ADD CONSTRAINT media_user_id_fk 
    FOREIGN KEY (user_id) REFERENCES users(id),
  ADD CONSTRAINT media_media_type_id_fk
    FOREIGN KEY (media_type_id) REFERENCES media_types(id);

ALTER TABLE messages 
  ADD CONSTRAINT messages_from_user_id_fk 
    FOREIGN KEY (from_user_id) REFERENCES users(id),
  ADD CONSTRAINT messages_to_user_id_fk
    FOREIGN KEY (to_user_id) REFERENCES users(id);

UPDATE posts SET user_id = FLOOR((1 + RAND()*99));
UPDATE posts SET media_id = 25 WHERE media_id = 0;
UPDATE posts SET community_id = 15 WHERE community_id = 0;
ALTER TABLE posts 
  ADD CONSTRAINT posts_user_id_fk 
    FOREIGN KEY (user_id) REFERENCES users(id),
  ADD CONSTRAINT posts_community_id_fk
	FOREIGN KEY (community_id) REFERENCES communities(id),
  ADD CONSTRAINT posts_media_id_fk
 	FOREIGN KEY (media_id) REFERENCES media(id);

ALTER TABLE likes
  ADD CONSTRAINT likes_user_id_fk 
    FOREIGN KEY (user_id) REFERENCES users(id),
  ADD CONSTRAINT likes_target_type_id_fk
    FOREIGN KEY (target_type_id) REFERENCES target_types(id);