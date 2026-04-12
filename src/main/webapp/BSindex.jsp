<%@ page import="com.fruitDayDB.vo.User" %>
<%@ page import="java.util.List" %>
<%@ page import="com.fruitDayDB.service.UserService" %>
<%@ page import="com.fruitDayDB.service.FruitService" %>
<%@ page import="com.fruitDayDB.service.OrderService" %>
<%--
后台管理系统首页（仪表盘）
管理员入口页面
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    User adminUser = (User) session.getAttribute("user");
    if (adminUser == null || !adminUser.isAdmin()) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    int userCount = UserService.alluser().size();
    int fruitCount = FruitService.all().size();
    int orderCount = OrderService.getAllOrders().size();
    int pendingShipCount = OrderService.getAllOrdersByStatus("paid").size();
%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8" />
  <title>后台管理 - 水果超市管理系统</title>
</head>
<body>
<jsp:include page="admin/sidebar.jsp"><jsp:param name="active" value="home"/></jsp:include>

<div class="admin-main">
  <div class="admin-topbar">
    <h2>📊 仪表盘</h2>
    <span style="color:#7f8c8d; font-size:14px;">欢迎回来，<strong><%= adminUser.getUname() %></strong></span>
  </div>
  <div class="admin-body">
    <div style="display:grid; grid-template-columns: repeat(auto-fit, minmax(200px,1fr)); gap:18px; margin-bottom:24px;">
      <div class="card" style="text-align:center;">
        <div style="font-size:36px; color:#3498db; font-weight:bold; margin:10px 0;"><%= userCount %></div>
        <div style="color:#7f8c8d; font-size:14px;">👥 注册用户</div>
        <a href="<%= request.getContextPath() %>/BSServlet?key=alluser" class="btn btn-primary" style="margin-top:14px;">管理用户</a>
      </div>
      <div class="card" style="text-align:center;">
        <div style="font-size:36px; color:#27ae60; font-weight:bold; margin:10px 0;"><%= fruitCount %></div>
        <div style="color:#7f8c8d; font-size:14px;">🍎 在售商品</div>
        <a href="<%= request.getContextPath() %>/BSServlet?key=allfruit" class="btn btn-success" style="margin-top:14px;">管理商品</a>
      </div>
      <div class="card" style="text-align:center;">
        <div style="font-size:36px; color:#f39c12; font-weight:bold; margin:10px 0;"><%= orderCount %></div>
        <div style="color:#7f8c8d; font-size:14px;">📦 全部订单</div>
        <a href="<%= request.getContextPath() %>/AdminServlet?key=orders" class="btn btn-warning" style="margin-top:14px;">查看订单</a>
      </div>
      <div class="card" style="text-align:center;">
        <div style="font-size:36px; color:#e74c3c; font-weight:bold; margin:10px 0;"><%= pendingShipCount %></div>
        <div style="color:#7f8c8d; font-size:14px;">🚚 待发货订单</div>
        <a href="<%= request.getContextPath() %>/AdminServlet?key=orders&status=paid" class="btn btn-danger" style="margin-top:14px;">立即处理</a>
      </div>
    </div>

    <div class="card">
      <div class="card-title">⚡ 快捷操作</div>
      <div style="display:flex; gap:12px; flex-wrap:wrap;">
        <a href="<%= request.getContextPath() %>/BSServlet?key=alluser" class="btn btn-primary">👥 用户列表</a>
        <a href="<%= request.getContextPath() %>/BSindex2.jsp" class="btn btn-primary">➕ 添加用户</a>
        <a href="<%= request.getContextPath() %>/BSServlet?key=allfruit" class="btn btn-success">🍎 商品列表</a>
        <a href="<%= request.getContextPath() %>/BSindex5.jsp" class="btn btn-success">➕ 新增商品</a>
        <a href="<%= request.getContextPath() %>/AdminServlet?key=orders" class="btn btn-warning">📦 订单管理</a>
        <a href="<%= request.getContextPath() %>/index.jsp" class="btn btn-secondary">↩ 前台首页</a>
      </div>
    </div>
  </div>
</div>
</div>
</body>
</html>
