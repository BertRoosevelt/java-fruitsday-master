package com.fruitDayDB.vo;

/**
 * 收藏对象
 * 代表用户收藏的一件商品（独立于购物车）
 */
public class Favorite {
    private int id;           // 收藏ID
    private int userId;       // 用户ID
    private int fruitId;      // 商品ID
    private String createdAt; // 收藏时间

    public Favorite() {
        super();
    }

    public Favorite(int userId, int fruitId) {
        this.userId = userId;
        this.fruitId = fruitId;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public int getFruitId() { return fruitId; }
    public void setFruitId(int fruitId) { this.fruitId = fruitId; }

    public String getCreatedAt() { return createdAt; }
    public void setCreatedAt(String createdAt) { this.createdAt = createdAt; }

    @Override
    public String toString() {
        return "Favorite{" +
                "id=" + id +
                ", userId=" + userId +
                ", fruitId=" + fruitId +
                ", createdAt='" + createdAt + '\'' +
                '}';
    }
}
