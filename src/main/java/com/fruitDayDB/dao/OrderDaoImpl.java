package com.fruitDayDB.dao;

import com.fruitDayDB.db.DBUtils;
import com.fruitDayDB.vo.Order;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

/**
 * 订单数据访问实现类
 * 处理所有订单相关的数据库操作
 */
public class OrderDaoImpl implements OrderDao {

    /**
     * 创建新订单
     */
    @Override
    public int createOrder(Order order) {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet generatedKeys = null;
        int orderId = -1;

        // ✅ 修复：正确的 SQL 语句
        String sql = "INSERT INTO orders (user_id, order_number, total_price, status, remark) " +
                "VALUES (?, ?, ?, ?, ?)";

        try {
            conn = DBUtils.getConnection();
            ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setInt(1, order.getUserId());
            ps.setString(2, order.getOrderNumber());
            ps.setDouble(3, order.getTotalPrice());
            ps.setString(4, order.getStatus() != null ? order.getStatus() : "pending");
            ps.setString(5, order.getRemark());

            int affectedRows = ps.executeUpdate();
            if (affectedRows > 0) {
                generatedKeys = ps.getGeneratedKeys();
                if (generatedKeys.next()) {
                    orderId = generatedKeys.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtils.close(generatedKeys, ps, conn);
        }

        return orderId;
    }

    /**
     * 根据订单ID查询订单
     */
    @Override
    public Order findById(int orderId) {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        Order order = null;

        String sql = "SELECT id, user_id, order_number, total_price, status, created_at, " +
                "paid_at, shipped_at, completed_at, remark FROM orders WHERE id = ?";

        try {
            conn = DBUtils.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, orderId);
            rs = ps.executeQuery();

            if (rs.next()) {
                order = mapResultSetToOrder(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtils.close(rs, ps, conn);
        }

        return order;
    }

    /**
     * 根据用户ID查询所有订单
     */
    @Override
    public List<Order> findByUserId(int userId) {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        List<Order> orders = new ArrayList<>();

        String sql = "SELECT id, user_id, order_number, total_price, status, created_at, " +
                "paid_at, shipped_at, completed_at, remark FROM orders " +
                "WHERE user_id = ? ORDER BY created_at DESC";

        try {
            conn = DBUtils.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);
            rs = ps.executeQuery();

            while (rs.next()) {
                orders.add(mapResultSetToOrder(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtils.close(rs, ps, conn);
        }

        return orders;
    }

    /**
     * 根据订单号查询订单
     */
    @Override
    public Order findByOrderNumber(String orderNumber) {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        Order order = null;

        String sql = "SELECT id, user_id, order_number, total_price, status, created_at, " +
                "paid_at, shipped_at, completed_at, remark FROM orders " +
                "WHERE order_number = ?";

        try {
            conn = DBUtils.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, orderNumber);
            rs = ps.executeQuery();

            if (rs.next()) {
                order = mapResultSetToOrder(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtils.close(rs, ps, conn);
        }

        return order;
    }

    /**
     * 更新订单状态
     */
    @Override
    public int updateStatus(int orderId, String status) {
        Connection conn = null;
        PreparedStatement ps = null;
        int result = 0;

        String sql = "UPDATE orders SET status = ? WHERE id = ?";

        try {
            conn = DBUtils.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, status);
            ps.setInt(2, orderId);
            result = ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtils.close(null, ps, conn);
        }

        return result;
    }

    /**
     * 删除订单（实际是标记为已删除）
     */
    @Override
    public int deleteOrder(int orderId) {
        // 学习项目，这里简单处理为直接删除
        Connection conn = null;
        PreparedStatement ps = null;
        int result = 0;

        String sql = "DELETE FROM orders WHERE id = ?";

        try {
            conn = DBUtils.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, orderId);
            result = ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtils.close(null, ps, conn);
        }

        return result;
    }

    /**
     * 获取用户指定状态的订单
     */
    @Override
    public List<Order> findByUserIdAndStatus(int userId, String status) {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        List<Order> orders = new ArrayList<>();

        String sql = "SELECT id, user_id, order_number, total_price, status, created_at, " +
                "paid_at, shipped_at, completed_at, remark FROM orders " +
                "WHERE user_id = ? AND status = ? ORDER BY created_at DESC";

        try {
            conn = DBUtils.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);
            ps.setString(2, status);
            rs = ps.executeQuery();

            while (rs.next()) {
                orders.add(mapResultSetToOrder(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtils.close(rs, ps, conn);
        }

        return orders;
    }

    /**
     * 辅助方法：将ResultSet映射到Order对象
     */
    private Order mapResultSetToOrder(ResultSet rs) throws SQLException {
        Order order = new Order();
        order.setId(rs.getInt("id"));
        order.setUserId(rs.getInt("user_id"));
        order.setOrderNumber(rs.getString("order_number"));
        order.setTotalPrice(rs.getDouble("total_price"));
        order.setStatus(rs.getString("status"));
        order.setCreatedAt(rs.getString("created_at"));
        order.setPaidAt(rs.getString("paid_at"));
        order.setShippedAt(rs.getString("shipped_at"));
        order.setCompletedAt(rs.getString("completed_at"));
        order.setRemark(rs.getString("remark"));
        return order;
    }

    /**
     * 获取所有订单（管理员）
     */
    @Override
    public List<Order> findAll() {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT id, user_id, order_number, total_price, status, created_at, " +
                "paid_at, shipped_at, completed_at, remark FROM orders ORDER BY created_at DESC";
        try {
            conn = DBUtils.getConnection();
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                orders.add(mapResultSetToOrder(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtils.close(rs, ps, conn);
        }
        return orders;
    }

    /**
     * 获取所有指定状态的订单（管理员）
     */
    @Override
    public List<Order> findAllByStatus(String status) {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT id, user_id, order_number, total_price, status, created_at, " +
                "paid_at, shipped_at, completed_at, remark FROM orders " +
                "WHERE status = ? ORDER BY created_at DESC";
        try {
            conn = DBUtils.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, status);
            rs = ps.executeQuery();
            while (rs.next()) {
                orders.add(mapResultSetToOrder(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtils.close(rs, ps, conn);
        }
        return orders;
    }
}