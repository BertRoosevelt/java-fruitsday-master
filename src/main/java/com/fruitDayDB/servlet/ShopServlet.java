package com.fruitDayDB.servlet;

import com.fruitDayDB.service.ShopService;
import com.fruitDayDB.service.FruitService;
import com.fruitDayDB.service.FavoriteService;
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
        if (userObj == null && !"view".equals(key)) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
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
                case "updateQty":     // 修改数量
                    doUpdateQuantity(req, resp);
                    break;
                case "view":          // 查看购物车
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
                    resp.sendRedirect(req.getContextPath() + "/ShopServlet?key=view");
                    break;
            }
        } else {
            resp.sendRedirect(req.getContextPath() + "/ShopServlet?key=view");
        }
    }

    /**
     * 添加商品到购物车
     * 支持 AJAX 请求（返回 JSON）和普通表单请求（重定向）
     */
    private void doAddToCart(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        com.fruitDayDB.vo.User user = (com.fruitDayDB.vo.User) session.getAttribute("user");

        boolean isAjax = "XMLHttpRequest".equals(req.getHeader("X-Requested-With"))
                || "application/json".equals(req.getContentType())
                || req.getHeader("Accept") != null && req.getHeader("Accept").contains("application/json");

        if (user == null) {
            if (isAjax) {
                sendJsonResponse(resp, false, "请先登录");
            } else {
                resp.sendRedirect(req.getContextPath() + "/login.jsp");
            }
            return;
        }

        try {
            String fruitIdParam = req.getParameter("fruitId");
            if (fruitIdParam == null) fruitIdParam = req.getParameter("fid");
            int fruitId = Integer.parseInt(fruitIdParam);

            String quantityParam = req.getParameter("quantity");
            if (quantityParam == null) quantityParam = "1";
            int quantity = Integer.parseInt(quantityParam);

            Fruit fruit = FruitService.info(fruitId);
            if (fruit == null || fruit.getInum() < quantity) {
                if (isAjax) {
                    sendJsonResponse(resp, false, "商品不存在或库存不足");
                } else {
                    resp.sendRedirect(req.getContextPath() + "/FruitServlet?key=info&fid=" + fruitId);
                }
                return;
            }

            Cart existing = ShopService.findInCart(user.getId(), fruitId);
            if (existing != null) {
                if (isAjax) {
                    sendJsonResponse(resp, false, "该商品已在购物车中");
                } else {
                    resp.sendRedirect(req.getContextPath() + "/FruitServlet?key=info&fid=" + fruitId);
                }
                return;
            }

            ShopService.addToCart(user.getId(), fruitId, quantity);

            if (isAjax) {
                sendJsonResponse(resp, true, "已加入购物车");
            } else {
                resp.sendRedirect(req.getContextPath() + "/FruitServlet?key=info&fid=" + fruitId);
            }

        } catch (Exception e) {
            e.printStackTrace();
            if (isAjax) {
                sendJsonResponse(resp, false, "操作失败，请重试");
            } else {
                resp.sendRedirect(req.getContextPath() + "/index.jsp");
            }
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
            ShopService.removeFromCart(user.getId(), fruitId);
            resp.sendRedirect(req.getContextPath() + "/ShopServlet?key=view");
        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/ShopServlet?key=view");
        }
    }

    /**
     * 修改购物车商品的数量
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
                ShopService.removeFromCart(user.getId(), fruitId);
                resp.sendRedirect(req.getContextPath() + "/ShopServlet?key=view");
                return;
            }

            // 验证库存
            Fruit fruit = FruitService.info(fruitId);
            if (fruit == null || fruit.getInum() < quantity) {
                req.setAttribute("error", "商品库存不足");
                req.getRequestDispatcher("/ShopServlet?key=view").forward(req, resp);
                return;
            }

            ShopService.updateCartQuantity(user.getId(), fruitId, quantity);
            resp.sendRedirect(req.getContextPath() + "/ShopServlet?key=view");
        } catch (NumberFormatException e) {
            req.setAttribute("error", "参数错误");
            req.getRequestDispatcher("/showcart.jsp").forward(req, resp);
        }
    }

    /**
     * 查看购物车
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
     * 添加商品到收藏（使用独立的 favorites 表）
     * 支持 AJAX 请求（返回 JSON）和普通表单请求（重定向）
     */
    private void doAddToFavorite(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        com.fruitDayDB.vo.User user = (com.fruitDayDB.vo.User) session.getAttribute("user");

        boolean isAjax = "XMLHttpRequest".equals(req.getHeader("X-Requested-With"))
                || "application/json".equals(req.getContentType())
                || req.getHeader("Accept") != null && req.getHeader("Accept").contains("application/json");

        if (user == null) {
            if (isAjax) {
                sendJsonResponse(resp, false, "请先登录");
            } else {
                resp.sendRedirect(req.getContextPath() + "/login.jsp");
            }
            return;
        }

        try {
            String fruitIdParam = req.getParameter("fruitId");
            if (fruitIdParam == null) fruitIdParam = req.getParameter("fid");
            int fruitId = Integer.parseInt(fruitIdParam);

            Fruit fruit = FruitService.info(fruitId);
            if (fruit == null) {
                if (isAjax) {
                    sendJsonResponse(resp, false, "商品不存在");
                } else {
                    resp.sendRedirect(req.getContextPath() + "/index.jsp");
                }
                return;
            }

            if (FavoriteService.isFavorite(user.getId(), fruitId)) {
                if (isAjax) {
                    sendJsonResponse(resp, false, "该商品已在收藏中");
                } else {
                    resp.sendRedirect(req.getContextPath() + "/FruitServlet?key=info&fid=" + fruitId);
                }
                return;
            }

            FavoriteService.addToFavorites(user.getId(), fruitId);

            if (isAjax) {
                sendJsonResponse(resp, true, "已关注");
            } else {
                resp.sendRedirect(req.getContextPath() + "/FruitServlet?key=info&fid=" + fruitId);
            }

        } catch (Exception e) {
            e.printStackTrace();
            if (isAjax) {
                sendJsonResponse(resp, false, "操作失败，请重试");
            } else {
                resp.sendRedirect(req.getContextPath() + "/index.jsp");
            }
        }
    }

    /**
     * 从收藏中删除商品（使用独立的 favorites 表）
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
            FavoriteService.removeFromFavorites(user.getId(), fruitId);
            resp.sendRedirect(req.getContextPath() + "/ShopServlet?key=viewFav");

        } catch (NumberFormatException e) {
            req.setAttribute("error", "参数错误");
            req.getRequestDispatcher("/showstar.jsp").forward(req, resp);
        }
    }

    /**
     * 查看收藏夹（使用独立的 favorites 表）
     */
    private void doViewFavorites(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        com.fruitDayDB.vo.User user = (com.fruitDayDB.vo.User) session.getAttribute("user");

        if (user != null) {
            List<Object> favorites = new ArrayList<>();
            List<com.fruitDayDB.vo.Favorite> favList = FavoriteService.getFavorites(user.getId());

            for (com.fruitDayDB.vo.Favorite fav : favList) {
                Fruit fruit = FruitService.info(fav.getFruitId());
                if (fruit != null) {
                    favorites.add(fruit);
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

        ShopService.clearCart(user.getId());
        resp.sendRedirect(req.getContextPath() + "/ShopServlet?key=view");
    }

    /**
     * 辅助方法：返回 JSON 响应
     */
    private void sendJsonResponse(HttpServletResponse resp, boolean success, String message) throws IOException {
        resp.setContentType("application/json; charset=utf-8");
        String escaped = message.replace("\"", "\\\"");
        resp.getWriter().print("{\"success\":" + success + ",\"message\":\"" + escaped + "\"}");
    }
}