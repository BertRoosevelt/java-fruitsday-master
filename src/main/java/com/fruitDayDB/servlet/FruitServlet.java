package com.fruitDayDB.servlet;

import com.fruitDayDB.service.FruitService;
import com.fruitDayDB.service.ShopService;
import com.fruitDayDB.service.FavoriteService;
import com.fruitDayDB.vo.Fruit;
import com.fruitDayDB.vo.Cart;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

/**
 * 商品 Servlet
 * 处理商品相关的所有请求
 */
public class FruitServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        doGet(req, resp);
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("text/html;charset=utf-8");
        req.setCharacterEncoding("utf-8");

        String key = req.getParameter("key");

        if (key != null) {
            switch (key) {
                case "info":           // 商品详情
                    doInfo(req, resp);
                    break;
                case "all":            // 所有商品
                    doAll(req, resp);
                    break;
                case "hot":            // 热卖商品
                    doHot(req, resp);
                    break;
                case "favorite":       // 添加收藏
                    doAddFavorite(req, resp);
                    break;
                case "unfavorite":     // 取消收藏
                case "removeFav":      // 删除收藏
                    doRemoveFavorite(req, resp);
                    break;
                case "viewFav":        // 查看收藏夹
                    doViewFavorites(req, resp);
                    break;
                default:
                    break;
            }
        }
    }

    /**
     * 商品详情
     * 参数: fid (商品ID)
     */
    private void doInfo(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            int fruitId = Integer.parseInt(req.getParameter("fid"));

            // 查询商品详情
            Fruit fruit = FruitService.info(fruitId);

            if (fruit == null) {
                req.setAttribute("error", "商品不存在");
                req.getRequestDispatcher("/index.jsp").forward(req, resp);
                return;
            }

            // 检查用户是否已登录
            HttpSession session = req.getSession();
            com.fruitDayDB.vo.User user = (com.fruitDayDB.vo.User) session.getAttribute("user");

            if (user != null) {
                // 分别查询购物车状态和收藏状态（两张独立的表）
                boolean inCart = ShopService.findInCart(user.getId(), fruitId) != null;
                boolean isFavorite = FavoriteService.isFavorite(user.getId(), fruitId);
                req.setAttribute("isFavorite", isFavorite);
                req.setAttribute("inCart", inCart);
                if (inCart) req.setAttribute("tit1", "已加入购物车");
                if (isFavorite) req.setAttribute("tit2", "已关注");
            }

            req.setAttribute("fruit", fruit);
            req.getRequestDispatcher("/fruit_info.jsp").forward(req, resp);

        } catch (NumberFormatException e) {
            req.setAttribute("error", "商品ID格式错误");
            req.getRequestDispatcher("/index.jsp").forward(req, resp);
        }
    }

    /**
     * 所有商品
     */
    private void doAll(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        List<Fruit> fruits = FruitService.all();

        req.setAttribute("fruits", fruits);
        req.setAttribute("title", "所有商品");
        req.getRequestDispatcher("/index.jsp").forward(req, resp);
    }

    /**
     * 热卖商品
     */
    private void doHot(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        List<Fruit> hotFruits = FruitService.hot();

        req.setAttribute("fruits", hotFruits);
        req.setAttribute("title", "热卖商品");
        req.getRequestDispatcher("/index.jsp").forward(req, resp);
    }

    /**
     * 添加收藏（支持 AJAX）
     */
    private void doAddFavorite(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
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
            if (fruitIdParam == null) {
                if (isAjax) {
                    sendJsonResponse(resp, false, "缺少商品ID参数");
                } else {
                    resp.sendRedirect(req.getContextPath() + "/index.jsp");
                }
                return;
            }
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
     * 取消收藏
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
            resp.sendRedirect(req.getContextPath() + "/FruitServlet?key=viewFav");

        } catch (Exception e) {
            e.printStackTrace();
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

        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        req.getRequestDispatcher("/showstar.jsp").forward(req, resp);
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