/*
日期: 2026-04-10
*/

SET FOREIGN_KEY_CHECKS=0;

-- ========================================
-- 1. 用户表 (保持不变)
-- ========================================
DROP TABLE IF EXISTS `user`;
CREATE TABLE `user` (
                        `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '用户ID',
                        `email` varchar(255) NOT NULL UNIQUE COMMENT '邮箱（唯一）',
                        `phone` varchar(20) COMMENT '手机号',
                        `pwd` varchar(255) NOT NULL COMMENT '密码',
                        `uname` varchar(100) COMMENT '用户昵称',
                        `created_at` timestamp DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
                        PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COMMENT='用户表';

INSERT INTO `user` VALUES
                       (1, 'youwillsee2018@qq.com', '15754326763', 'suhong1', 'youwillsee2018@qq.com', NOW()),
                       (2, 'test@qq.com', '15812345678', '123456', 'testuser', NOW());

-- ========================================
-- 2. 管理员用户表 (权限标记)
-- ========================================
DROP TABLE IF EXISTS `admin`;
CREATE TABLE `admin` (
                         `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '管理员ID',
                         `user_id` int(11) NOT NULL COMMENT '对应用户ID',
                         `role` varchar(50) DEFAULT 'admin' COMMENT '角色: admin=管理员',
                         `created_at` timestamp DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
                         PRIMARY KEY (`id`),
                         FOREIGN KEY (`user_id`) REFERENCES `user`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COMMENT='管理员表';

INSERT INTO `admin` VALUES (1, 1, 'admin', NOW());

-- ========================================
-- 3. 商品表 (保持结构，加注释)
-- ========================================
DROP TABLE IF EXISTS `fruits`;
CREATE TABLE `fruits` (
                          `fid` int(11) NOT NULL AUTO_INCREMENT COMMENT '商品ID',
                          `fname` varchar(255) NOT NULL COMMENT '商品名称',
                          `spec` varchar(100) COMMENT '规格/单位',
                          `up` decimal(10,2) NOT NULL COMMENT '价格',
                          `t1` text COMMENT '产地信息',
                          `t2` text COMMENT '储藏信息',
                          `inum` int(11) DEFAULT 100 COMMENT '库存数量',
                          `created_at` timestamp DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
                          `updated_at` timestamp DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
                          PRIMARY KEY (`fid`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COMMENT='商品表';

INSERT INTO `fruits` VALUES
                         (1, '佳沛新西兰绿奇异果', '4+2盒', 78.00, '产地 新西兰 销售规格 6个', '储藏方法 0-4度冷藏', 100, NOW(), NOW()),
                         (3, '枣', '2斤', 23.00, '产地国内', '储藏方法 0-4度冷藏', 50, NOW(), NOW()),
                         (4, '菠萝', '1个', 59.00, '产地国产', '储藏方法 0-4度冷藏', 80, NOW(), NOW()),
                         (8, '南非青提', '2斤', 68.00, '产地南非', '储藏方法 0-4度冷藏', 60, NOW(), NOW()),
                         (9, '里达葡萄', '2斤', 98.00, '产地进口', '储藏方法 0-4度冷藏', 40, NOW(), NOW()),
                         (10, '墨西哥牛油果', '6个', 40.00, '产地墨西哥', '储藏方法 0-4度冷藏', 70, NOW(), NOW()),
                         (11, '美国华盛顿红地厘蛇果', '6个', 30.00, '产地美国', '储藏方法 0-4度冷藏', 90, NOW(), NOW()),
                         (14, '美国佛罗里达葡萄柚', '6个', 40.00, '产地美国', '储藏方法 0-4度冷藏', 55, NOW(), NOW()),
                         (16, '赣南红心脐橙', '2斤/4斤', 49.00, '产地国产', '储藏方法 0-4度冷藏', 75, NOW(), NOW()),
                         (20, '紫薯', '500g', 11.00, '产地中国', '储藏方法 阴凉干燥', 200, NOW(), NOW());

-- ========================================
-- 4. 热卖商品表 (新设计，更清晰)
-- ========================================
DROP TABLE IF EXISTS `hot_fruits`;
CREATE TABLE `hot_fruits` (
                              `id` int(11) NOT NULL AUTO_INCREMENT,
                              `fruit_id` int(11) NOT NULL COMMENT '商品ID',
                              `is_hot` tinyint(1) DEFAULT 1 COMMENT '是否热卖',
                              `created_at` timestamp DEFAULT CURRENT_TIMESTAMP,
                              PRIMARY KEY (`id`),
                              UNIQUE KEY `fruit_id` (`fruit_id`),
                              FOREIGN KEY (`fruit_id`) REFERENCES `fruits`(`fid`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COMMENT='热卖商品表';

INSERT INTO `hot_fruits` (fruit_id, is_hot) VALUES
                                                (1, 1), (3, 1), (4, 1), (8, 1), (9, 1), (10, 1), (11, 1), (14, 1), (16, 1), (20, 1);

-- ========================================
-- 5. 购物车表 (新设计！用一张表替代shop{id})
-- ========================================
DROP TABLE IF EXISTS `cart`;
CREATE TABLE `cart` (
                        `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '购物车项ID',
                        `user_id` int(11) NOT NULL COMMENT '用户ID',
                        `fruit_id` int(11) NOT NULL COMMENT '商品ID',
                        `quantity` int(11) DEFAULT 1 COMMENT '购买数量',
                        `is_favorite` tinyint(1) DEFAULT 0 COMMENT '是否收藏',
                        `created_at` timestamp DEFAULT CURRENT_TIMESTAMP COMMENT '加入时间',
                        `updated_at` timestamp DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
                        PRIMARY KEY (`id`),
                        UNIQUE KEY `user_fruit` (`user_id`, `fruit_id`),
                        FOREIGN KEY (`user_id`) REFERENCES `user`(`id`) ON DELETE CASCADE,
                        FOREIGN KEY (`fruit_id`) REFERENCES `fruits`(`fid`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COMMENT='统一购物车表（替代原来的shop{id}）';

-- 初始数据（用户1的购物车）
INSERT INTO `cart` VALUES
                       (1, 1, 1, 2, 1, NOW(), NOW()),
                       (2, 1, 11, 1, 1, NOW(), NOW()),
                       (3, 1, 14, 3, 0, NOW(), NOW());

-- ========================================
-- 6. 订单表 (新增！实现订单功能)
-- ========================================
DROP TABLE IF EXISTS `orders`;
CREATE TABLE `orders` (
                          `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '订单ID',
                          `user_id` int(11) NOT NULL COMMENT '用户ID',
                          `order_number` varchar(50) NOT NULL UNIQUE COMMENT '订单号',
                          `total_price` decimal(10,2) NOT NULL COMMENT '订单总金额',
                          `status` varchar(20) DEFAULT 'pending' COMMENT '订单状态: pending(待支付),paid(已支付),shipped(已发货),completed(已完成),cancelled(已取消)',
                          `created_at` timestamp DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
                          `paid_at` timestamp NULL COMMENT '支付时间',
                          `shipped_at` timestamp NULL COMMENT '发货时间',
                          `completed_at` timestamp NULL COMMENT '完成时间',
                          `remark` text COMMENT '备注',
                          PRIMARY KEY (`id`),
                          FOREIGN KEY (`user_id`) REFERENCES `user`(`id`) ON DELETE CASCADE,
                          INDEX `user_id_idx` (`user_id`),
                          INDEX `status_idx` (`status`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COMMENT='订单表';

-- ========================================
-- 7. 订单项表 (新增！记录订单中的商品)
-- ========================================
DROP TABLE IF EXISTS `order_items`;
CREATE TABLE `order_items` (
                               `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '订单项ID',
                               `order_id` int(11) NOT NULL COMMENT '订单ID',
                               `fruit_id` int(11) NOT NULL COMMENT '商品ID',
                               `fruit_name` varchar(255) NOT NULL COMMENT '商品名称（冗余存储，防止删除后无法查看）',
                               `price` decimal(10,2) NOT NULL COMMENT '购买时的单价',
                               `quantity` int(11) NOT NULL COMMENT '购买数量',
                               `subtotal` decimal(10,2) NOT NULL COMMENT '小计金额',
                               `created_at` timestamp DEFAULT CURRENT_TIMESTAMP,
                               PRIMARY KEY (`id`),
                               FOREIGN KEY (`order_id`) REFERENCES `orders`(`id`) ON DELETE CASCADE,
                               FOREIGN KEY (`fruit_id`) REFERENCES `fruits`(`fid`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COMMENT='订单项表';

-- ========================================
-- 8. 删除旧的 shop 表
-- ========================================
DROP TABLE IF EXISTS `shop1`;
DROP TABLE IF EXISTS `shop12`;
DROP TABLE IF EXISTS `root`;

SET FOREIGN_KEY_CHECKS=1;