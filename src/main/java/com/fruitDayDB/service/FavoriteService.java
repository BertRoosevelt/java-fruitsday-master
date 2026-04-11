package com.fruitDayDB.service;

import com.fruitDayDB.dao.FavoriteDao;
import com.fruitDayDB.dao.FavoriteDaoImpl;
import com.fruitDayDB.vo.Favorite;
import java.util.List;

/**
 * 收藏业务逻辑服务
 * 使用独立的 favorites 表管理收藏，与购物车完全分离
 */
public class FavoriteService {

    /**
     * 添加收藏
     * @param userId 用户ID
     * @param fruitId 商品ID
     * @return 成功返回true，失败返回false
     */
    public static boolean addToFavorites(int userId, int fruitId) {
        FavoriteDao favoriteDao = new FavoriteDaoImpl();
        // 检查是否已经收藏，防止重复
        Favorite existing = favoriteDao.findByUserIdAndFruitId(userId, fruitId);
        if (existing != null) {
            return true; // 已经收藏过了，直接返回成功
        }
        Favorite favorite = new Favorite(userId, fruitId);
        int result = favoriteDao.add(favorite);
        return result > 0;
    }

    /**
     * 取消收藏
     * @param userId 用户ID
     * @param fruitId 商品ID
     * @return 成功返回true，失败返回false
     */
    public static boolean removeFromFavorites(int userId, int fruitId) {
        FavoriteDao favoriteDao = new FavoriteDaoImpl();
        int result = favoriteDao.delete(userId, fruitId);
        return result > 0;
    }

    /**
     * 检查商品是否已被用户收藏
     * @param userId 用户ID
     * @param fruitId 商品ID
     * @return 已收藏返回true，否则返回false
     */
    public static boolean isFavorite(int userId, int fruitId) {
        FavoriteDao favoriteDao = new FavoriteDaoImpl();
        return favoriteDao.findByUserIdAndFruitId(userId, fruitId) != null;
    }

    /**
     * 获取用户的收藏列表
     * @param userId 用户ID
     * @return 收藏列表
     */
    public static List<Favorite> getFavorites(int userId) {
        FavoriteDao favoriteDao = new FavoriteDaoImpl();
        return favoriteDao.findByUserId(userId);
    }
}