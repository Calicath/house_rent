-- 论坛数据库检查脚本
-- 检查论坛相关表是否存在，如果不存在则创建

USE `house_rental_db`;

-- 检查论坛帖子表是否存在
SELECT 
    CASE 
        WHEN COUNT(*) > 0 THEN 'forum_posts 表已存在'
        ELSE 'forum_posts 表不存在，需要创建'
    END AS status
FROM information_schema.tables 
WHERE table_schema = 'house_rental_db' AND table_name = 'forum_posts';

-- 检查论坛评论表是否存在
SELECT 
    CASE 
        WHEN COUNT(*) > 0 THEN 'forum_comments 表已存在'
        ELSE 'forum_comments 表不存在，需要创建'
    END AS status
FROM information_schema.tables 
WHERE table_schema = 'house_rental_db' AND table_name = 'forum_comments';

-- 如果表不存在，创建表
-- 创建论坛帖子表
CREATE TABLE IF NOT EXISTS `forum_posts` (
    `post_id` INT AUTO_INCREMENT PRIMARY KEY COMMENT '帖子ID',
    `user_id` INT NOT NULL COMMENT '发帖用户ID',
    `title` VARCHAR(255) NOT NULL COMMENT '帖子标题',
    `content` TEXT NOT NULL COMMENT '帖子内容',
    `category` VARCHAR(50) DEFAULT 'GENERAL' COMMENT '帖子分类',
    `status` VARCHAR(50) DEFAULT 'ACTIVE' COMMENT '帖子状态',
    `view_count` INT DEFAULT 0 COMMENT '浏览次数',
    `like_count` INT DEFAULT 0 COMMENT '点赞次数',
    `reply_count` INT DEFAULT 0 COMMENT '回复次数',
    `is_pinned` BOOLEAN DEFAULT FALSE COMMENT '是否置顶',
    `is_highlighted` BOOLEAN DEFAULT FALSE COMMENT '是否高亮',
    `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `updated_at` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    FOREIGN KEY (`user_id`) REFERENCES `users`(`user_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='论坛帖子表';

-- 创建论坛评论表
CREATE TABLE IF NOT EXISTS `forum_comments` (
    `comment_id` INT AUTO_INCREMENT PRIMARY KEY COMMENT '评论ID',
    `post_id` INT NOT NULL COMMENT '关联的帖子ID',
    `user_id` INT NOT NULL COMMENT '评论用户ID',
    `parent_id` INT DEFAULT NULL COMMENT '父评论ID',
    `content` TEXT NOT NULL COMMENT '评论内容',
    `status` VARCHAR(50) DEFAULT 'ACTIVE' COMMENT '评论状态',
    `like_count` INT DEFAULT 0 COMMENT '点赞次数',
    `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `updated_at` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    FOREIGN KEY (`post_id`) REFERENCES `forum_posts`(`post_id`) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (`user_id`) REFERENCES `users`(`user_id`) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (`parent_id`) REFERENCES `forum_comments`(`comment_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='论坛评论表';

-- 创建索引
CREATE INDEX IF NOT EXISTS idx_forum_posts_user ON forum_posts(user_id);
CREATE INDEX IF NOT EXISTS idx_forum_posts_category ON forum_posts(category);
CREATE INDEX IF NOT EXISTS idx_forum_posts_status ON forum_posts(status);
CREATE INDEX IF NOT EXISTS idx_forum_posts_created ON forum_posts(created_at);
CREATE INDEX IF NOT EXISTS idx_forum_posts_pinned ON forum_posts(is_pinned);
CREATE INDEX IF NOT EXISTS idx_forum_comments_post ON forum_comments(post_id);
CREATE INDEX IF NOT EXISTS idx_forum_comments_user ON forum_comments(user_id);
CREATE INDEX IF NOT EXISTS idx_forum_comments_parent ON forum_comments(parent_id);
CREATE INDEX IF NOT EXISTS idx_forum_comments_created ON forum_comments(created_at);

-- 检查现有数据
SELECT 'forum_posts 表数据统计:' AS info;
SELECT COUNT(*) AS total_posts FROM forum_posts;

SELECT 'forum_comments 表数据统计:' AS info;
SELECT COUNT(*) AS total_comments FROM forum_comments;

-- 显示最新的帖子
SELECT '最新帖子列表:' AS info;
SELECT 
    post_id,
    title,
    category,
    created_at,
    view_count
FROM forum_posts 
ORDER BY created_at DESC 
LIMIT 5; 