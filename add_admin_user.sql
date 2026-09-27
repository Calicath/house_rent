-- 添加root管理员账号
-- 请先连接到你的数据库，然后执行此脚本

USE house_rental_db;

-- 插入root管理员用户
INSERT INTO users (username, password, email, type, status) 
VALUES ('root', '123', 'root@example.com', 'ADMIN', 'ACTIVE')
ON DUPLICATE KEY UPDATE 
    password = VALUES(password),
    email = VALUES(email),
    type = VALUES(type),
    status = VALUES(status);

-- 验证插入结果
SELECT * FROM users WHERE username = 'root'; 