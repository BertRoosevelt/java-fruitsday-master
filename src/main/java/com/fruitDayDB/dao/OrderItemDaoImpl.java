package com.fruitDayDB.dao;

import com.fruitDayDB.db.DBUtils;
import com.fruitDayDB.vo.OrderItem;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 * 订单项数据访问实现类
 * 处理所有订单项相关的数据库操作
 */
public class OrderItemDaoImpl implements OrderItemDao {

    /**
     * 添加订单项
     */
    @Override
    public int add(OrderItem orderItem) {
        Connection conn = null;
        PreparedStatement ps = null;
        int result = 0;

        // ✅ 修复：正确的 SQL 语句
        String sql = "INSERT INTO order_items (order_id, fruit_id, fruit_name, price, quantity, subtotal) " +
                "VALUES (?, ?, ?, ?, ?, ?)";

        try {
            conn = DBUtils.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, orderItem.getOrderId());
            ps.setInt(2, orderItem.getFruitId());
            ps.setString(3, orderItem.getFruitName());
            ps.setDouble(4, orderItem.getPrice());
            ps.setInt(5, orderItem.getQuantity());
            ps.setDouble(6, orderItem.getSubtotal());
            result = ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtils.close(null, ps, conn);
        }

        return result;
    }

    /**
     * 根据订单ID获取所有订单项
     */
    @Override
    public List<OrderItem> findByOrderId(int orderId) {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        List<OrderItem> items = new ArrayList<>();

        String sql = "SELECT id, order_id, fruit_id, fruit_name, price, quantity, subtotal FROM order_items WHERE order_id = ?";

        try {
            conn = DBUtils.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, orderId);
            rs = ps.executeQuery();

            while (rs.next()) {
                OrderItem item = new OrderItem();
                item.setId(rs.getInt("id"));
                item.setOrderId(rs.getInt("order_id"));
                item.setFruitId(rs.getInt("fruit_id"));
                item.setFruitName(rs.getString("fruit_name"));
                item.setPrice(rs.getDouble("price"));
                item.setQuantity(rs.getInt("quantity"));
                item.setSubtotal(rs.getDouble("subtotal"));
                items.add(item);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtils.close(rs, ps, conn);
        }

        return items;
    }

    /**
     * 批量添加订单项
     */
    @Override
    public int batchAdd(List<OrderItem> orderItems) {
        int totalResult = 0;
        for (OrderItem item : orderItems) {
            totalResult += add(item);
        }
        return totalResult;
    }
}