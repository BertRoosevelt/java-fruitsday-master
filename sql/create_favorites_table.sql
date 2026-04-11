-- 创建独立的收藏表（favorites）
-- 与购物车表（cart）完全分离

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
