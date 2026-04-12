<%@ page import="java.util.List" %>
<%@ page import="com.fruitDayDB.vo.Order" %>
<%@ page import="com.fruitDayDB.vo.OrderItem" %>
<%@ page import="com.fruitDayDB.vo.User" %>
<%@ page import="com.fruitDayDB.service.OrderService" %>
<%--
订单列表页面
显示用户的所有订单
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8" />
    <title>我的订单 - 水果超市管理系统</title>
    <link rel="stylesheet" type="text/css" href="css/main.css"/>
    <style>
        .order-container {
            max-width: 1000px;
            margin: 20px auto;
        }
        .order-header {
            background-color: #f5f5f5;
            padding: 15px;
            margin-bottom: 20px;
            border-radius: 5px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .order-tabs {
            margin-bottom: 20px;
            border-bottom: 2px solid #ddd;
        }
        .order-tabs a {
            display: inline-block;
            padding: 10px 20px;
            margin-right: 10px;
            text-decoration: none;
            color: #666;
            border-bottom: 3px solid transparent;
        }
        .order-tabs a.active {
            color: #0275d8;
            border-bottom-color: #0275d8;
        }
        .order-card {
            background-color: #fff;
            border: 1px solid #ddd;
            border-radius: 5px;
            padding: 15px;
            margin-bottom: 15px;
        }
        .order-card-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 15px;
            padding-bottom: 15px;
            border-bottom: 1px solid #eee;
        }
        .order-number {
            font-weight: bold;
            color: #333;
        }
        .order-status {
            padding: 5px 12px;
            border-radius: 3px;
            font-size: 12px;
            font-weight: bold;
        }
        .status-pending {
            background-color: #fff3cd;
            color: #856404;
        }
        .status-paid {
            background-color: #d1ecf1;
            color: #0c5460;
        }
        .status-shipped {
            background-color: #d4edda;
            color: #155724;
        }
        .status-completed {
            background-color: #cce5ff;
            color: #004085;
        }
        .status-cancelled {
            background-color: #f8d7da;
            color: #721c24;
        }
        .order-items {
            margin: 15px 0;
        }
        .order-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 10px 0;
            border-bottom: 1px solid #f0f0f0;
        }
        .order-item:last-child {
            border-bottom: none;
        }
        .item-info {
            flex: 1;
        }
        .item-name {
            font-weight: bold;
            margin-bottom: 5px;
        }
        .item-qty {
            color: #666;
            font-size: 14px;
        }
        .item-price {
            color: #d9534f;
            font-size: 16px;
            font-weight: bold;
            min-width: 80px;
            text-align: right;
        }
        .order-footer {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding-top: 15px;
            border-top: 1px solid #eee;
        }
        .order-total {
            font-size: 18px;
            font-weight: bold;
        }
        .order-total .amount {
            color: #d9534f;
            font-size: 20px;
        }
        .order-actions {
            display: flex;
            gap: 10px;
        }
        .btn {
            padding: 8px 15px;
            border: none;
            border-radius: 3px;
            cursor: pointer;
            font-size: 14px;
            text-decoration: none;
            display: inline-block;
        }
        .btn-primary {
            background-color: #0275d8;
            color: white;
        }
        .btn-primary:hover {
            background-color: #025aa5;
        }
        .btn-secondary {
            background-color: #6c757d;
            color: white;
        }
        .btn-secondary:hover {
            background-color: #5a6268;
        }
        .btn-danger {
            background-color: #d9534f;
            color: white;
        }
        .btn-danger:hover {
            background-color: #c9302c;
        }
        .empty-state {
            text-align: center;
            padding: 50px;
            color: #666;
        }
        .alert {
            padding: 12px 20px;
            margin-bottom: 20px;
            border-radius: 4px;
        }
        .alert-success {
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }
    </style>
</head>
<body>
<jsp:include page="head/head.jsp"></jsp:include>

