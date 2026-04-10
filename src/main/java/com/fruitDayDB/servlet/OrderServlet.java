package com.fruitDayDB.servlet;

import com.fruitDayDB.service.OrderService;
import com.fruitDayDB.vo.Order;
import com.fruitDayDB.vo.OrderItem;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

/**
 * 订单 Servlet
 * 处理订单相关的所有请求
 */
public class OrderServlet extends HttpServlet {

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

        if (userObj == null && !key.equals("detail")) {
            req.getRequestDispatcher("/login.jsp").forward(req, resp);
            return;
        }

        if (key != null) {
            switch (key) {
                case "create":         // 创建订单
                    doCreateOrder(req, resp);
                    break;
                case "list":           // 查看订单列表
                    doListOrders(req, resp);
                    break;
                case "detail":         // 查看订单详情
                    doOrderDetail(req, resp);
                    break;
                case "pay":            // 支付订单
                    doPayOrder(req, resp);
                    break;
                case "confirm":        // 确认收货
                    doConfirmOrder(req, resp);
                    break;
                case "cancel":         // 取消订单
                    doCancelOrder(req, resp);
                    break;
                case "status":         // 查询指定状态的订单
                    doListOrdersByStatus(req, resp);
                    break;
                default:
                    break;
            }
        }
    }

    /**
     * 创建订单（从购物车）
     */
    private void doCreateOrder(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        com.fruitDayDB.vo.User user = (com.fruitDayDB.vo.User) session.getAttribute("user");

        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        try {
            String orderNumber = OrderService.createOrderFromCart(user.getId());

            if (orderNumber != null) {
                // 订单创建成功，重定向到订单支付页面
                resp.sendRedirect(req.getContextPath() + "/OrderServlet?key=detail&orderNumber=" + orderNumber);
            } else {
                // 订单创建失败，可能是购物车为空
                req.setAttribute("error", "购物车为空，无法创建订单");
                req.getRequestDispatcher("/showcart.jsp").forward(req, resp);
            }
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "创建订单失败");
            req.getRequestDispatcher("/showcart.jsp").forward(req, resp);
        }
    }

    /**
     * 查看订单列表
     */
    private void doListOrders(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        com.fruitDayDB.vo.User user = (com.fruitDayDB.vo.User) session.getAttribute("user");

        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        // 获取用户的所有订单
        List<Order> orders = OrderService.getUserOrders(user.getId());

        req.setAttribute("orders", orders);
        req.getRequestDispatcher("/order_list.jsp").forward(req, resp);
    }

    /**
     * 查看订单详情
     */
    private void doOrderDetail(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String orderNumber = req.getParameter("orderNumber");
        String orderIdStr = req.getParameter("orderId");

        Order order = null;

        if (orderNumber != null && !orderNumber.isEmpty()) {
            order = OrderService.getOrderByNumber(orderNumber);
        } else if (orderIdStr != null) {
            try {
                int orderId = Integer.parseInt(orderIdStr);
                order = OrderService.getOrderDetail(orderId);
            } catch (NumberFormatException e) {
                req.setAttribute("error", "订单ID格式错误");
                req.getRequestDispatcher("/index.jsp").forward(req, resp);
                return;
            }
        }

        if (order == null) {
            req.setAttribute("error", "订单不存在");
            req.getRequestDispatcher("/index.jsp").forward(req, resp);
            return;
        }

        // 验证订单是否属于当前用户（如果用户已登录）
        HttpSession session = req.getSession();
        Object userObj = session.getAttribute("user");
        if (userObj != null) {
            com.fruitDayDB.vo.User user = (com.fruitDayDB.vo.User) userObj;
            if (order.getUserId() != user.getId()) {
                req.setAttribute("error", "无权查看此订单");
                req.getRequestDispatcher("/index.jsp").forward(req, resp);
                return;
            }
        }

        req.setAttribute("order", order);
        req.setAttribute("statusDisplay", OrderService.getStatusDisplay(order.getStatus()));
        req.getRequestDispatcher("/order_detail.jsp").forward(req, resp);
    }

    /**
     * 支付订单（模拟支付）
     */
    private void doPayOrder(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        com.fruitDayDB.vo.User user = (com.fruitDayDB.vo.User) session.getAttribute("user");

        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        try {
            int orderId = Integer.parseInt(req.getParameter("orderId"));

            // 验证订单是否属于当前用户
            Order order = OrderService.getOrderDetail(orderId);
            if (order == null || order.getUserId() != user.getId()) {
                req.setAttribute("error", "无法支付此订单");
                req.getRequestDispatcher("/index.jsp").forward(req, resp);
                return;
            }

            boolean success = OrderService.payOrder(orderId);

            if (success) {
                // 支付成功
                resp.sendRedirect(req.getContextPath() + "/OrderServlet?key=detail&orderId=" + orderId + "&paid=1");
            } else {
                req.setAttribute("error", "支付失败");
                req.getRequestDispatcher("/OrderServlet?key=detail&orderId=" + orderId).forward(req, resp);
            }
        } catch (NumberFormatException e) {
            req.setAttribute("error", "参数错误");
            req.getRequestDispatcher("/index.jsp").forward(req, resp);
        }
    }

    /**
     * 确认收货
     */
    private void doConfirmOrder(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        com.fruitDayDB.vo.User user = (com.fruitDayDB.vo.User) session.getAttribute("user");

        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        try {
            int orderId = Integer.parseInt(req.getParameter("orderId"));

            // 验证订单是否属于当前用户
            Order order = OrderService.getOrderDetail(orderId);
            if (order == null || order.getUserId() != user.getId()) {
                req.setAttribute("error", "无法确认此订单");
                req.getRequestDispatcher("/index.jsp").forward(req, resp);
                return;
            }

            boolean success = OrderService.completeOrder(orderId);

            if (success) {
                resp.sendRedirect(req.getContextPath() + "/OrderServlet?key=detail&orderId=" + orderId + "&confirmed=1");
            } else {
                req.setAttribute("error", "确认失败");
                req.getRequestDispatcher("/OrderServlet?key=detail&orderId=" + orderId).forward(req, resp);
            }
        } catch (NumberFormatException e) {
            req.setAttribute("error", "参数错误");
            req.getRequestDispatcher("/index.jsp").forward(req, resp);
        }
    }

    /**
     * 取消订单
     */
    private void doCancelOrder(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        com.fruitDayDB.vo.User user = (com.fruitDayDB.vo.User) session.getAttribute("user");

        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        try {
            int orderId = Integer.parseInt(req.getParameter("orderId"));

            // 验证订单是否属于当前用户
            Order order = OrderService.getOrderDetail(orderId);
            if (order == null || order.getUserId() != user.getId()) {
                req.setAttribute("error", "无法取消此订单");
                req.getRequestDispatcher("/index.jsp").forward(req, resp);
                return;
            }

            boolean success = OrderService.cancelOrder(orderId);

            if (success) {
                resp.sendRedirect(req.getContextPath() + "/OrderServlet?key=list&cancelled=1");
            } else {
                req.setAttribute("error", "取消失败");
                req.getRequestDispatcher("/OrderServlet?key=detail&orderId=" + orderId).forward(req, resp);
            }
        } catch (NumberFormatException e) {
            req.setAttribute("error", "参数错误");
            req.getRequestDispatcher("/index.jsp").forward(req, resp);
        }
    }

    /**
     * 查询指定状态的订单
     * 参数: status (pending, paid, shipped, completed, cancelled)
     */
    private void doListOrdersByStatus(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        com.fruitDayDB.vo.User user = (com.fruitDayDB.vo.User) session.getAttribute("user");

        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        String status = req.getParameter("status");

        if (status == null || status.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/OrderServlet?key=list");
            return;
        }

        // 验证status参数
        if (!isValidStatus(status)) {
            req.setAttribute("error", "无效的订单状态");
            req.getRequestDispatcher("/OrderServlet?key=list").forward(req, resp);
            return;
        }

        List<Order> orders = OrderService.getUserOrdersByStatus(user.getId(), status);

        req.setAttribute("orders", orders);
        req.setAttribute("filterStatus", status);
        req.setAttribute("statusDisplay", OrderService.getStatusDisplay(status));
        req.getRequestDispatcher("/order_list.jsp").forward(req, resp);
    }

    /**
     * 验证订单状态是否有效
     */
    private boolean isValidStatus(String status) {
        return status.equals("pending") ||
                status.equals("paid") ||
                status.equals("shipped") ||
                status.equals("completed") ||
                status.equals("cancelled");
    }
}