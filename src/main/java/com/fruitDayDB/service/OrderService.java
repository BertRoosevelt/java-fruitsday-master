package com.fruitDayDB.service;

import com.fruitDayDB.dao.OrderDao;
import com.fruitDayDB.dao.OrderDaoImpl;
import com.fruitDayDB.dao.OrderItemDao;
import com.fruitDayDB.dao.OrderItemDaoImpl;
import com.fruitDayDB.dao.CartDao;
import com.fruitDayDB.dao.CartDaoImpl;
import com.fruitDayDB.vo.Order;
import com.fruitDayDB.vo.OrderItem;
import com.fruitDayDB.vo.Cart;
import com.fruitDayDB.vo.Fruit;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

/**
 * 订单业务逻辑服务
 * 处理订单相关的业务操作
 */
public class OrderService {

    /**
     * 从购物车创建订单
     * @param userId 用户ID
     * @return 创建成功返回订单号，失败返回null
     */
    public static String createOrderFromCart(int userId) {
        CartDao cartDao = new CartDaoImpl();
        OrderDao orderDao = new OrderDaoImpl();
        OrderItemDao orderItemDao = new OrderItemDaoImpl();

        // 获取购物车中的所有商品
        List<Cart> cartItems = cartDao.findByUserId(userId);
        List<Cart> itemsToOrder = new ArrayList<>();
        double totalPrice = 0;

        // 筛选出购物车中的商品（非收藏）
        for (Cart item : cartItems) {
            if (!item.isFavorite()) {
                itemsToOrder.add(item);
                // 计算总价
                Fruit fruit = FruitService.info(item.getFruitId());
                if (fruit != null) {
                    totalPrice += fruit.getUp() * item.getQuantity();
                }
            }
        }

        // 如果购物车为空，返回null
        if (itemsToOrder.isEmpty()) {
            return null;
        }

        // 生成订单号（时间戳 + 用户ID）
        String orderNumber = generateOrderNumber(userId);

        // 创建订单
        Order order = new Order();
        order.setUserId(userId);
        order.setOrderNumber(orderNumber);
        order.setTotalPrice(totalPrice);
        order.setStatus("pending");  // 待支付

        int orderId = orderDao.createOrder(order);

        if (orderId > 0) {
            // 创建订单项
            for (Cart cartItem : itemsToOrder) {
                Fruit fruit = FruitService.info(cartItem.getFruitId());
                if (fruit != null) {
                    OrderItem orderItem = new OrderItem();
                    orderItem.setOrderId(orderId);
                    orderItem.setFruitId(cartItem.getFruitId());
                    orderItem.setFruitName(fruit.getFname());
                    orderItem.setPrice(fruit.getUp());
                    orderItem.setQuantity(cartItem.getQuantity());
                    orderItem.setSubtotal(fruit.getUp() * cartItem.getQuantity());

                    orderItemDao.add(orderItem);
                }
            }

            // 清空购物车（删除已下单的商品）
            cartDao.clearCart(userId);

            return orderNumber;
        }

        return null;
    }

    /**
     * 获取用户的所有订单
     * @param userId 用户ID
     * @return 订单列表
     */
    public static List<Order> getUserOrders(int userId) {
        OrderDao orderDao = new OrderDaoImpl();
        return orderDao.findByUserId(userId);
    }

    /**
     * 获取订单详情（包括订单项）
     * @param orderId 订单ID
     * @return 订单对象（包含订单项列表）
     */
    public static Order getOrderDetail(int orderId) {
        OrderDao orderDao = new OrderDaoImpl();
        OrderItemDao orderItemDao = new OrderItemDaoImpl();

        Order order = orderDao.findById(orderId);
        if (order != null) {
            // 获取订单项
            List<OrderItem> items = orderItemDao.findByOrderId(orderId);
            order.setItems(items);
        }

        return order;
    }

