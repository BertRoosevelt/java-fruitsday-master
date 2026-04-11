<%@ page import="java.util.List" %>
<%@ page import="com.fruitDayDB.vo.Order" %>
<%@ page import="com.fruitDayDB.vo.User" %>
<%@ page import="com.fruitDayDB.service.OrderService" %>
<%--
后台订单管理页面（通过 AdminServlet 转发过来）
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    User adminUser = (User) session.getAttribute("user");
    if (adminUser == null || !adminUser.isAdmin()) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    // 数据由 AdminServlet 填充到 request attribute "orders"
    List<Order> orders = (List<Order>) request.getAttribute("orders");
    String filterStatus = (String) request.getAttribute("filterStatus");
    if (orders == null) {
        // 直接访问时自动加载所有订单
        orders = OrderService.getAllOrders();
        filterStatus = null;
    }
%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8"/>
  <title>订单管理 - 天天果园后台</title>
</head>
<body>
<jsp:include page="sidebar.jsp"><jsp:param name="active" value="orders"/></jsp:include>

<div class="admin-main">
  <div class="admin-topbar">
    <h2>📦 订单管理</h2>
    <span style="font-size:13px; color:#7f8c8d;">共 <%= orders.size() %> 笔订单</span>
  </div>
  <div class="admin-body">

    <%-- 状态筛选 --%>
    <div style="display:flex; gap:8px; margin-bottom:18px; flex-wrap:wrap;">
      <a href="<%= request.getContextPath() %>/AdminServlet?key=orders"
         class="btn <%= filterStatus == null ? "btn-primary" : "btn-secondary" %>">全部</a>
      <a href="<%= request.getContextPath() %>/AdminServlet?key=orders&status=pending"
         class="btn <%= "pending".equals(filterStatus) ? "btn-primary" : "btn-secondary" %>">⏳ 待支付</a>
      <a href="<%= request.getContextPath() %>/AdminServlet?key=orders&status=paid"
         class="btn <%= "paid".equals(filterStatus) ? "btn-primary" : "btn-secondary" %>">🚚 待发货</a>
      <a href="<%= request.getContextPath() %>/AdminServlet?key=orders&status=shipped"
         class="btn <%= "shipped".equals(filterStatus) ? "btn-primary" : "btn-secondary" %>">📬 运输中</a>
      <a href="<%= request.getContextPath() %>/AdminServlet?key=orders&status=completed"
         class="btn <%= "completed".equals(filterStatus) ? "btn-primary" : "btn-secondary" %>">✅ 已完成</a>
      <a href="<%= request.getContextPath() %>/AdminServlet?key=orders&status=cancelled"
         class="btn <%= "cancelled".equals(filterStatus) ? "btn-primary" : "btn-secondary" %>">❌ 已取消</a>
    </div>

    <div class="card">
      <table>
        <thead>
        <tr>
          <th>订单号</th>
          <th>用户ID</th>
          <th>金额（元）</th>
          <th>状态</th>
          <th>下单时间</th>
          <th>操作</th>
        </tr>
        </thead>
        <tbody>
        <%
          if (orders.isEmpty()) {
        %>
        <tr><td colspan="6" style="text-align:center; padding:30px; color:#7f8c8d;">暂无订单数据</td></tr>
        <%
          } else {
            for (Order order : orders) {
              String statusClass = "badge-secondary";
              if ("pending".equals(order.getStatus())) statusClass = "badge-warning";
              else if ("paid".equals(order.getStatus())) statusClass = "badge-info";
              else if ("shipped".equals(order.getStatus())) statusClass = "badge-success";
              else if ("completed".equals(order.getStatus())) statusClass = "badge-primary";
              else if ("cancelled".equals(order.getStatus())) statusClass = "badge-danger";
        %>
        <tr>
          <td><strong style="color:#3498db; font-size:12px;"><%= order.getOrderNumber() %></strong></td>
          <td><%= order.getUserId() %></td>
          <td style="color:#e74c3c; font-weight:bold;">¥<%= String.format("%.2f", order.getTotalPrice()) %></td>
          <td><span class="badge <%= statusClass %>"><%= OrderService.getStatusDisplay(order.getStatus()) %></span></td>
          <td style="font-size:12px; color:#7f8c8d;"><%= order.getCreatedAt() %></td>
          <td>
            <a href="<%= request.getContextPath() %>/AdminServlet?key=orderDetail&orderId=<%= order.getId() %>"
               class="btn btn-secondary">详情</a>
            <% if ("paid".equals(order.getStatus())) { %>
            <a href="<%= request.getContextPath() %>/AdminServlet?key=ship&orderId=<%= order.getId() %>"
               class="btn btn-success"
               onclick="return confirm('确定为该订单标记发货？')">🚚 发货</a>
            <% } %>
          </td>
        </tr>
        <%
            }
          }
        %>
        </tbody>
      </table>
    </div>
  </div>
