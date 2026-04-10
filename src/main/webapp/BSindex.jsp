<%@ page import="com.fruitDayDB.vo.User" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%--
后台管理系统首页
管理员入口页面
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8" />
  <title>后台管理 - 天天果园</title>
  <link rel="stylesheet" type="text/css" href="css/main.css"/>
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
    .admin-logo img {
      max-width: 100%;
      height: auto;
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
    .admin-header h2 {
      margin: 0;
      color: #333;
    }
    .admin-user-info {
      display: flex;
      align-items: center;
      gap: 15px;
    }
    .admin-user-info a {
      color: #3498db;
      text-decoration: none;
    }
    .admin-body {
      flex: 1;
      padding: 30px;
      background-color: #ecf0f1;
    }
    .welcome-box {
      background-color: white;
      padding: 30px;
      border-radius: 5px;
      box-shadow: 0 2px 5px rgba(0,0,0,0.1);
      text-align: center;
    }
    .welcome-box h1 {
      color: #2c3e50;
      margin-top: 0;
    }
    .welcome-box p {
      color: #666;
      font-size: 16px;
    }
    .dashboard-grid {
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
      gap: 20px;
      margin-top: 30px;
    }
    .dashboard-card {
      background-color: white;
      padding: 20px;
      border-radius: 5px;
      box-shadow: 0 2px 5px rgba(0,0,0,0.1);
      text-align: center;
    }
    .dashboard-card h3 {
      margin-top: 0;
      color: #2c3e50;
    }
    .dashboard-card .number {
      font-size: 36px;
      font-weight: bold;
      color: #3498db;
      margin: 20px 0;
    }
    .dashboard-card a {
      display: inline-block;
      margin-top: 15px;
      padding: 10px 20px;
      background-color: #3498db;
      color: white;
      text-decoration: none;
      border-radius: 3px;
      transition: background-color 0.3s;
    }
    .dashboard-card a:hover {
      background-color: #2980b9;
    }
  </style>
</head>
<body>
<div class="admin-container">
  <%-- 左侧菜单 --%>
  <div class="admin-sidebar">
    <div class="admin-logo">
      <a href="<%= request.getContextPath() %>/index.jsp" style="color: white; text-decoration: none;">
        <h2>🍎 天天果园</h2>
      </a>
    </div>

    <ul class="admin-menu">
      <%-- 用户管理 --%>
      <li class="admin-menu-item">
                <span class="admin-menu-title" onclick="toggleMenu(this)">
                    👥 用户管理
                </span>
        <ul class="admin-submenu">
          <li><a href="<%= request.getContextPath() %>/BSServlet?key=alluser">查看所有用户</a></li>
          <li><a href="<%= request.getContextPath() %>/BSindex2.jsp">添加新用户</a></li>
        </ul>
      </li>

      <%-- 商品管理 --%>
      <li class="admin-menu-item">
                <span class="admin-menu-title" onclick="toggleMenu(this)">
                    🛒 商品管理
                </span>
        <ul class="admin-submenu">
          <li><a href="<%= request.getContextPath() %>/BSServlet?key=allfruit">查看所有商品</a></li>
          <li><a href="<%= request.getContextPath() %>/BSServlet?key=hotfruit">热卖商品管理</a></li>
          <li><a href="<%= request.getContextPath() %>/BSindex5.jsp">新增商品</a></li>
        </ul>
      </li>

      <%-- 订单管理 ⭐ 新增 --%>
      <li class="admin-menu-item">
                <span class="admin-menu-title" onclick="toggleMenu(this)">
                    📦 订单管理
                </span>
        <ul class="admin-submenu">
          <li><a href="<%= request.getContextPath() %>/admin/orders.jsp?status=all">全部订单</a></li>
          <li><a href="<%= request.getContextPath() %>/admin/orders.jsp?status=pending">待支付</a></li>
          <li><a href="<%= request.getContextPath() %>/admin/orders.jsp?status=paid">待发货</a></li>
          <li><a href="<%= request.getContextPath() %>/admin/orders.jsp?status=shipped">待收货</a></li>
        </ul>
      </li>

      <%-- 系统设置 --%>
      <li class="admin-menu-item">
                <span class="admin-menu-title" onclick="toggleMenu(this)">
                    ⚙️ 系统设置
                </span>
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
      <h2>后台管理系统</h2>
      <div class="admin-user-info">
        <%
          User user = (User) session.getAttribute("user");
          if (user != null) {
        %>
        <span>欢迎，<strong><%= user.getUname() %></strong></span>
        <%
          }
        %>
        <a href="<%= request.getContextPath() %>/UserServlet?key=logout">退出</a>
      </div>
    </div>

    <div class="admin-body">
      <div class="welcome-box">
        <h1>🎉 欢迎进入天天果园后台管理系统</h1>
        <p>在这里，您可以管理用户、商品、订单等系统资源</p>
      </div>

      <div class="dashboard-grid">
        <div class="dashboard-card">
          <h3>👥 用户管理</h3>
          <p>管理系统用户账户</p>
          <div class="number">-</div>
          <a href="<%= request.getContextPath() %>/BSServlet?key=alluser">进入</a>
        </div>

        <div class="dashboard-card">
          <h3>🛒 商品管理</h3>
          <p>管理商品信息及库存</p>
          <div class="number">-</div>
          <a href="<%= request.getContextPath() %>/BSServlet?key=allfruit">进入</a>
        </div>

        <div class="dashboard-card">
          <h3>📦 订单管理</h3>
          <p>查看和处理用户订单</p>
          <div class="number">-</div>
          <a href="<%= request.getContextPath() %>/admin/orders.jsp?status=all">进入</a>
        </div>
      </div>
    </div>
  </div>
</div>

<script>
  function toggleMenu(element) {
    const submenu = element.nextElementSibling;
    submenu.classList.toggle('show');
    element.classList.toggle('active');
  }
</script>
</body>
</html>