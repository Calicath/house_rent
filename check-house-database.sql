-- 房屋数据库检查脚本
-- 请先连接到你的数据库，然后运行以下命令

-- 1. 检查数据库是否存在
SELECT DATABASE() as current_database;

-- 2. 检查houses表是否存在
SHOW TABLES LIKE 'houses';

-- 3. 检查houses表结构
DESCRIBE houses;

-- 4. 检查houses表是否有数据
SELECT COUNT(*) as total_houses FROM houses;

-- 5. 查看最新的房屋数据
SELECT * FROM houses ORDER BY house_id DESC LIMIT 5;

-- 6. 检查owners表结构
DESCRIBE owners;

-- 7. 检查owners表数据
SELECT COUNT(*) as total_owners FROM owners;

-- 8. 查看最新的房主数据
SELECT * FROM owners ORDER BY owner_id DESC LIMIT 5;

-- 9. 检查users表结构
DESCRIBE users;

-- 10. 检查用户数据
SELECT user_id, username, type, reference_id FROM users WHERE type = 'OWNER' ORDER BY user_id DESC LIMIT 5;

-- 11. 检查外键关系
SELECT 
    h.house_id,
    h.title,
    h.owner_id,
    o.owner_id as owner_table_id,
    u.user_id,
    u.username,
    u.reference_id
FROM houses h
LEFT JOIN owners o ON h.owner_id = o.owner_id
LEFT JOIN users u ON o.user_id = u.user_id
ORDER BY h.house_id DESC
LIMIT 10;

-- 12. 检查是否有孤立的房屋记录（没有对应房主的房屋）
SELECT h.* FROM houses h 
LEFT JOIN owners o ON h.owner_id = o.owner_id 
WHERE o.owner_id IS NULL;

-- 13. 检查是否有孤立的房主记录（没有对应用户的房主）
SELECT o.* FROM owners o 
LEFT JOIN users u ON o.user_id = u.user_id 
WHERE u.user_id IS NULL; 