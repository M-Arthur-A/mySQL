-- ЛАЙКИ

-- user_id - кто лайкнул
-- user_liked_id - чей контент лайкнули
-- media_id - понравившийся контент

CREATE TABLE likes (
  user_id INT UNSIGNED NOT NULL,
  media_id INT UNSIGNED NOT NULL,
  user_liked_id INT UNSIGNED NOT NULL,
  liked_at datetime DEFAULT CURRENT_TIMESTAMP,
);

-- ПОСТЫ

CREATE TABLE blogs (
  user_id INT UNSIGNED NOT NULL,
  letter_id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  title VARCHAR(255),
  body TEXT,
  created_at datetime DEFAULT CURRENT_TIMESTAMP,
  updated_at datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);