</div>
</div>
</body>
</html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8" />
    <title>订单管理 - 天天果园后台</title>
    <link rel="stylesheet" type="text/css" href="../css/main.css"/>
    <style>
        body {
            margin: 0;
            padding: 0;
        }
        .admin-container {
            display: flex;
            min-height: 100vh;
        }
        .admin-sidebar {
            width: 250px;
            background-color: #2c3e50;
            color: white;
            padding: 0;
        }
        .admin-logo {
            padding: 20px;
            text-align: center;
            border-bottom: 1px solid #34495e;
        }
        .admin-logo a {
            color: white;
            text-decoration: none;
        }
        .admin-menu {
            list-style: none;
            padding: 0;
            margin: 0;
        }
        .admin-menu-item {
            border-bottom: 1px solid #34495e;
        }
        .admin-menu-title {
            display: block;
            padding: 15px 20px;
            cursor: pointer;
            user-select: none;
            transition: background-color 0.3s;
            color: white;
        }
        .admin-menu-title:hover {
            background-color: #34495e;
        }
        .admin-menu-title.active {
            background-color: #3498db;
        }
        .admin-submenu {
            list-style: none;
            padding: 0;
            margin: 0;
            display: none;
            background-color: #34495e;
        }
        .admin-submenu.show {
            display: block;
        }
        .admin-submenu li a {
            display: block;
            padding: 10px 40px;
            color: #ecf0f1;
            text-decoration: none;
            transition: background-color 0.3s;
        }
        .admin-submenu li a:hover {
            background-color: #2c3e50;
        }
        .admin-content {
            flex: 1;
            display: flex;
            flex-direction: column;
        }
        .admin-header {
            background-color: #f8f9fa;
            padding: 20px;
            border-bottom: 1px solid #ddd;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .admin-body {
            flex: 1;
            padding: 20px;
            background-color: #ecf0f1;
            overflow-y: auto;
        }
        .page-title {
            margin-top: 0;
            color: #333;
        }
        .filter-bar {
            background-color: white;
            padding: 15px;
            margin-bottom: 20px;
            border-radius: 5px;
            display: flex;
            gap: 10px;
            align-items: center;
        }
        .filter-bar a {
            padding: 8px 15px;
            background-color: #ecf0f1;
            color: #333;
            text-decoration: none;
            border-radius: 3px;
            transition: background-color 0.3s;
        }
        .filter-bar a.active {
            background-color: #3498db;
            color: white;
        }
        .filter-bar a:hover {
            background-color: #3498db;
            color: white;
        }
        .orders-table {
            background-color: white;
            border-radius: 5px;
            overflow: hidden;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }
        table {
            width: 100%;
            border-collapse: collapse;
        }
        th {
            background-color: #f8f9fa;
            padding: 15px;
            text-align: left;
            border-bottom: 2px solid #ddd;
            font-weight: bold;
            color: #333;
        }
        td {
            padding: 15px;
            border-bottom: 1px solid #eee;
        }
        tr:hover {
            background-color: #f9f9f9;
        }
        .order-id {
            color: #3498db;
            font-weight: bold;
        }
        .status-badge {
            display: inline-block;
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
        .action-buttons {
            display: flex;
            gap: 5px;
        }
        .btn {
            padding: 6px 12px;
            border: none;
            border-radius: 3px;
            cursor: pointer;
            font-size: 12px;
            text-decoration: none;
            display: inline-block;
        }
        .btn-info {
            background-color: #17a2b8;
            color: white;
        }
        .btn-info:hover {
            background-color: #138496;
        }
        .btn-success {
            background-color: #28a745;
            color: white;
        }
        .btn-success:hover {
            background-color: #218838;
        }
        .btn-warning {
            background-color: #ffc107;
            color: #333;
        }
        .btn-warning:hover {
            background-color: #e0a800;
        }
        .empty-state {
            text-align: center;
            padding: 50px;
            color: #666;
        }
    </style>
</head>
<body>
<div class="admin-container">
    <%-- 左侧菜单 --%>
    <div class="admin-sidebar">
        <div class="admin-logo">
            <a href="<%= request.getContextPath() %>/BSindex.jsp">
                <h2>🍎 天天果园</h2>
            </a>
        </div>

        <ul class="admin-menu">
            <li class="admin-menu-item">
                <span class="admin-menu-title" onclick="toggleMenu(this)">👥 用户管理</span>
                <ul class="admin-submenu">
                    <li><a href="<%= request.getContextPath() %>/BSServlet?key=alluser">查看所有用户</a></li>
                    <li><a href="<%= request.getContextPath() %>/BSindex2.jsp">添加新用户</a></li>
                </ul>
            </li>

            <li class="admin-menu-item">
                <span class="admin-menu-title" onclick="toggleMenu(this)">🛒 商品管理</span>
                <ul class="admin-submenu">
                    <li><a href="<%= request.getContextPath() %>/BSServlet?key=allfruit">查看所有商品</a></li>
                    <li><a href="<%= request.getContextPath() %>/BSServlet?key=hotfruit">热卖商品管理</a></li>
                    <li><a href="<%= request.getContextPath() %>/BSindex5.jsp">新增商品</a></li>
                </ul>
            </li>

            <li class="admin-menu-item">
                <span class="admin-menu-title active" onclick="toggleMenu(this)">📦 订单管理</span>
                <ul class="admin-submenu show">
                    <li><a href="<%= request.getContextPath() %>/admin/orders.jsp?status=all">全部订单</a></li>
                    <li><a href="<%= request.getContextPath() %>/admin/orders.jsp?status=pending">待支付</a></li>
                    <li><a href="<%= request.getContextPath() %>/admin/orders.jsp?status=paid">待发货</a></li>
                    <li><a href="<%= request.getContextPath() %>/admin/orders.jsp?status=shipped">待收货</a></li>
                </ul>
            </li>

            <li class="admin-menu-item">
                <span class="admin-menu-title" onclick="toggleMenu(this)">⚙️ 系统设置</span>
                <ul class="admin-submenu">
                    <li><a href="<%= request.getContextPath() %>/index.jsp">返回首页</a></li>
                    <li><a href="<%= request.getContextPath() %>/UserServlet?key=logout">退出登录</a></li>
                </ul>
            </li>
        </ul>
    </div>

    <%-- 右侧内容 --%>
    <div class="admin-content">
        <div class="admin-header">
            <h2>订单管理</h2>
            <div>
                <a href="<%= request.getContextPath() %>/UserServlet?key=logout" style="color: #3498db; text-decoration: none;">退出</a>
            </div>
        </div>

        <div class="admin-body">
            <h3 class="page-title">📦 订单列表</h3>

            <%-- 筛选条件 --%>
            <div class="filter-bar">
                <a href="<%= request.getContextPath() %>/admin/orders.jsp?status=all"
                   class="<%= "all".equals(request.getParameter("status")) || request.getParameter("status") == null ? "active" : "" %>">
                    全部订单
                </a>
                <a href="<%= request.getContextPath() %>/admin/orders.jsp?status=pending"
                   class="<%= "pending".equals(request.getParameter("status")) ? "active" : "" %>">
                    待支付
                </a>
                <a href="<%= request.getContextPath() %>/admin/orders.jsp?status=paid"
                   class="<%= "paid".equals(request.getParameter("status")) ? "active" : "" %>">
                    待发货
                </a>
                <a href="<%= request.getContextPath() %>/admin/orders.jsp?status=shipped"
                   class="<%= "shipped".equals(request.getParameter("status")) ? "active" : "" %>">
                    待收货
                </a>
            </div>

            <%
                String statusFilter = request.getParameter("status");
                if (statusFilter == null || "all".equals(statusFilter)) {
                    statusFilter = null;
                }

                OrderDao orderDao = new OrderDaoImpl();
                List<Order> orders = null;

                if (statusFilter == null) {
                    // 获取所有订单（这需要在 OrderDao 中添加方法）
                    // 暂时用以下实现
                    orders = new java.util.ArrayList<>();
                } else {
                    // 按状态查询订单（需要在 DAO 中实现）
                    orders = new java.util.ArrayList<>();
                }
            %>

            <div class="orders-table">
                <table>
                    <thead>
                    <tr>
                        <th>订单号</th>
                        <th>用户ID</th>
                        <th>订单金额</th>
                        <th>订单状态</th>
                        <th>创建时间</th>
                        <th>操作</th>
                    </tr>
                    </thead>
                    <tbody>
                    <%
                        if (orders == null || orders.isEmpty()) {
                    %>
                    <tr>
                        <td colspan="6" class="empty-state">
                            暂无订单数据
                        </td>
                    </tr>
                    <%
                    } else {
                        for (Order order : orders) {
                    %>
                    <tr>
                        <td class="order-id"><%= order.getOrderNumber() %></td>
                        <td><%= order.getUserId() %></td>
                        <td>¥<%= String.format("%.2f", order.getTotalPrice()) %></td>
                        <td>
                                <span class="status-badge <%= "status-" + order.getStatus() %>">
                                    <%= OrderService.getStatusDisplay(order.getStatus()) %>
                                </span>
                        </td>
                        <td><%= order.getCreatedAt() %></td>
                        <td>
                            <div class="action-buttons">
                                <a href="<%= request.getContextPath() %>/admin/order_detail.jsp?orderId=<%= order.getId() %>"
                                   class="btn btn-info">查看</a>
                                <%
                                    if ("pending".equals(order.getStatus())) {
                                %>
                                <a href="<%= request.getContextPath() %>/admin/ship_order.jsp?orderId=<%= order.getId() %>"
                                   class="btn btn-success">发货</a>
                                <%
                                    }
                                    if ("paid".equals(order.getStatus())) {
                                %>
                                <a href="<%= request.getContextPath() %>/admin/ship_order.jsp?orderId=<%= order.getId() %>"
                                   class="btn btn-warning">标记发货</a>
                                <%
                                    }
                                %>
                            </div>
                        </td>
                    </tr>
                    <%
                            }
                        }
                    %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

<script>
    function toggleMenu(element) {
        const submenu = element.nextElementSibling;
        if (submenu) {
            submenu.classList.toggle('show');
            element.classList.toggle('active');
        }
    }
</script>
</body>
</html>