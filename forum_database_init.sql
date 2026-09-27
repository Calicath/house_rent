-- 论坛系统数据库扩展脚本
-- 在现有的房屋租赁系统基础上添加论坛功能

USE `house_rental_db`;

-- 删除现有论坛相关表（如果存在）
DROP TABLE IF EXISTS `forum_comments`;
DROP TABLE IF EXISTS `forum_posts`;

-- 1. 创建论坛帖子表 (forum_posts)
-- 存储论坛帖子信息
CREATE TABLE `forum_posts` (
    `post_id` INT AUTO_INCREMENT PRIMARY KEY COMMENT '帖子ID',
    `user_id` INT NOT NULL COMMENT '发帖用户ID',
    `title` VARCHAR(255) NOT NULL COMMENT '帖子标题',
    `content` TEXT NOT NULL COMMENT '帖子内容',
    `category` VARCHAR(50) DEFAULT 'GENERAL' COMMENT '帖子分类 (GENERAL, RENTAL_TIPS, COMPLAINT, QUESTION, EXPERIENCE)',
    `status` VARCHAR(50) DEFAULT 'ACTIVE' COMMENT '帖子状态 (ACTIVE, HIDDEN, DELETED)',
    `view_count` INT DEFAULT 0 COMMENT '浏览次数',
    `like_count` INT DEFAULT 0 COMMENT '点赞次数',
    `reply_count` INT DEFAULT 0 COMMENT '回复次数',
    `is_pinned` BOOLEAN DEFAULT FALSE COMMENT '是否置顶',
    `is_highlighted` BOOLEAN DEFAULT FALSE COMMENT '是否高亮',
    `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `updated_at` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    FOREIGN KEY (`user_id`) REFERENCES `users`(`user_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='论坛帖子表';

-- 2. 创建论坛评论表 (forum_comments)
-- 存储帖子评论信息
CREATE TABLE `forum_comments` (
    `comment_id` INT AUTO_INCREMENT PRIMARY KEY COMMENT '评论ID',
    `post_id` INT NOT NULL COMMENT '关联的帖子ID',
    `user_id` INT NOT NULL COMMENT '评论用户ID',
    `parent_id` INT DEFAULT NULL COMMENT '父评论ID (用于回复功能)',
    `content` TEXT NOT NULL COMMENT '评论内容',
    `status` VARCHAR(50) DEFAULT 'ACTIVE' COMMENT '评论状态 (ACTIVE, HIDDEN, DELETED)',
    `like_count` INT DEFAULT 0 COMMENT '点赞次数',
    `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `updated_at` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    FOREIGN KEY (`post_id`) REFERENCES `forum_posts`(`post_id`) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (`user_id`) REFERENCES `users`(`user_id`) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (`parent_id`) REFERENCES `forum_comments`(`comment_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='论坛评论表';

-- 创建索引以提高查询性能
CREATE INDEX idx_forum_posts_user ON forum_posts(user_id);
CREATE INDEX idx_forum_posts_category ON forum_posts(category);
CREATE INDEX idx_forum_posts_status ON forum_posts(status);
CREATE INDEX idx_forum_posts_created ON forum_posts(created_at);
CREATE INDEX idx_forum_posts_pinned ON forum_posts(is_pinned);
CREATE INDEX idx_forum_comments_post ON forum_comments(post_id);
CREATE INDEX idx_forum_comments_user ON forum_comments(user_id);
CREATE INDEX idx_forum_comments_parent ON forum_comments(parent_id);
CREATE INDEX idx_forum_comments_created ON forum_comments(created_at);

-- 插入一些示例数据
INSERT INTO forum_posts (user_id, title, content, category) VALUES 
(1, '欢迎来到房屋租赁论坛！', '这里是房东和租客交流的平台，大家可以分享经验、提问、讨论各种租赁相关话题。', 'GENERAL'),
(1, '新手房东必读：如何管理出租房', '作为新手房东，需要注意以下几点：\n1. 制定合理的租金标准\n2. 选择可靠的租客\n3. 定期维护房屋\n4. 及时处理租客问题', 'RENTAL_TIPS'),
(1, '租客维权指南', '租客在遇到问题时应该如何维护自己的权益：\n1. 保留所有书面证据\n2. 了解相关法律法规\n3. 寻求法律援助\n4. 通过正规渠道投诉', 'RENTAL_TIPS');

-- 插入示例评论
INSERT INTO forum_comments (post_id, user_id, content) VALUES 
(1, 1, '这个论坛很有用，希望能帮助到大家！'),
(2, 1, '作为房东，我觉得最重要的是要诚信经营。'),
(3, 1, '租客也要遵守合同约定，双方都要互相理解。'); 