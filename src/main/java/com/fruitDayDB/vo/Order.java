package com.fruitDayDB.vo;

import java.util.List;

/**
 * 订单对象
 * 代表用户的一个订单
 */
public class Order {
    private int id;              // 订单ID
    private int userId;          // 用户ID
    private String orderNumber;  // 订单号（唯一，用于展示给用户）
    private double totalPrice;   // 订单总金额
    private String status;       // 订单状态
    private String createdAt;    // 创建时间
    private String paidAt;       // 支付时间
    private String shippedAt;    // 发货时间
    private String completedAt;  // 完成时间
    private String remark;       // 备注
    private List<OrderItem> items; // 订单项（关联关系）

    public Order() {
        super();
    }

    public Order(int userId, String orderNumber, double totalPrice, String status) {
        this.userId = userId;
        this.orderNumber = orderNumber;
        this.totalPrice = totalPrice;
        this.status = status;
    }

    // Getter 和 Setter
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getOrderNumber() { return orderNumber; }
    public void setOrderNumber(String orderNumber) { this.orderNumber = orderNumber; }

    public double getTotalPrice() { return totalPrice; }
    public void setTotalPrice(double totalPrice) { this.totalPrice = totalPrice; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getCreatedAt() { return createdAt; }
    public void setCreatedAt(String createdAt) { this.createdAt = createdAt; }

    public String getPaidAt() { return paidAt; }
    public void setPaidAt(String paidAt) { this.paidAt = paidAt; }

    public String getShippedAt() { return shippedAt; }
    public void setShippedAt(String shippedAt) { this.shippedAt = shippedAt; }

    public String getCompletedAt() { return completedAt; }
    public void setCompletedAt(String completedAt) { this.completedAt = completedAt; }

    public String getRemark() { return remark; }
    public void setRemark(String remark) { this.remark = remark; }

    public List<OrderItem> getItems() { return items; }
    public void setItems(List<OrderItem> items) { this.items = items; }

    @Override
    public String toString() {
        return "Order{" +
                "id=" + id +
                ", userId=" + userId +
                ", orderNumber='" + orderNumber + '\'' +
                ", totalPrice=" + totalPrice +
                ", status='" + status + '\'' +
                ", createdAt='" + createdAt + '\'' +
                '}';
    }
}