package com.fruitDayDB.dao;

import com.fruitDayDB.vo.Order;
import java.util.List;

/**
 * 订单数据访问接口
 * 定义订单相关的数据库操作方法
 */
public interface OrderDao {

    /**
     * 创建新订单
     * @param order 订单对象
     * @return 创建成功返回订单ID，失败返回-1
     */
    int createOrder(Order order);

    /**
     * 根据订单ID查询订单
     * @param orderId 订单ID
     * @return 订单对象
     */
    Order findById(int orderId);

    /**
     * 根据用户ID查询所有订单
     * @param userId 用户ID
     * @return 订单列表
     */
    List<Order> findByUserId(int userId);

    /**
     * 根据订单号查询订单
     * @param orderNumber 订单号
     * @return 订单对象
     */
    Order findByOrderNumber(String orderNumber);

    /**
     * 更新订单状态
     * @param orderId 订单ID
     * @param status 新状态
     * @return 受影响的行数
     */
    int updateStatus(int orderId, String status);

    /**
     * 删除订单（逻辑删除）
     * @param orderId 订单ID
     * @return 受影响的行数
     */
    int deleteOrder(int orderId);

    /**
     * 获取用户指定状态的订单
     * @param userId 用户ID
     * @param status 订单状态
     * @return 订单列表
     */
    List<Order> findByUserIdAndStatus(int userId, String status);

    /**
     * 获取所有用户的所有订单（管理员）
     * @return 订单列表
     */
    List<Order> findAll();

    /**
     * 获取所有用户指定状态的订单（管理员）
     * @param status 订单状态
     * @return 订单列表
     */
    List<Order> findAllByStatus(String status);
}