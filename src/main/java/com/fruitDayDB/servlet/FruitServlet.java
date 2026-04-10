package com.fruitDayDB.servlet;

import com.fruitDayDB.service.FruitService;
import com.fruitDayDB.service.ShopService;
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
                // 用户已登录，检查是否收藏
                Cart cart = ShopService.find(user.getId(), fruitId);
                req.setAttribute("isFavorite", cart != null && cart.isFavorite());
                req.setAttribute("inCart", cart != null && !cart.isFavorite());
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
     * 辅助方法：查询购物车中的商品
     */
    public static Cart find(int userId, int fruitId) {
        return ShopService.find(userId, fruitId);
    }
}