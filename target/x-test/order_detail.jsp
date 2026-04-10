<%@ page import="com.fruitDayDB.vo.Order" %>
<%@ page import="com.fruitDayDB.vo.OrderItem" %>
<%@ page import="com.fruitDayDB.vo.User" %>
<%@ page import="com.fruitDayDB.service.OrderService" %>
<%@ page import="java.util.List" %>
<%--
订单详情页面
显示单个订单的完整信息
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8" />
    <title>订单详情 - 天天果园</title>
    <link rel="stylesheet" type="text/css" href="css/main.css"/>
    <style>
        .detail-container {
            max-width: 900px;
            margin: 20px auto;
        }
        .detail-header {
            background-color: #f5f5f5;
            padding: 20px;
            margin-bottom: 20px;
            border-radius: 5px;
        }
        .detail-header h2 {
            margin: 0 0 15px 0;
        }
        .status-badge {
            display: inline-block;
            padding: 8px 15px;
            border-radius: 3px;
            font-weight: bold;
            font-size: 14px;
            margin: 10px 0;
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
        .detail-section {
            background-color: #fff;
            border: 1px solid #ddd;
            border-radius: 5px;
            padding: 20px;
            margin-bottom: 20px;
        }
        .section-title {
            font-size: 18px;
            font-weight: bold;
            margin-bottom: 15px;
            padding-bottom: 10px;
            border-bottom: 2px solid #f0f0f0;
        }
        .info-row {
            display: flex;
            justify-content: space-between;
            padding: 10px 0;
            border-bottom: 1px solid #f0f0f0;
        }
        .info-row:last-child {
            border-bottom: none;
        }
        .info-label {
            color: #666;
            min-width: 150px;
        }
        .info-value {
            font-weight: bold;
            color: #333;
        }
        .order-items-table {
            width: 100%;
            border-collapse: collapse;
        }
        .order-items-table th {
            background-color: #f0f0f0;
            padding: 10px;
            text-align: left;
            border-bottom: 2px solid #ddd;
        }
        .order-items-table td {
            padding: 15px 10px;
            border-bottom: 1px solid #eee;
        }
        .item-total {
            font-weight: bold;
            color: #d9534f;
            font-size: 18px;
        }
        .detail-actions {
            display: flex;
            gap: 10px;
            margin-top: 20px;
        }
        .btn {
            padding: 10px 20px;
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

<div class="detail-container">
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

    <%
        Order order = (Order) request.getAttribute("order");
        String statusDisplay = (String) request.getAttribute("statusDisplay");
        User user = (User) session.getAttribute("user");

        if (order == null) {
    %>
    <div class="detail-header">
        <h2>订单不存在</h2>
        <p><a href="<%= request.getContextPath() %>/OrderServlet?key=list">返回订单列表</a></p>
    </div>
    <%
    } else {
    %>
    <div class="detail-header">
        <h2>📦 订单详情</h2>
        <div class="status-badge <%= "status-" + order.getStatus() %>">
            <%= statusDisplay %>
        </div>
    </div>

    <%-- 订单基本信息 --%>
    <div class="detail-section">
        <div class="section-title">订单信息</div>
        <div class="info-row">
            <div class="info-label">订单号：</div>
            <div class="info-value"><%= order.getOrderNumber() %></div>
        </div>
        <div class="info-row">
            <div class="info-label">订单状态：</div>
            <div class="info-value"><%= statusDisplay %></div>
        </div>
        <div class="info-row">
            <div class="info-label">创建时间：</div>
            <div class="info-value"><%= order.getCreatedAt() %></div>
        </div>
        <%
            if (order.getPaidAt() != null && !order.getPaidAt().isEmpty()) {
        %>
        <div class="info-row">
            <div class="info-label">支付时间：</div>
            <div class="info-value"><%= order.getPaidAt() %></div>
        </div>
        <%
            }
            if (order.getShippedAt() != null && !order.getShippedAt().isEmpty()) {
        %>
        <div class="info-row">
            <div class="info-label">发货时间：</div>
            <div class="info-value"><%= order.getShippedAt() %></div>
        </div>
        <%
            }
            if (order.getCompletedAt() != null && !order.getCompletedAt().isEmpty()) {
        %>
        <div class="info-row">
            <div class="info-label">完成时间：</div>
            <div class="info-value"><%= order.getCompletedAt() %></div>
        </div>
        <%
            }
        %>
    </div>

    <%-- 订单商品 --%>
    <div class="detail-section">
        <div class="section-title">商品清单</div>
        <table class="order-items-table">
            <thead>
            <tr>
                <th>商品名称</th>
                <th>单价</th>
                <th>数量</th>
                <th>小计</th>
            </tr>
            </thead>
            <tbody>
            <%
                if (order.getItems() != null && !order.getItems().isEmpty()) {
                    for (OrderItem item : order.getItems()) {
            %>
            <tr>
                <td><%= item.getFruitName() %></td>
                <td>¥<%= String.format("%.2f", item.getPrice()) %></td>
                <td><%= item.getQuantity() %></td>
                <td class="item-total">¥<%= String.format("%.2f", item.getSubtotal()) %></td>
            </tr>
            <%
                    }
                }
            %>
            </tbody>
        </table>
    </div>

    <%-- 订单总计 --%>
    <div class="detail-section">
        <div style="text-align: right;">
            <div style="font-size: 18px; margin: 20px 0;">
                订单合计：<span style="color: #d9534f; font-size: 28px; font-weight: bold;">
                    ¥<%= String.format("%.2f", order.getTotalPrice()) %>
                </span>
            </div>
        </div>
    </div>

    <%-- 操作按钮 --%>
    <div class="detail-actions">
        <a href="<%= request.getContextPath() %>/OrderServlet?key=list" class="btn btn-secondary">
            返回订单列表
        </a>
        <%
            if ("pending".equals(order.getStatus())) {
        %>
        <a href="<%= request.getContextPath() %>/OrderServlet?key=pay&orderId=<%= order.getId() %>"
           class="btn btn-primary" onclick="return confirm('确定要支付此订单？')">
            立即支付
        </a>
        <a href="<%= request.getContextPath() %>/OrderServlet?key=cancel&orderId=<%= order.getId() %>"
           class="btn btn-danger" onclick="return confirm('确定要取消此订单？')">
            取消订单
        </a>
        <%
            }
            if ("shipped".equals(order.getStatus())) {
        %>
        <a href="<%= request.getContextPath() %>/OrderServlet?key=confirm&orderId=<%= order.getId() %>"
           class="btn btn-primary">
            确认收货
        </a>
        <%
            }
        %>
    </div>
    <%
        }
    %>
</div>

<jsp:include page="footer/footer.jsp"></jsp:include>
</body>
</html>