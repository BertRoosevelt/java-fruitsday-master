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

        if (key != null) {
            switch (key) {
                case "search":  // 搜索商品
                    doSearch(req, resp);
                    break;
                case "hot":     // 热卖商品
                    doHot(req, resp);
                    break;
                default:
                    break;
            }
        } else {
            // 默认显示所有商品
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
            // 关键词为空，显示所有商品
            doShowAll(req, resp);
            return;
        }

        // 获取搜索结果
        List<Fruit> fruits = FruitService.search(keyword);

        req.setAttribute("fruits", fruits);
        req.setAttribute("searchKeyword", keyword);
        req.getRequestDispatcher("/search_result.jsp").forward(req, resp);
    }

    /**
     * 显示热卖商品
     */
    private void doHot(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        List<Fruit> hotFruits = FruitService.hot();

        req.setAttribute("fruits", hotFruits);
        req.setAttribute("title", "热卖商品");
        req.getRequestDispatcher("/index.jsp").forward(req, resp);
    }

    /**
     * 显示所有商品
     */
    private void doShowAll(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        List<Fruit> allFruits = FruitService.all();

        req.setAttribute("fruits", allFruits);
        req.getRequestDispatcher("/index.jsp").forward(req, resp);
    }
}