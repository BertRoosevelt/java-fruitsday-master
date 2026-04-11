-- 数据迁移脚本：从 cart 表中分离收藏数据到独立的 favorites 表
-- 执行顺序：先创建 favorites 表（create_favorites_table.sql），再运行此脚本

-- 第1步：确保 favorites 表存在
CREATE TABLE IF NOT EXISTS `favorites` (
    `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '收藏ID',
    `user_id` int(11) NOT NULL COMMENT '用户ID',
    `fruit_id` int(11) NOT NULL COMMENT '商品ID',
    `created_at` timestamp DEFAULT CURRENT_TIMESTAMP COMMENT '收藏时间',
    PRIMARY KEY (`id`),
    UNIQUE KEY `unique_user_fruit` (`user_id`, `fruit_id`),
    FOREIGN KEY (`user_id`) REFERENCES `user`(`id`) ON DELETE CASCADE,
    FOREIGN KEY (`fruit_id`) REFERENCES `fruits`(`fid`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='收藏表（独立）';

-- 第2步：将 cart 表中 is_favorite=1 的数据迁移到 favorites 表
INSERT IGNORE INTO `favorites` (user_id, fruit_id, created_at)
SELECT user_id, fruit_id, created_at FROM `cart`
WHERE is_favorite = 1;

-- 第3步：从 cart 表中删除收藏记录（is_favorite=1）
DELETE FROM `cart` WHERE is_favorite = 1;

-- 第4步：删除 cart 表的 is_favorite 字段
ALTER TABLE `cart` DROP COLUMN `is_favorite`;

-- 第5步：删除旧的 UNIQUE KEY（user_fruit_status），改为 user_fruit
ALTER TABLE `cart` DROP INDEX `user_fruit_status`;
ALTER TABLE `cart` ADD UNIQUE KEY `user_fruit` (`user_id`, `fruit_id`);
