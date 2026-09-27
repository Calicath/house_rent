-- 测试管理员登录功能
-- 请先连接到你的数据库，然后执行此脚本

USE house_rental_db;

-- 1. 检查root管理员是否存在
SELECT '检查root管理员账号:' as info;
SELECT user_id, username, email, type, status FROM users WHERE username = 'root';

-- 2. 检查所有管理员账号
SELECT '所有管理员账号:' as info;
SELECT user_id, username, email, type, status FROM users WHERE type = 'ADMIN';

-- 3. 检查用户总数统计
SELECT '用户统计:' as info;
SELECT 
    COUNT(*) as total_users,
    SUM(CASE WHEN type = 'ADMIN' THEN 1 ELSE 0 END) as admin_count,
    SUM(CASE WHEN type = 'OWNER' THEN 1 ELSE 0 END) as owner_count,
    SUM(CASE WHEN type = 'TENANT' THEN 1 ELSE 0 END) as tenant_count
FROM users;

-- 4. 检查房屋统计
SELECT '房屋统计:' as info;
SELECT COUNT(*) as total_houses FROM houses;

-- 5. 检查交易统计
SELECT '交易统计:' as info;
SELECT 
    COUNT(*) as total_transactions,
    SUM(CASE WHEN status = 'ACTIVE' THEN 1 ELSE 0 END) as active_transactions,
    SUM(CASE WHEN status = 'PENDING' THEN 1 ELSE 0 END) as pending_transactions,
    SUM(CASE WHEN status = 'COMPLETED' THEN 1 ELSE 0 END) as completed_transactions
FROM transactions; 