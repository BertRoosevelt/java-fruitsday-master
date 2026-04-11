package com.fruitDayDB.servlet;

import com.fruitDayDB.service.OrderService;
import com.fruitDayDB.service.UserService;
import com.fruitDayDB.vo.Order;
import com.fruitDayDB.vo.User;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

/**
 * 管理员专用 Servlet（仅管理员可访问）
 * 处理订单管理、统计等后台操作
 */
public class AdminServlet extends HttpServlet {

    private boolean checkAdmin(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        User user = (User) req.getSession().getAttribute("user");
        if (user == null || !user.isAdmin()) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return false;
        }
        return true;
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        doPost(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("text/html;charset=utf-8");
        req.setCharacterEncoding("utf-8");
        if (!checkAdmin(req, resp)) return;

        String key = req.getParameter("key");
        if (key == null) key = "";

        switch (key) {
            case "orders":
                doListOrders(req, resp);
                break;
            case "orderDetail":
                doOrderDetail(req, resp);
                break;
            case "ship":
                doShipOrder(req, resp);
                break;
            case "stats":
                doStats(req, resp);
                break;
            default:
                resp.sendRedirect(req.getContextPath() + "/BSindex.jsp");
        }
    }

    /** 管理员查看所有订单列表 */
    private void doListOrders(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String status = req.getParameter("status");
        List<Order> orders;
        if (status != null && !status.isEmpty()) {
            orders = OrderService.getAllOrdersByStatus(status);
        } else {
            orders = OrderService.getAllOrders();
        }
        req.setAttribute("orders", orders);
        req.setAttribute("filterStatus", status);
        req.getRequestDispatcher("/admin/orders.jsp").forward(req, resp);
    }

    /** 管理员查看订单详情 */
    private void doOrderDetail(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            int orderId = Integer.parseInt(req.getParameter("orderId"));
            Order order = OrderService.getOrderDetail(orderId);
            req.setAttribute("order", order);
            if (order != null) {
                req.setAttribute("statusDisplay", OrderService.getStatusDisplay(order.getStatus()));
                // 获取下单用户信息
                User orderUser = UserService.findById(order.getUserId());
                req.setAttribute("orderUser", orderUser);
            }
            req.getRequestDispatcher("/admin/order_detail.jsp").forward(req, resp);
        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/AdminServlet?key=orders");
        }
    }

    /** 管理员发货操作 */
    private void doShipOrder(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            int orderId = Integer.parseInt(req.getParameter("orderId"));
            OrderService.shipOrder(orderId);
            resp.sendRedirect(req.getContextPath() + "/AdminServlet?key=orderDetail&orderId=" + orderId + "&shipped=1");
        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/AdminServlet?key=orders");
        }
    }

    /** 管理员统计数据（供 BSindex.jsp 调用） */
    private void doStats(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        long userCount = UserService.alluser().size();
        long orderCount = OrderService.getAllOrders().size();
        long pendingCount = OrderService.getAllOrdersByStatus("paid").size(); // 待发货
        req.setAttribute("userCount", userCount);
        req.setAttribute("orderCount", orderCount);
        req.setAttribute("pendingShipCount", pendingCount);
        req.getRequestDispatcher("/BSindex.jsp").forward(req, resp);
    }
}
