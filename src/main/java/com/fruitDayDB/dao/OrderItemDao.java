package com.fruitDayDB.dao;

import com.fruitDayDB.vo.OrderItem;
import java.util.List;

/**
 * 订单项数据访问接口
 * 定义订单项相关的数据库操作方法
 */
public interface OrderItemDao {

    /**
     * 添加订单项
     * @param orderItem 订单项
     * @return 受影响的行数
     */
    int add(OrderItem orderItem);

    /**
     * 根据订单ID获取所有订单项
     * @param orderId 订单ID
     * @return 订单项列表
     */
    List<OrderItem> findByOrderId(int orderId);

    /**
     * 批量添加订单项
     * @param orderItems 订单项列表
     * @return 受影响的行数
     */
    int batchAdd(List<OrderItem> orderItems);
}