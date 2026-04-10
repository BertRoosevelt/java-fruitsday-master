package com.fruitDayDB.vo;

/**
 * 购物车对象
 * 代表用户购物车中的一项商品
 */
public class Cart {
    private int id;              // 购物车项ID
    private int userId;          // 用户ID
    private int fruitId;         // 商品ID
    private int quantity;        // 购买数量 ✅ 新增！
    private boolean isFavorite;  // 是否收藏 (重命名)
    private String createdAt;    // 创建时间

    public Cart() {
        super();
    }

    public Cart(int fruitId, int quantity, boolean isFavorite) {
        this.fruitId = fruitId;
        this.quantity = quantity;
        this.isFavorite = isFavorite;
    }

    // 所有 getter 和 setter
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public int getFruitId() { return fruitId; }
    public void setFruitId(int fruitId) { this.fruitId = fruitId; }

    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }

    public boolean isFavorite() { return isFavorite; }
    public void setIsFavorite(boolean isFavorite) { this.isFavorite = isFavorite; }

    public String getCreatedAt() { return createdAt; }
    public void setCreatedAt(String createdAt) { this.createdAt = createdAt; }

    @Override
    public String toString() {
        return "Cart{" +
                "id=" + id +
                ", userId=" + userId +
                ", fruitId=" + fruitId +
                ", quantity=" + quantity +
                ", isFavorite=" + isFavorite +
                ", createdAt='" + createdAt + '\'' +
                '}';
    }
}