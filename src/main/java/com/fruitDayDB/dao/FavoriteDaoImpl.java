package com.fruitDayDB.dao;

import com.fruitDayDB.db.DBUtils;
import com.fruitDayDB.vo.Favorite;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 * 收藏数据访问实现类
 * 操作独立的 favorites 表，与购物车完全分离
 */
public class FavoriteDaoImpl implements FavoriteDao {

    /**
     * 根据用户ID和商品ID查询收藏
     */
    @Override
    public Favorite findByUserIdAndFruitId(int userId, int fruitId) {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        Favorite favorite = null;

        String sql = "SELECT id, user_id, fruit_id, created_at FROM favorites WHERE user_id = ? AND fruit_id = ?";

        try {
            conn = DBUtils.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);
            ps.setInt(2, fruitId);
            rs = ps.executeQuery();

            if (rs.next()) {
                favorite = new Favorite();
                favorite.setId(rs.getInt("id"));
                favorite.setUserId(rs.getInt("user_id"));
                favorite.setFruitId(rs.getInt("fruit_id"));
                favorite.setCreatedAt(rs.getString("created_at"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtils.close(rs, ps, conn);
        }

        return favorite;
    }

    /**
     * 获取用户的所有收藏
     */
    @Override
    public List<Favorite> findByUserId(int userId) {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        List<Favorite> favorites = new ArrayList<>();

        String sql = "SELECT id, user_id, fruit_id, created_at FROM favorites WHERE user_id = ? ORDER BY created_at DESC";

        try {
            conn = DBUtils.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);
            rs = ps.executeQuery();

            while (rs.next()) {
                Favorite favorite = new Favorite();
                favorite.setId(rs.getInt("id"));
                favorite.setUserId(rs.getInt("user_id"));
                favorite.setFruitId(rs.getInt("fruit_id"));
                favorite.setCreatedAt(rs.getString("created_at"));
                favorites.add(favorite);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtils.close(rs, ps, conn);
        }

        return favorites;
    }

    /**
     * 添加收藏
     */
    @Override
    public int add(Favorite favorite) {
        Connection conn = null;
        PreparedStatement ps = null;
        int result = 0;

        String sql = "INSERT IGNORE INTO favorites (user_id, fruit_id) VALUES (?, ?)";

        try {
            conn = DBUtils.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, favorite.getUserId());
            ps.setInt(2, favorite.getFruitId());
            result = ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtils.close(null, ps, conn);
        }

        return result;
    }

    /**
     * 删除收藏
     */
    @Override
    public int delete(int userId, int fruitId) {
        Connection conn = null;
        PreparedStatement ps = null;
        int result = 0;

        String sql = "DELETE FROM favorites WHERE user_id = ? AND fruit_id = ?";

        try {
            conn = DBUtils.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);
            ps.setInt(2, fruitId);
            result = ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtils.close(null, ps, conn);
        }

        return result;
    }
}
