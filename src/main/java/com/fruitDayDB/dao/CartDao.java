package com.fruitDayDB.dao;

import com.fruitDayDB.vo.Cart;
import java.util.List;

/**
 * 购物车数据访问接口
 * 定义购物车相关的数据库操作方法
 */
public interface CartDao {

    /**
     * 获取用户购物车中的所有商品
     * @param userId 用户ID
     * @return 购物车项列表
     */
    List<Cart> findByUserId(int userId);

    /**
     * 根据用户ID和商品ID查询购物车项
     * @param userId 用户ID
     * @param fruitId 商品ID
     * @return 购物车项，如果不存在返回null
     */
    Cart findByUserIdAndFruitId(int userId, int fruitId);

    /**
     * 根据用户ID、商品ID和收藏状态查询购物车项
     * @param userId 用户ID
     * @param fruitId 商品ID
     * @param isFavorite 是否为收藏
     * @return 购物车项，如果不存在返回null
     */
    Cart findByUserIdAndFruitIdAndIsFavorite(int userId, int fruitId, boolean isFavorite);

    /**
     * 添加商品到购物车
     * @param cart 购物车项
     * @return 受影响的行数
     */
    int add(Cart cart);

    /**
     * 更新购物车项（修改数量或收藏状态）
     * @param cart 购物车项
     * @return 受影响的行数
     */
    int update(Cart cart);

    /**
     * 删除购物车项
     * @param userId 用户ID
     * @param fruitId 商品ID
     * @return 受影响的行数
     */
    int delete(int userId, int fruitId);

    /**
     * 根据收藏状态删除购物车项
     * @param userId 用户ID
     * @param fruitId 商品ID
     * @param isFavorite 是否为收藏
     * @return 受影响的行数
     */
    int deleteByUserIdFruitIdAndIsFavorite(int userId, int fruitId, boolean isFavorite);

    /**
     * 清空用户的整个购物车
     * @param userId 用户ID
     * @return 受影响的行数
     */
    int clearCart(int userId);

    /**
     * 获取用户购物车中的商品数量（不包括收藏）
     * @param userId 用户ID
     * @return 商品总数
     */
    int getCartCount(int userId);

    /**
     * 获取用户的收藏列表
     * @param userId 用户ID
     * @return 收藏商品列表
     */
    List<Cart> getFavorites(int userId);
}