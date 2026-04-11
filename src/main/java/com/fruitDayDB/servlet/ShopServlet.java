package com.fruitDayDB.servlet;

import com.fruitDayDB.service.ShopService;
import com.fruitDayDB.service.FruitService;
import com.fruitDayDB.vo.Cart;
import com.fruitDayDB.vo.Fruit;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

/**
 * 购物车 Servlet
 * 处理购物车相关的所有请求
 */
public class ShopServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        doGet(req, resp);
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("text/html;charset=utf-8");
        req.setCharacterEncoding("utf-8");

        String key = req.getParameter("key");

        // 检查用户是否登录
        HttpSession session = req.getSession();
        Object userObj = session.getAttribute("user");
        if (userObj == null && !key.equals("view")) {
            req.getRequestDispatcher("/login.jsp").forward(req, resp);
            return;
        }

        if (key != null) {
            switch (key) {
                case "add":           // 添加到购物车
                    doAddToCart(req, resp);
                    break;
                case "remove":        // 从购物车删除
                    doRemoveFromCart(req, resp);
                    break;
                case "updateQty":     // 修改数量 ⭐ 新增
                    doUpdateQuantity(req, resp);
                    break;
                case "view":          // 查看购物车 ⭐ 改进
                    doViewCart(req, resp);
                    break;
                case "favorite":      // 添加到收藏
                    doAddToFavorite(req, resp);
                    break;
                case "unfavorite":    // 取消收藏
                case "removeFav":     // 删除收藏
                    doRemoveFavorite(req, resp);
                    break;
                case "viewFav":       // 查看收藏
                    doViewFavorites(req, resp);
                    break;
                case "clear":         // 清空购物车
                    doClearCart(req, resp);
                    break;
                default:
                    break;
            }
        }
    }

    /**
     * 添加商品到购物车
     * 参数: fruitId, quantity
     */
    private void doAddToCart(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        com.fruitDayDB.vo.User user = (com.fruitDayDB.vo.User) session.getAttribute("user");

        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        try {
            int fruitId = Integer.parseInt(req.getParameter("fruitId"));
            int quantity = Integer.parseInt(req.getParameter("quantity"));

            // 验证商品是否存在
            Fruit fruit = FruitService.info(fruitId);
            if (fruit == null) {
                req.setAttribute("error", "商品不存在");
                req.getRequestDispatcher("/index.jsp").forward(req, resp);
                return;
            }

            // 验证库存
            if (fruit.getInum() < quantity) {
                req.setAttribute("error", "库存不足");
                req.getRequestDispatcher("/fruit_info.jsp?fid=" + fruitId).forward(req, resp);
                return;
            }

            // 添加到购物车
            boolean success = ShopService.addToCart(user.getId(), fruitId, quantity);

            if (success) {
                // 重定向到商品详情页，显示成功提示
                resp.sendRedirect(req.getContextPath() + "/fruit_info.jsp?fid=" + fruitId + "&success=1");
            } else {
                req.setAttribute("error", "添加购物车失败");
                req.getRequestDispatcher("/fruit_info.jsp?fid=" + fruitId).forward(req, resp);
            }
        } catch (NumberFormatException e) {
            req.setAttribute("error", "参数错误");
            req.getRequestDispatcher("/index.jsp").forward(req, resp);
        }
    }

    /**
     * 从购物车删除商品
     * 参数: fruitId
     */
    private void doRemoveFromCart(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        com.fruitDayDB.vo.User user = (com.fruitDayDB.vo.User) session.getAttribute("user");

        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        try {
            int fruitId = Integer.parseInt(req.getParameter("fruitId"));

            boolean success = ShopService.removeFromCart(user.getId(), fruitId);

            if (success) {
                resp.sendRedirect(req.getContextPath() + "/showcart.jsp");
            } else {
                req.setAttribute("error", "删除失败");
                req.getRequestDispatcher("/showcart.jsp").forward(req, resp);
            }
        } catch (NumberFormatException e) {
            req.setAttribute("error", "参数错误");
            req.getRequestDispatcher("/showcart.jsp").forward(req, resp);
        }
    }

    /**
     * 修改购物车商品的数量 ⭐ 新增
     * 参数: fruitId, quantity
     */
    private void doUpdateQuantity(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        com.fruitDayDB.vo.User user = (com.fruitDayDB.vo.User) session.getAttribute("user");

        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        try {
            int fruitId = Integer.parseInt(req.getParameter("fruitId"));
            int quantity = Integer.parseInt(req.getParameter("quantity"));

            // 验证数量
            if (quantity <= 0) {
                req.setAttribute("error", "数量必须大于0");
                req.getRequestDispatcher("/showcart.jsp").forward(req, resp);
                return;
            }

            // 验证库存
            Fruit fruit = FruitService.info(fruitId);
            if (fruit == null || fruit.getInum() < quantity) {
                req.setAttribute("error", "库存不足");
                req.getRequestDispatcher("/showcart.jsp").forward(req, resp);
                return;
            }

            boolean success = ShopService.updateCartQuantity(user.getId(), fruitId, quantity);

            if (success) {
                resp.sendRedirect(req.getContextPath() + "/showcart.jsp?success=1");
            } else {
                req.setAttribute("error", "修改失败");
                req.getRequestDispatcher("/showcart.jsp").forward(req, resp);
            }
        } catch (NumberFormatException e) {
            req.setAttribute("error", "参数错误");
            req.getRequestDispatcher("/showcart.jsp").forward(req, resp);
        }
    }

    /**
     * 查看购物车 ⭐ 改进（添加详细信息）
     */
    private void doViewCart(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        com.fruitDayDB.vo.User user = (com.fruitDayDB.vo.User) session.getAttribute("user");

        if (user != null) {
            // 获取购物车详细信息
            List<ShopService.CartItemDetail> cartItems = ShopService.getCartItemsDetail(user.getId());
            double cartTotal = ShopService.getCartTotal(user.getId());
            int cartCount = ShopService.getCartCount(user.getId());

            req.setAttribute("cartItems", cartItems);
            req.setAttribute("cartTotal", cartTotal);
            req.setAttribute("cartCount", cartCount);
        }

        req.getRequestDispatcher("/showcart.jsp").forward(req, resp);
    }

    /**
     * 添加商品到收藏
     * 参数: fruitId
     */
    private void doAddToFavorite(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        com.fruitDayDB.vo.User user = (com.fruitDayDB.vo.User) session.getAttribute("user");

        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        try {
            int fruitId = Integer.parseInt(req.getParameter("fruitId"));

            // 验证商品是否存在
            Fruit fruit = FruitService.info(fruitId);
            if (fruit == null) {
                req.setAttribute("error", "商品不存在");
                req.getRequestDispatcher("/index.jsp").forward(req, resp);
                return;
            }

            boolean success = ShopService.addToFavorites(user.getId(), fruitId);

            if (success) {
                resp.sendRedirect(req.getContextPath() + "/fruit_info.jsp?fid=" + fruitId + "&fav=1");
            } else {
                req.setAttribute("error", "添加收藏失败");
                req.getRequestDispatcher("/fruit_info.jsp?fid=" + fruitId).forward(req, resp);
            }
        } catch (NumberFormatException e) {
            req.setAttribute("error", "参数错误");
            req.getRequestDispatcher("/index.jsp").forward(req, resp);
        }
    }

    /**
     * 从收藏中删除商品
     * 参数: fruitId
     */
    private void doRemoveFavorite(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        com.fruitDayDB.vo.User user = (com.fruitDayDB.vo.User) session.getAttribute("user");

        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        try {
            int fruitId = Integer.parseInt(req.getParameter("fruitId"));

            boolean success = ShopService.removeFromFavorites(user.getId(), fruitId);

            if (success) {
                resp.sendRedirect(req.getContextPath() + "/showstar.jsp");
            } else {
                req.setAttribute("error", "删除失败");
                req.getRequestDispatcher("/showstar.jsp").forward(req, resp);
            }
        } catch (NumberFormatException e) {
            req.setAttribute("error", "参数错误");
            req.getRequestDispatcher("/showstar.jsp").forward(req, resp);
        }
    }

    /**
     * 查看收藏夹
     */
    private void doViewFavorites(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        com.fruitDayDB.vo.User user = (com.fruitDayDB.vo.User) session.getAttribute("user");

        if (user != null) {
            List<ShopService.CartItemDetail> favorites = new ArrayList<>();

            // 获取收藏的商品详情
            List<Cart> favCarts = ShopService.getFavorites(user.getId());
            for (Cart cart : favCarts) {
                Fruit fruit = FruitService.info(cart.getFruitId());
                if (fruit != null) {
                    ShopService.CartItemDetail detail = new ShopService.CartItemDetail();
                    detail.setCartId(cart.getId());
                    detail.setFruitId(cart.getFruitId());
                    detail.setFruitName(fruit.getFname());
                    detail.setPrice(fruit.getUp());
                    favorites.add(detail);
                }
            }

            req.setAttribute("favorites", favorites);
        }

        req.getRequestDispatcher("/showstar.jsp").forward(req, resp);
    }

    /**
     * 清空购物车
     */
    private void doClearCart(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        com.fruitDayDB.vo.User user = (com.fruitDayDB.vo.User) session.getAttribute("user");

        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        boolean success = ShopService.clearCart(user.getId());

        if (success) {
            resp.sendRedirect(req.getContextPath() + "/showcart.jsp?cleared=1");
        } else {
            req.setAttribute("error", "清空失败");
            req.getRequestDispatcher("/showcart.jsp").forward(req, resp);
        }
    }
}