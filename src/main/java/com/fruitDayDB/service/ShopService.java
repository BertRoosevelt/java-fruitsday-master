package com.fruitDayDB.service;

import com.fruitDayDB.dao.CartDao;
import com.fruitDayDB.dao.CartDaoImpl;
import com.fruitDayDB.vo.Cart;
import com.fruitDayDB.vo.Fruit;
import java.util.ArrayList;
import java.util.List;

/**
 * 购物车业务逻辑服务
 * 处理购物车相关的业务操作（收藏功能已迁移到 FavoriteService）
 */
public class ShopService {

    /**
     * 获取用户购物车中的所有商品
     * @param userId 用户ID
     * @return 购物车项列表
     */
    public static List<Cart> getCartItems(int userId) {
        CartDao cartDao = new CartDaoImpl();
        return cartDao.findByUserId(userId);
    }

    /**
     * 添加商品到购物车
     * @param userId 用户ID
     * @param fruitId 商品ID
     * @param quantity 购买数量
     * @return 成功返回true，失败返回false
     */
    public static boolean addToCart(int userId, int fruitId, int quantity) {
        CartDao cartDao = new CartDaoImpl();
        Cart cart = new Cart();
        cart.setUserId(userId);
        cart.setFruitId(fruitId);
        cart.setQuantity(quantity);

        int result = cartDao.add(cart);
        return result > 0;
    }

    /**
     * 修改购物车中商品的数量
     * @param userId 用户ID
     * @param fruitId 商品ID
     * @param quantity 新的数量
     * @return 成功返回true，失败返回false
     */
    public static boolean updateCartQuantity(int userId, int fruitId, int quantity) {
        CartDao cartDao = new CartDaoImpl();
        Cart cart = new Cart();
        cart.setUserId(userId);
        cart.setFruitId(fruitId);
        cart.setQuantity(quantity);

        int result = cartDao.update(cart);
        return result > 0;
    }

    /**
     * 从购物车删除商品
     * @param userId 用户ID
     * @param fruitId 商品ID
     * @return 成功返回true，失败返回false
     */
    public static boolean removeFromCart(int userId, int fruitId) {
        CartDao cartDao = new CartDaoImpl();
        int result = cartDao.delete(userId, fruitId);
        return result > 0;
    }

    /**
     * 获取购物车中商品的总数量
     * @param userId 用户ID
     * @return 商品总数量
     */
    public static int getCartCount(int userId) {
        CartDao cartDao = new CartDaoImpl();
        return cartDao.getCartCount(userId);
    }

    /**
     * 清空用户购物车
     * @param userId 用户ID
     * @return 成功返回true，失败返回false
     */
    public static boolean clearCart(int userId) {
        CartDao cartDao = new CartDaoImpl();
        int result = cartDao.clearCart(userId);
        return result > 0;
    }

    /**
     * 查询用户购物车中的指定商品
     * @param userId 用户ID
     * @param fruitId 商品ID
     * @return 购物车项（如果存在）
     */
    public static Cart findInCart(int userId, int fruitId) {
        CartDao cartDao = new CartDaoImpl();
        return cartDao.findByUserIdAndFruitId(userId, fruitId);
    }

    /**
     * 获取购物车中商品的详细信息（包括价格、名称等）
     * @param userId 用户ID
     * @return 购物车商品列表（包含详细信息）
     */
    public static List<CartItemDetail> getCartItemsDetail(int userId) {
        List<Cart> cartItems = getCartItems(userId);
        List<CartItemDetail> details = new ArrayList<>();

        for (Cart item : cartItems) {
            Fruit fruit = FruitService.info(item.getFruitId());
            if (fruit != null) {
                CartItemDetail detail = new CartItemDetail();
                detail.setCartId(item.getId());
                detail.setFruitId(item.getFruitId());
                detail.setFruitName(fruit.getFname());
                detail.setSpec(fruit.getSpec());
                detail.setPrice(fruit.getUp());
                detail.setQuantity(item.getQuantity());
                detail.setSubtotal(fruit.getUp() * item.getQuantity());
                details.add(detail);
            }
        }

        return details;
    }

    /**
     * 计算购物车总价
     * @param userId 用户ID
     * @return 购物车总价
     */
    public static double getCartTotal(int userId) {
        List<CartItemDetail> items = getCartItemsDetail(userId);
        double total = 0;
        for (CartItemDetail item : items) {
            total += item.getSubtotal();
        }
        return total;
    }

    /**
     * 购物车项详情（内部类，用于传递购物车项的详细信息）
     */
    public static class CartItemDetail {
        private int cartId;
        private int fruitId;
        private String fruitName;
        private String spec;
        private double price;
        private int quantity;
        private double subtotal;

        public int getCartId() { return cartId; }
        public void setCartId(int cartId) { this.cartId = cartId; }

        public int getFruitId() { return fruitId; }
        public void setFruitId(int fruitId) { this.fruitId = fruitId; }

        public String getFruitName() { return fruitName; }
        public void setFruitName(String fruitName) { this.fruitName = fruitName; }

        public String getSpec() { return spec; }
        public void setSpec(String spec) { this.spec = spec; }

        public double getPrice() { return price; }
        public void setPrice(double price) { this.price = price; }

        public int getQuantity() { return quantity; }
        public void setQuantity(int quantity) { this.quantity = quantity; }

        public double getSubtotal() { return subtotal; }
        public void setSubtotal(double subtotal) { this.subtotal = subtotal; }
    }
}
