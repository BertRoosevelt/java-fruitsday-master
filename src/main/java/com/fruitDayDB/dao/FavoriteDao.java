package com.fruitDayDB.dao;

import com.fruitDayDB.vo.Favorite;
import java.util.List;

/**
 * 收藏数据访问接口
 * 定义收藏相关的数据库操作方法（独立于购物车）
 */
public interface FavoriteDao {

    /**
     * 根据用户ID和商品ID查询收藏
     * @param userId 用户ID
     * @param fruitId 商品ID
     * @return 收藏项，如果不存在返回null
     */
    Favorite findByUserIdAndFruitId(int userId, int fruitId);

    /**
     * 获取用户的所有收藏
     * @param userId 用户ID
     * @return 收藏列表
     */
    List<Favorite> findByUserId(int userId);

    /**
     * 添加收藏
     * @param favorite 收藏对象
     * @return 受影响的行数
     */
    int add(Favorite favorite);

    /**
     * 删除收藏
     * @param userId 用户ID
     * @param fruitId 商品ID
     * @return 受影响的行数
     */
    int delete(int userId, int fruitId);
}
