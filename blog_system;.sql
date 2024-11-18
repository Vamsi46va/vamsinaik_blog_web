-- Create the database
CREATE DATABASE IF NOT EXISTS blog_system;
USE blog_system;

-- Drop existing tables if they exist (in correct order due to foreign key constraints)
DROP TABLE IF EXISTS blog_comments;
DROP TABLE IF EXISTS blog_likes;
DROP TABLE IF EXISTS blog_posts;
DROP TABLE IF EXISTS users;

-- Create users table
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL,
    password VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Create blog posts table
CREATE TABLE blog_posts (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    content TEXT NOT NULL,
    author VARCHAR(50) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (author) REFERENCES users(username) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Create blog likes table
CREATE TABLE blog_likes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    post_id INT NOT NULL,
    user_ip VARCHAR(45) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY unique_like (post_id, user_ip),
    FOREIGN KEY (post_id) REFERENCES blog_posts(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Create blog comments table
CREATE TABLE blog_comments (
    id INT AUTO_INCREMENT PRIMARY KEY,
    post_id INT NOT NULL,
    author VARCHAR(50) NOT NULL,
    content TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (post_id) REFERENCES blog_posts(id) ON DELETE CASCADE,
    FOREIGN KEY (author) REFERENCES users(username) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Create indexes for better performance
CREATE INDEX idx_blog_posts_author ON blog_posts(author);
CREATE INDEX idx_blog_posts_created_at ON blog_posts(created_at);
CREATE INDEX idx_blog_comments_post_id ON blog_comments(post_id);
CREATE INDEX idx_blog_likes_post_id ON blog_likes(post_id);

-- Optional: Insert some sample data
INSERT INTO users (username, email, password) VALUES
('admin', 'admin@example.com', 'admin123'),
('john_doe', 'john@example.com', 'password123'),
('jane_smith', 'jane@example.com', 'password456');

INSERT INTO blog_posts (title, content, author) VALUES
('Welcome to Our Blog', 'This is our first blog post. Welcome everyone!', 'admin'),
('Getting Started with MySQL', 'MySQL is a popular open-source database...', 'john_doe'),
('Web Development Tips', 'Here are some essential web development tips...', 'jane_smith');

INSERT INTO blog_comments (post_id, author, content) VALUES
(1, 'john_doe', 'Great first post!'),
(1, 'jane_smith', 'Looking forward to more content!'),
(2, 'admin', 'Very informative article about MySQL.');

INSERT INTO blog_likes (post_id, user_ip) VALUES
(1, '192.168.1.1'),
(1, '192.168.1.2'),
(2, '192.168.1.1');

-- Create a view for post statistics
CREATE OR REPLACE VIEW post_statistics AS
SELECT 
    p.id AS post_id,
    p.title,
    p.author,
    p.created_at,
    COUNT(DISTINCT l.id) AS like_count,
    COUNT(DISTINCT c.id) AS comment_count
FROM blog_posts p
LEFT JOIN blog_likes l ON p.id = l.post_id
LEFT JOIN blog_comments c ON p.id = c.post_id
GROUP BY p.id, p.title, p.author, p.created_at;

-- Create a stored procedure to get post details
DELIMITER //
CREATE PROCEDURE get_post_details(IN post_id_param INT)
BEGIN
    -- Get post information
    SELECT p.*, 
           COUNT(DISTINCT l.id) as likes_count,
           COUNT(DISTINCT c.id) as comments_count
    FROM blog_posts p
    LEFT JOIN blog_likes l ON p.id = l.post_id
    LEFT JOIN blog_comments c ON p.id = c.post_id
    WHERE p.id = post_id_param
    GROUP BY p.id;
    
    -- Get comments for the post
    SELECT c.*, u.email
    FROM blog_comments c
    JOIN users u ON c.author = u.username
    WHERE c.post_id = post_id_param
    ORDER BY c.created_at DESC;
END //
DELIMITER ;

-- Create triggers for logging changes
CREATE TABLE activity_log (
    id INT AUTO_INCREMENT PRIMARY KEY,
    action_type VARCHAR(50) NOT NULL,
    table_name VARCHAR(50) NOT NULL,
    record_id INT NOT NULL,
    user_name VARCHAR(50),
    action_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

DELIMITER //
CREATE TRIGGER after_post_insert
AFTER INSERT ON blog_posts
FOR EACH ROW
BEGIN
    INSERT INTO activity_log (action_type, table_name, record_id, user_name)
    VALUES ('INSERT', 'blog_posts', NEW.id, NEW.author);
END //

CREATE TRIGGER after_post_delete
AFTER DELETE ON blog_posts
FOR EACH ROW
BEGIN
    INSERT INTO activity_log (action_type, table_name, record_id, user_name)
    VALUES ('DELETE', 'blog_posts', OLD.id, OLD.author);
END //
DELIMITER ;

-- Create a function to get user's post count
DELIMITER //
CREATE FUNCTION get_user_post_count(username_param VARCHAR(50))
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE post_count INT;
    SELECT COUNT(*) INTO post_count
    FROM blog_posts
    WHERE author = username_param;
    RETURN post_count;
END //
DELIMITER ;
