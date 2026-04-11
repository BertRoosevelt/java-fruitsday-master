package com.fruitDayDB.servlet;

import com.fruitDayDB.service.FruitService;
import com.fruitDayDB.vo.Fruit;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

/**
 * 商品搜索 Servlet
 * 处理商品搜索请求
 */
public class selServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        doGet(req, resp);
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("text/html;charset=utf-8");
        req.setCharacterEncoding("utf-8");

        String key = req.getParameter("key");
        String priceMin = req.getParameter("priceMin");

        if (key != null) {
            switch (key) {
                case "search":  // 搜索商品
                    doSearch(req, resp);
                    break;
                case "hot":     // 热卖商品
                    doHot(req, resp);
                    break;
                default:
                    doShowAll(req, resp);
                    break;
            }
        } else if (priceMin != null) {
            // 价格筛选
            doPriceFilter(req, resp);
        } else {
            // 默认显示所有商品
            doShowAll(req, resp);
        }
    }

    /**
     * 按价格筛选
     */
    private void doPriceFilter(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            double min = Double.parseDouble(req.getParameter("priceMin"));
            String priceMaxParam = req.getParameter("priceMax");
            double max = priceMaxParam != null ? Double.parseDouble(priceMaxParam) : Double.MAX_VALUE;

            List<Fruit> allFruits = FruitService.all();
            List<Fruit> filtered = new java.util.ArrayList<>();
            for (Fruit f : allFruits) {
                if (f.getUp() >= min && f.getUp() <= max) {
                    filtered.add(f);
                }
            }
            req.setAttribute("fruits", filtered);
            req.setAttribute("title", "价格筛选");
            req.getRequestDispatcher("/sel.jsp").forward(req, resp);
        } catch (NumberFormatException e) {
            doShowAll(req, resp);
        }
    }

    /**
     * 搜索商品
     * 参数: keyword
     */
    private void doSearch(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String keyword = req.getParameter("keyword");

        if (keyword == null || keyword.trim().isEmpty()) {
            doShowAll(req, resp);
            return;
        }

        List<Fruit> fruits = FruitService.search(keyword.trim());

        req.setAttribute("fruits", fruits);
        req.setAttribute("searchKeyword", keyword.trim());
        req.getRequestDispatcher("/sel.jsp").forward(req, resp);
    }

    /**
     * 显示热卖商品
     */
    private void doHot(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        List<Fruit> hotFruits = FruitService.hot();

        req.setAttribute("fruits", hotFruits);
        req.setAttribute("title", "热卖商品");
        req.getRequestDispatcher("/sel.jsp").forward(req, resp);
    }

    /**
     * 显示所有商品
     */
    private void doShowAll(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        List<Fruit> allFruits = FruitService.all();

        req.setAttribute("fruits", allFruits);
        req.getRequestDispatcher("/sel.jsp").forward(req, resp);
    }
}