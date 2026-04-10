package com.fruitDayDB.vo;

/**
 * 订单项对象
 * 代表订单中的一件商品
 */
public class OrderItem {
    private int id;           // 订单项ID
    private int orderId;      // 订单ID
    private int fruitId;      // 商品ID
    private String fruitName; // 商品名称
    private double price;     // 购买时的单价
    private int quantity;     // 购买数量
    private double subtotal;  // 小计金额

    public OrderItem() {
        super();
    }

    public OrderItem(int orderId, int fruitId, String fruitName, double price, int quantity) {
        this.orderId = orderId;
        this.fruitId = fruitId;
        this.fruitName = fruitName;
        this.price = price;
        this.quantity = quantity;
        this.subtotal = price * quantity;
    }

    // Getter 和 Setter
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getOrderId() { return orderId; }
    public void setOrderId(int orderId) { this.orderId = orderId; }

    public int getFruitId() { return fruitId; }
    public void setFruitId(int fruitId) { this.fruitId = fruitId; }

    public String getFruitName() { return fruitName; }
    public void setFruitName(String fruitName) { this.fruitName = fruitName; }

    public double getPrice() { return price; }
    public void setPrice(double price) { this.price = price; }

    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }

    public double getSubtotal() { return subtotal; }
    public void setSubtotal(double subtotal) { this.subtotal = subtotal; }

    @Override
    public String toString() {
        return "OrderItem{" +
                "id=" + id +
                ", orderId=" + orderId +
                ", fruitId=" + fruitId +
                ", fruitName='" + fruitName + '\'' +
                ", price=" + price +
                ", quantity=" + quantity +
                ", subtotal=" + subtotal +
                '}';
    }
}