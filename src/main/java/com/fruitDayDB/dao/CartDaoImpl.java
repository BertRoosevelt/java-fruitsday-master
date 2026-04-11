package com.fruitDayDB.dao;

import com.fruitDayDB.db.DBUtils;
import com.fruitDayDB.vo.Cart;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 * 购物车数据访问实现类
 * 处理购物车相关的数据库操作（收藏功能已迁移到 FavoriteDaoImpl）
 */
public class CartDaoImpl implements CartDao {

    /**
     * 获取用户购物车中的所有商品
     */
    @Override
    public List<Cart> findByUserId(int userId) {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        List<Cart> carts = new ArrayList<>();

        String sql = "SELECT id, user_id, fruit_id, quantity, created_at FROM cart WHERE user_id = ?";

        try {
            conn = DBUtils.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);
            rs = ps.executeQuery();

            while (rs.next()) {
                Cart cart = new Cart();
                cart.setId(rs.getInt("id"));
                cart.setUserId(rs.getInt("user_id"));
                cart.setFruitId(rs.getInt("fruit_id"));
                cart.setQuantity(rs.getInt("quantity"));
                cart.setCreatedAt(rs.getString("created_at"));
                carts.add(cart);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtils.close(rs, ps, conn);
        }

        return carts;
    }

    /**
     * 根据用户ID和商品ID查询购物车项
     */
    @Override
    public Cart findByUserIdAndFruitId(int userId, int fruitId) {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        Cart cart = null;

        String sql = "SELECT id, user_id, fruit_id, quantity, created_at FROM cart WHERE user_id = ? AND fruit_id = ?";

        try {
            conn = DBUtils.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);
            ps.setInt(2, fruitId);
            rs = ps.executeQuery();

            if (rs.next()) {
                cart = new Cart();
                cart.setId(rs.getInt("id"));
                cart.setUserId(rs.getInt("user_id"));
                cart.setFruitId(rs.getInt("fruit_id"));
                cart.setQuantity(rs.getInt("quantity"));
                cart.setCreatedAt(rs.getString("created_at"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtils.close(rs, ps, conn);
        }

        return cart;
    }

    /**
     * 添加商品到购物车
     * 如果该商品已在购物车中，则增加数量；否则创建新记录
     */
    @Override
    public int add(Cart cart) {
        Connection conn = null;
        PreparedStatement ps = null;
        int result = 0;

        Cart existing = findByUserIdAndFruitId(cart.getUserId(), cart.getFruitId());

        if (existing != null) {
            String sql = "UPDATE cart SET quantity = quantity + ? WHERE user_id = ? AND fruit_id = ?";
            try {
                conn = DBUtils.getConnection();
                ps = conn.prepareStatement(sql);
                ps.setInt(1, cart.getQuantity());
                ps.setInt(2, cart.getUserId());
                ps.setInt(3, cart.getFruitId());
                result = ps.executeUpdate();
            } catch (SQLException e) {
                e.printStackTrace();
            } finally {
                DBUtils.close(null, ps, conn);
            }
        } else {
            String sql = "INSERT INTO cart (user_id, fruit_id, quantity) VALUES (?, ?, ?)";
            try {
                conn = DBUtils.getConnection();
                ps = conn.prepareStatement(sql);
                ps.setInt(1, cart.getUserId());
                ps.setInt(2, cart.getFruitId());
                ps.setInt(3, cart.getQuantity());
                result = ps.executeUpdate();
            } catch (SQLException e) {
                e.printStackTrace();
            } finally {
                DBUtils.close(null, ps, conn);
            }
        }

        return result;
    }

    /**
     * 更新购物车项（修改数量）
     */
    @Override
    public int update(Cart cart) {
        Connection conn = null;
        PreparedStatement ps = null;
        int result = 0;

        String sql = "UPDATE cart SET quantity = ? WHERE user_id = ? AND fruit_id = ?";

        try {
            conn = DBUtils.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, cart.getQuantity());
            ps.setInt(2, cart.getUserId());
            ps.setInt(3, cart.getFruitId());
            result = ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtils.close(null, ps, conn);
        }

        return result;
    }

    /**
     * 删除购物车项
     */
    @Override
    public int delete(int userId, int fruitId) {
        Connection conn = null;
        PreparedStatement ps = null;
        int result = 0;

        String sql = "DELETE FROM cart WHERE user_id = ? AND fruit_id = ?";

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

    /**
     * 清空用户的购物车
     */
    @Override
    public int clearCart(int userId) {
        Connection conn = null;
        PreparedStatement ps = null;
        int result = 0;

        String sql = "DELETE FROM cart WHERE user_id = ?";

        try {
            conn = DBUtils.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);
            result = ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtils.close(null, ps, conn);
        }

        return result;
    }

    /**
     * 获取用户购物车中的商品总数量
     */
    @Override
    public int getCartCount(int userId) {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        int count = 0;

        String sql = "SELECT SUM(quantity) as total FROM cart WHERE user_id = ?";

        try {
            conn = DBUtils.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);
            rs = ps.executeQuery();

            if (rs.next()) {
                count = rs.getInt("total");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtils.close(rs, ps, conn);
        }

        return count;
    }
}