<div class="order-container">
    <div class="order-header">
        <h2>📦 我的订单</h2>
    </div>

    <%-- 成功提示 --%>
    <% if (request.getParameter("paid") != null) { %>
    <div class="alert alert-success">
        ✓ 支付成功！
    </div>
    <% } %>
    <% if (request.getParameter("confirmed") != null) { %>
    <div class="alert alert-success">
        ✓ 已确认收货
    </div>
    <% } %>
    <% if (request.getParameter("cancelled") != null) { %>
    <div class="alert alert-success">
        ✓ 订单已取消
    </div>
    <% } %>

    <%-- 订单状态筛选 --%>
    <div class="order-tabs">
        <a href="<%= request.getContextPath() %>/OrderServlet?key=list"
           class="<%= request.getParameter("status") == null ? "active" : "" %>">全部订单</a>
        <a href="<%= request.getContextPath() %>/OrderServlet?key=status&status=pending"
           class="<%= "pending".equals(request.getParameter("status")) ? "active" : "" %>">待支付</a>
        <a href="<%= request.getContextPath() %>/OrderServlet?key=status&status=paid"
           class="<%= "paid".equals(request.getParameter("status")) ? "active" : "" %>">待发货</a>
        <a href="<%= request.getContextPath() %>/OrderServlet?key=status&status=shipped"
           class="<%= "shipped".equals(request.getParameter("status")) ? "active" : "" %>">待收货</a>
        <a href="<%= request.getContextPath() %>/OrderServlet?key=status&status=completed"
           class="<%= "completed".equals(request.getParameter("status")) ? "active" : "" %>">已完成</a>
    </div>

    <%
        List<Order> orders = (List<Order>) request.getAttribute("orders");
        User user = (User) session.getAttribute("user");

        if (orders == null || orders.isEmpty()) {
    %>
    <div class="empty-state">
        <div style="font-size: 60px; margin-bottom: 20px;">📦</div>
        <h3>暂无订单</h3>
        <p>快去选购商品吧！</p>
        <a href="<%= request.getContextPath() %>/index.jsp" class="btn btn-primary">
            返回购物
        </a>
    </div>
    <%
    } else {
        for (Order order : orders) {
    %>
    <div class="order-card">
        <div class="order-card-header">
            <div>
                <div class="order-number">订单号：<%= order.getOrderNumber() %></div>
                <div style="color: #999; font-size: 12px; margin-top: 5px;"><%= order.getCreatedAt() %></div>
            </div>
            <div class="order-status <%= "status-" + order.getStatus() %>">
                <%= OrderService.getStatusDisplay(order.getStatus()) %>
            </div>
        </div>

        <%-- 订单项 --%>
        <div class="order-items">
            <%
                if (order.getItems() != null && !order.getItems().isEmpty()) {
                    int itemCount = order.getItems().size();
                    int displayCount = Math.min(itemCount, 2);

                    for (int i = 0; i < displayCount; i++) {
                        OrderItem item = order.getItems().get(i);
            %>
            <div class="order-item">
                <div class="item-info">
                    <div class="item-name"><%= item.getFruitName() %></div>
                    <div class="item-qty">数量：<%= item.getQuantity() %> × ¥<%= String.format("%.2f", item.getPrice()) %></div>
                </div>
                <div class="item-price">¥<%= String.format("%.2f", item.getSubtotal()) %></div>
            </div>
            <%
                }
                if (itemCount > 2) {
            %>
            <div class="order-item">
                <div class="item-info">
                    <div class="item-name">... 还有 <%= itemCount - 2 %> 件商品</div>
                </div>
            </div>
            <%
                    }
                }
            %>
        </div>

        <div class="order-footer">
            <div class="order-total">
                合计：<span class="amount">¥<%= String.format("%.2f", order.getTotalPrice()) %></span>
            </div>
            <div class="order-actions">
                <a href="<%= request.getContextPath() %>/OrderServlet?key=detail&orderId=<%= order.getId() %>"
                   class="btn btn-secondary">查看详情</a>
                <%
                    if ("pending".equals(order.getStatus())) {
                %>
                <a href="<%= request.getContextPath() %>/OrderServlet?key=pay&orderId=<%= order.getId() %>"
                   class="btn btn-primary" onclick="return confirm('确定要支付此订单？')">立即支付</a>
                <a href="<%= request.getContextPath() %>/OrderServlet?key=cancel&orderId=<%= order.getId() %>"
                   class="btn btn-danger" onclick="return confirm('确定要取消此订单？')">取消订单</a>
                <%
                    }
                    if ("shipped".equals(order.getStatus())) {
                %>
                <a href="<%= request.getContextPath() %>/OrderServlet?key=confirm&orderId=<%= order.getId() %>"
                   class="btn btn-primary">确认收货</a>
                <%
                    }
                %>
            </div>
        </div>
    </div>
    <%
            }
        }
    %>
</div>

<jsp:include page="footer/footer.jsp"></jsp:include>
</body>
</html>