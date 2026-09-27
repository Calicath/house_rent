-- 房屋租赁系统数据库初始化脚本
-- 请先创建数据库：CREATE DATABASE house_rental_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

CREATE DATABASE IF NOT EXISTS `house_rental_db` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
-- 使用你的数据库
USE `house_rental_db`;

-- 删除现有表（如果存在），以便重新创建
DROP TABLE IF EXISTS `payments`;
DROP TABLE IF EXISTS `viewing_records`;
DROP TABLE IF EXISTS `transactions`;
DROP TABLE IF EXISTS `houses`;
DROP TABLE IF EXISTS `tenants`;
DROP TABLE IF EXISTS `owners`;
DROP TABLE IF EXISTS `users`;


-- 1. 创建用户表 (users)
-- 存储所有类型的用户（管理员、房主、租户）的基本信息
CREATE TABLE `users` (
    `user_id` INT AUTO_INCREMENT PRIMARY KEY COMMENT '用户ID',
    `username` VARCHAR(255) NOT NULL UNIQUE COMMENT '用户名',
    `password` VARCHAR(255) NOT NULL COMMENT '密码',
    `email` VARCHAR(255) COMMENT '邮箱',
    `type` VARCHAR(50) NOT NULL COMMENT '用户类型 (ADMIN, OWNER, TENANT)',
    `status` VARCHAR(50) DEFAULT 'ACTIVE' COMMENT '用户状态 (ACTIVE, INACTIVE, SUSPENDED)',
    `reference_id` INT COMMENT '关联的房主或租户ID (如果是房主或租户)',
    `id_card` VARCHAR(255) COMMENT '身份证号',
    `gender` VARCHAR(50) COMMENT '性别',
    `address` VARCHAR(255) COMMENT '地址',
    `phone` VARCHAR(50) COMMENT '电话号码'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='系统用户表';

-- 2. 创建房主表 (owners)
-- 存储房主特定信息，通过 user_id 与用户表关联
CREATE TABLE `owners` (
    `owner_id` INT AUTO_INCREMENT PRIMARY KEY COMMENT '房主ID',
    `user_id` INT NOT NULL UNIQUE COMMENT '关联的用户ID',
    `name` VARCHAR(255) COMMENT '房主姓名',
    `address` VARCHAR(255) COMMENT '房主地址',
    `phone` VARCHAR(50) COMMENT '房主电话',
    FOREIGN KEY (`user_id`) REFERENCES `users`(`user_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='房主信息表';

-- 3. 创建租户表 (tenants)
-- 存储租户特定信息，通过 user_id 与用户表关联
CREATE TABLE `tenants` (
    `tenant_id` INT AUTO_INCREMENT PRIMARY KEY COMMENT '租户ID',
    `user_id` INT NOT NULL UNIQUE COMMENT '关联的用户ID',
    `id_card` VARCHAR(255) COMMENT '身份证号',
    `gender` VARCHAR(50) COMMENT '性别',
    `move_in_date` DATE COMMENT '入住日期',
    `move_out_date` DATE COMMENT '搬出日期',
    `status` VARCHAR(50) DEFAULT 'ACTIVE' COMMENT '租户状态 (ACTIVE, INACTIVE, BLACKLISTED)',
    `emergency_contact` VARCHAR(255) COMMENT '紧急联系人',
    `emergency_phone` VARCHAR(50) COMMENT '紧急联系电话',
    `occupation` VARCHAR(255) COMMENT '职业',
    `employer` VARCHAR(255) COMMENT '雇主',
    `income` VARCHAR(255) COMMENT '收入',
    `credit_score` VARCHAR(255) COMMENT '信用评分',
    `notes` TEXT COMMENT '备注',
    FOREIGN KEY (`user_id`) REFERENCES `users`(`user_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='租户信息表';


-- 4. 创建房屋表 (houses)
-- 存储房屋详细信息
CREATE TABLE `houses` (
    `house_id` INT AUTO_INCREMENT PRIMARY KEY COMMENT '房屋ID',
    `owner_id` INT NOT NULL COMMENT '房主ID',
    `title` VARCHAR(255) NOT NULL COMMENT '房屋标题',
    `description` TEXT COMMENT '房屋描述',
    `address` VARCHAR(255) NOT NULL COMMENT '房屋地址',
    `rent_amount` DECIMAL(10, 2) NOT NULL COMMENT '租金金额',
    `status` VARCHAR(50) DEFAULT 'AVAILABLE' COMMENT '房屋状态 (AVAILABLE, RENTED, PENDING)',
    `type` INT COMMENT '房屋类型 (例如：1-公寓, 2-别墅)',
    `size` INT COMMENT '房屋面积（平方米）',
    `decorate` VARCHAR(255) COMMENT '装修情况',
    `floor` VARCHAR(50) COMMENT '楼层',
    `bedrooms` INT COMMENT '卧室数量',
    `bathrooms` INT COMMENT '卫生间数量',
    `images` TEXT COMMENT '图片URL (逗号分隔)',
    `rules` TEXT COMMENT '租赁规则',
    FOREIGN KEY (`owner_id`) REFERENCES `owners`(`owner_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='房屋信息表';

-- 5. 创建交易表 (transactions)
-- 存储租赁交易记录
CREATE TABLE `transactions` (
    `transaction_id` INT AUTO_INCREMENT PRIMARY KEY COMMENT '交易ID',
    `house_id` INT NOT NULL COMMENT '房屋ID',
    `tenant_id` INT NOT NULL COMMENT '租户ID',
    `owner_id` INT NOT NULL COMMENT '房主ID',
    `start_date` DATE NOT NULL COMMENT '租赁开始日期',
    `end_date` DATE NOT NULL COMMENT '租赁结束日期',
    `rent_amount` DECIMAL(10, 2) NOT NULL COMMENT '实际租金金额',
    `deposit_amount` DECIMAL(10, 2) NOT NULL COMMENT '押金金额',
    `status` VARCHAR(50) DEFAULT 'PENDING' COMMENT '交易状态 (PENDING, APPROVED, REJECTED, COMPLETED)',
    `payment_date` DATETIME COMMENT '支付日期',
    `payment_method` VARCHAR(100) COMMENT '支付方式',
    `payment_status` VARCHAR(50) DEFAULT 'UNPAID' COMMENT '支付状态 (UNPAID, PAID, PARTIAL)',
    `contract_number` VARCHAR(255) UNIQUE COMMENT '合同编号',
    `notes` TEXT COMMENT '备注',
    FOREIGN KEY (`house_id`) REFERENCES `houses`(`house_id`) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (`tenant_id`) REFERENCES `tenants`(`tenant_id`) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (`owner_id`) REFERENCES `owners`(`owner_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='租赁交易表';

-- 6. 创建看房记录表 (viewing_records)
-- 存储租户看房申请记录
CREATE TABLE `viewing_records` (
    `record_id` INT AUTO_INCREMENT PRIMARY KEY COMMENT '看房记录ID',
    `house_id` INT NOT NULL COMMENT '房屋ID',
    `tenant_id` INT NOT NULL COMMENT '租户ID',
    `viewing_time` DATETIME NOT NULL COMMENT '看房时间',
    `status` VARCHAR(50) DEFAULT 'PENDING' COMMENT '看房状态 (PENDING, CONFIRMED, CANCELED)',
    `message` TEXT COMMENT '看房留言',
    FOREIGN KEY (`house_id`) REFERENCES `houses`(`house_id`) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (`tenant_id`) REFERENCES `tenants`(`tenant_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='看房记录表';

-- 7. 创建支付表 (payments)
-- 存储支付记录
CREATE TABLE `payments` (
    `payment_id` INT AUTO_INCREMENT PRIMARY KEY COMMENT '支付ID',
    `transaction_id` INT NOT NULL UNIQUE COMMENT '关联的交易ID',
    `amount` DECIMAL(10, 2) NOT NULL COMMENT '支付金额',
    `payment_date` DATETIME NOT NULL COMMENT '支付日期',
    `method` VARCHAR(100) COMMENT '支付方式',
    `status` VARCHAR(50) DEFAULT 'SUCCESS' COMMENT '支付状态 (SUCCESS, FAILED, PENDING)',
    FOREIGN KEY (`transaction_id`) REFERENCES `transactions`(`transaction_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='支付记录表';

-- 插入默认管理员用户
INSERT INTO users (username, password, email, type, status) 
VALUES ('root', '123', 'root@example.com', 'ADMIN', 'ACTIVE')
ON DUPLICATE KEY UPDATE username=username;

-- 插入备用管理员用户
INSERT INTO users (username, password, email, type, status) 
VALUES ('admin', 'admin123', 'admin@example.com', 'ADMIN', 'ACTIVE')
ON DUPLICATE KEY UPDATE username=username;

-- 创建索引以提高查询性能
CREATE INDEX idx_users_username ON users(username);
CREATE INDEX idx_users_type ON users(type);
CREATE INDEX idx_houses_owner ON houses(owner_id);
CREATE INDEX idx_houses_status ON houses(status);
CREATE INDEX idx_transactions_tenant ON transactions(tenant_id);
CREATE INDEX idx_transactions_owner ON transactions(owner_id); 