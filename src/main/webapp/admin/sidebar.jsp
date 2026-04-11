<%@ page import="com.fruitDayDB.vo.User" %>
<%--
  管理员公共侧边栏组件
  使用方式：<jsp:include page="/admin/sidebar.jsp"><jsp:param name="active" value="users"/></jsp:include>
  active 参数可选值：home, users, fruits, orders
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // 管理员鉴权
    User adminUser = (User) session.getAttribute("user");
    if (adminUser == null || !adminUser.isAdmin()) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    String active = request.getParameter("active");
    if (active == null) active = "";
%>
<style>
    * { box-sizing: border-box; }
    body { margin: 0; padding: 0; font-family: "Microsoft YaHei", Arial, sans-serif; background-color: #ecf0f1; }
    .admin-wrap { display: flex; min-height: 100vh; }
    .admin-sidebar { width: 240px; background: #2c3e50; color: #ecf0f1; flex-shrink: 0; display: flex; flex-direction: column; }
    .sidebar-logo { padding: 20px; text-align: center; border-bottom: 1px solid #34495e; }
    .sidebar-logo a { color: #fff; text-decoration: none; font-size: 20px; font-weight: bold; }
    .sidebar-user { padding: 12px 20px; font-size: 13px; color: #bdc3c7; border-bottom: 1px solid #34495e; }
    .sidebar-nav { list-style: none; margin: 0; padding: 10px 0; flex: 1; }
    .sidebar-nav li a { display: block; padding: 11px 22px; color: #bdc3c7; text-decoration: none; font-size: 14px; transition: background 0.2s, color 0.2s; border-left: 3px solid transparent; }
    .sidebar-nav li a:hover { background: #34495e; color: #fff; }
    .sidebar-nav li a.active { background: #3498db; color: #fff; border-left-color: #2980b9; }
    .sidebar-nav .nav-section { padding: 18px 22px 6px; font-size: 11px; color: #7f8c8d; text-transform: uppercase; letter-spacing: 1px; }
    .sidebar-footer { padding: 14px 22px; border-top: 1px solid #34495e; }
    .sidebar-footer a { color: #e74c3c; text-decoration: none; font-size: 13px; }
    .admin-main { flex: 1; display: flex; flex-direction: column; min-width: 0; }
    .admin-topbar { background: #fff; padding: 14px 24px; border-bottom: 1px solid #ddd; display: flex; justify-content: space-between; align-items: center; box-shadow: 0 1px 4px rgba(0,0,0,0.06); }
    .admin-topbar h2 { margin: 0; font-size: 18px; color: #2c3e50; }
    .admin-body { flex: 1; padding: 24px; background: #ecf0f1; overflow-y: auto; }
    .card { background: #fff; border-radius: 6px; box-shadow: 0 2px 8px rgba(0,0,0,0.07); padding: 20px; margin-bottom: 20px; }
    .card-title { font-size: 16px; font-weight: bold; color: #2c3e50; margin: 0 0 16px 0; }
    table { width: 100%; border-collapse: collapse; }
    table th { background: #f8f9fa; padding: 12px 15px; text-align: left; border-bottom: 2px solid #dee2e6; font-size: 13px; color: #495057; }
    table td { padding: 12px 15px; border-bottom: 1px solid #f0f0f0; font-size: 13px; }
    table tr:hover td { background: #f8f9fb; }
    .btn { display: inline-block; padding: 6px 14px; border: none; border-radius: 4px; cursor: pointer; font-size: 13px; text-decoration: none; transition: background 0.2s; }
    .btn-primary { background: #3498db; color: #fff; }
    .btn-primary:hover { background: #2980b9; color: #fff; }
    .btn-success { background: #27ae60; color: #fff; }
    .btn-success:hover { background: #219a52; color: #fff; }
    .btn-warning { background: #f39c12; color: #fff; }
    .btn-warning:hover { background: #d68910; color: #fff; }
    .btn-danger { background: #e74c3c; color: #fff; }
    .btn-danger:hover { background: #c0392b; color: #fff; }
    .btn-secondary { background: #6c757d; color: #fff; }
    .btn-secondary:hover { background: #5a6268; color: #fff; }
    .form-group { margin-bottom: 18px; }
    .form-group label { display: block; margin-bottom: 6px; font-size: 13px; color: #495057; font-weight: 600; }
    .form-control { width: 100%; padding: 8px 12px; border: 1px solid #ced4da; border-radius: 4px; font-size: 14px; color: #495057; transition: border-color 0.2s; }
    .form-control:focus { outline: none; border-color: #3498db; box-shadow: 0 0 0 2px rgba(52,152,219,0.15); }
    .alert { padding: 12px 18px; border-radius: 4px; margin-bottom: 18px; font-size: 14px; }
    .alert-success { background: #d4edda; color: #155724; border: 1px solid #c3e6cb; }
    .alert-danger { background: #f8d7da; color: #721c24; border: 1px solid #f5c6cb; }
    .badge { display: inline-block; padding: 3px 8px; border-radius: 10px; font-size: 11px; font-weight: bold; }
    .badge-warning { background: #fff3cd; color: #856404; }
    .badge-info { background: #d1ecf1; color: #0c5460; }
    .badge-success { background: #d4edda; color: #155724; }
    .badge-primary { background: #cce5ff; color: #004085; }
    .badge-secondary { background: #e2e3e5; color: #383d41; }
    .badge-danger { background: #f8d7da; color: #721c24; }
</style>

<div class="admin-wrap">
<div class="admin-sidebar">
    <div class="sidebar-logo">
        <a href="<%= request.getContextPath() %>/BSindex.jsp">🍎 天天果园后台</a>
    </div>
    <div class="sidebar-user">管理员：<%= adminUser.getUname() %></div>
    <ul class="sidebar-nav">
        <li><span class="nav-section">控制台</span></li>
        <li><a href="<%= request.getContextPath() %>/BSindex.jsp" class="<%= "home".equals(active) ? "active" : "" %>">📊 仪表盘</a></li>

        <li><span class="nav-section">用户管理</span></li>
        <li><a href="<%= request.getContextPath() %>/BSServlet?key=alluser" class="<%= "users".equals(active) ? "active" : "" %>">👥 用户列表</a></li>
        <li><a href="<%= request.getContextPath() %>/BSindex2.jsp">➕ 添加用户</a></li>

        <li><span class="nav-section">商品管理</span></li>
        <li><a href="<%= request.getContextPath() %>/BSServlet?key=allfruit" class="<%= "fruits".equals(active) ? "active" : "" %>">🍎 商品列表</a></li>
        <li><a href="<%= request.getContextPath() %>/BSindex5.jsp">➕ 新增商品</a></li>

        <li><span class="nav-section">订单管理</span></li>
        <li><a href="<%= request.getContextPath() %>/AdminServlet?key=orders" class="<%= "orders".equals(active) ? "active" : "" %>">📦 所有订单</a></li>
        <li><a href="<%= request.getContextPath() %>/AdminServlet?key=orders&status=pending">⏳ 待支付</a></li>
        <li><a href="<%= request.getContextPath() %>/AdminServlet?key=orders&status=paid">🚚 待发货</a></li>
        <li><a href="<%= request.getContextPath() %>/AdminServlet?key=orders&status=shipped">📬 运输中</a></li>
    </ul>
    <div class="sidebar-footer">
        <a href="<%= request.getContextPath() %>/index.jsp">↩ 返回前台</a>
        &nbsp;|&nbsp;
        <a href="<%= request.getContextPath() %>/UserServlet?key=logout">退出</a>
    </div>
</div>