    /**
     * 获取用户指定状态的订单
     * @param userId 用户ID
     * @param status 订单状态 (pending, paid, shipped, completed, cancelled)
     * @return 订单列表
     */
    public static List<Order> getUserOrdersByStatus(int userId, String status) {
        OrderDao orderDao = new OrderDaoImpl();
        return orderDao.findByUserIdAndStatus(userId, status);
    }

    /**
     * 支付订单（模拟支付）
     * @param orderId 订单ID
     * @return 成功返回true，失败返回false
     */
    public static boolean payOrder(int orderId) {
        OrderDao orderDao = new OrderDaoImpl();
        // 将订单状态改为已支付
        int result = orderDao.updateStatus(orderId, "paid");
        return result > 0;
    }

    /**
     * 发货订单（管理员操作）
     * @param orderId 订单ID
     * @return 成功返回true，失败返回false
     */
    public static boolean shipOrder(int orderId) {
        OrderDao orderDao = new OrderDaoImpl();
        // 将订单状态改为已发货
        int result = orderDao.updateStatus(orderId, "shipped");
        return result > 0;
    }

    /**
     * 完成订单（确认收货）
     * @param orderId 订单ID
     * @return 成功返回true，失败返回false
     */
    public static boolean completeOrder(int orderId) {
        OrderDao orderDao = new OrderDaoImpl();
        // 将订单状态改为已完成
        int result = orderDao.updateStatus(orderId, "completed");
        return result > 0;
    }

    /**
     * 取消订单
     * @param orderId 订单ID
     * @return 成功返回true，失败返回false
     */
    public static boolean cancelOrder(int orderId) {
        OrderDao orderDao = new OrderDaoImpl();
        // 将订单状态改为已取消
        int result = orderDao.updateStatus(orderId, "cancelled");
        return result > 0;
    }

    /**
     * 根据订单号查询订单
     * @param orderNumber 订单号
     * @return 订单对象
     */
    public static Order getOrderByNumber(String orderNumber) {
        OrderDao orderDao = new OrderDaoImpl();
        Order order = orderDao.findByOrderNumber(orderNumber);
        if (order != null) {
            // 获取订单项
            OrderItemDao orderItemDao = new OrderItemDaoImpl();
            List<OrderItem> items = orderItemDao.findByOrderId(order.getId());
            order.setItems(items);
        }
        return order;
    }

    /**
     * 获取订单的状态说明
     * @param status 订单状态码
     * @return 状态说明
     */
    public static String getStatusDisplay(String status) {
        switch (status) {
            case "pending":
                return "待支付";
            case "paid":
                return "已支付";
            case "shipped":
                return "已发货";
            case "completed":
                return "已完成";
            case "cancelled":
                return "已取消";
            default:
                return "未知状态";
        }
    }

    /**
     * 生成订单号
     * 格式: ORD + 时间戳 + 用户ID
     * 例: ORD202604101234567890123456789012
     */
    private static String generateOrderNumber(int userId) {
        long timestamp = System.currentTimeMillis();
        return "ORD" + timestamp + userId;
    }

    /**
     * 获取待支付的订单数量
     * @param userId 用户ID
     * @return 待支付订单数
     */
    public static int getPendingOrderCount(int userId) {
        List<Order> pendingOrders = getUserOrdersByStatus(userId, "pending");
        return pendingOrders.size();
    }

    /**
     * 获取所有订单（管理员）
     */
    public static List<Order> getAllOrders() {
        OrderDao orderDao = new OrderDaoImpl();
        return orderDao.findAll();
    }

    /**
     * 获取所有指定状态的订单（管理员）
     */
    public static List<Order> getAllOrdersByStatus(String status) {
        OrderDao orderDao = new OrderDaoImpl();
        return orderDao.findAllByStatus(status);
    }

    /**
     * 获取待发货的订单数量（管理员用）
     * @return 所有待发货订单数
     */
    public static int getPendingShipmentCount() {
        // 注意：这个方法需要 DAO 层支持不指定 userId 的查询
        // 目前简单实现，实际应该在 DAO 中添加相应方法
        return 0;
    }
}