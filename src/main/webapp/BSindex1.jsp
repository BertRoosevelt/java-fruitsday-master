<%@ page import="com.fruitDayDB.vo.User" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%--
后台用户管理页面
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8" />
  <title>用户管理 - 天天果园后台</title>
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
    .users-table {
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
    .btn-edit {
      background-color: #3498db;
      color: white;
    }
    .btn-edit:hover {
      background-color: #2980b9;
    }
    .btn-delete {
      background-color: #e74c3c;
      color: white;
    }
    .btn-delete:hover {
      background-color: #c0392b;
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
        <span class="admin-menu-title active" onclick="toggleMenu(this)">👥 用户管理</span>
        <ul class="admin-submenu show">
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
        <span class="admin-menu-title" onclick="toggleMenu(this)">📦 订单管理</span>
        <ul class="admin-submenu">
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
      <h2>用户管理</h2>
      <div>
        <a href="<%= request.getContextPath() %>/UserServlet?key=logout" style="color: #3498db; text-decoration: none;">退出</a>
      </div>
    </div>

    <div class="admin-body">
      <h3 class="page-title">👥 用户列表</h3>

      <div class="users-table">
        <table>
          <thead>
          <tr>
            <th>用户ID</th>
            <th>用户名</th>
            <th>邮箱</th>
            <th>手机</th>
            <th>操作</th>
          </tr>
          </thead>
          <tbody>
          <%
            List<User> users = new ArrayList<User>();
            if (request.getAttribute("allusers") != null) {
              users = (List<User>) request.getAttribute("allusers");

              for (User user : users) {
          %>
          <tr>
            <td><%= user.getId() %></td>
            <td><%= user.getUname() %></td>
            <td><%= user.getEmail() %></td>
            <td><%= user.getPhone() %></td>
            <td>
              <div class="action-buttons">
                <a href="<%= request.getContextPath() %>/BSServlet?key=finduser&id=<%= user.getId() %>"
                   class="btn btn-edit">编辑</a>
                <a href="<%= request.getContextPath() %>/BSServlet?key=deluser&id=<%= user.getId() %>"
                   class="btn btn-delete" onclick="return confirm('确定要删除此用户？')">删除</a>
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