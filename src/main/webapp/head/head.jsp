<%@ page import="com.fruitDayDB.vo.User" %>
<%--
页面头部导航栏
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<header class="header">
  <div class="header-container">
    <div class="logo">
      <a href="<%= request.getContextPath() %>/index.jsp">
        <h1>🍎 天天果园</h1>
      </a>
    </div>

    <div class="header-search">
      <form method="GET" action="<%= request.getContextPath() %>/SELServlet" style="display:flex; gap:6px;">
        <input type="hidden" name="key" value="search"/>
        <input type="text" name="keyword" placeholder="搜索水果..." style="padding:6px 10px; border:1px solid #aaa; border-radius:4px; font-size:13px; background:rgba(255,255,255,0.9); color:#333;"/>
        <button type="submit" style="padding:6px 12px; background:#f0ad4e; color:#fff; border:none; border-radius:4px; cursor:pointer; font-size:13px;">🔍</button>
      </form>
    </div>

    <div class="header-menu">
      <a href="<%= request.getContextPath() %>/index.jsp">首页</a>
      <a href="<%= request.getContextPath() %>/SELServlet?key=hot">热卖商品</a>
      <a href="<%= request.getContextPath() %>/SELServlet">全部商品</a>
      <%
        User user = (User) session.getAttribute("user");
        if (user != null) {
      %>
      <a href="<%= request.getContextPath() %>/showstar.jsp">我的收藏</a>
      <a href="<%= request.getContextPath() %>/showcart.jsp">购物车</a>
      <a href="<%= request.getContextPath() %>/OrderServlet?key=list">我的订单</a>
      <div class="user-dropdown">
        <a href="<%= request.getContextPath() %>/UserServlet?key=center" class="user-dropdown-toggle">
          欢迎，<strong><%= user.getUname() %></strong>
        </a>
        <div class="user-dropdown-menu">
          <a href="<%= request.getContextPath() %>/UserServlet?key=center&tab=info">个人信息记录</a>
          <a href="<%= request.getContextPath() %>/UserServlet?key=center&tab=payments">支付记录</a>
          <a href="<%= request.getContextPath() %>/UserServlet?key=center&tab=favorites">收藏商品</a>
          <a href="<%= request.getContextPath() %>/UserServlet?key=center&tab=address">收货地址管理</a>
          <a href="<%= request.getContextPath() %>/UserServlet?key=center&tab=password">修改密码</a>
        </div>
      </div>
      <% if (user.isAdmin()) { %>
      <a href="<%= request.getContextPath() %>/BSindex.jsp" class="admin-link">⚙ 管理后台</a>
      <% } %>
      <a href="<%= request.getContextPath() %>/UserServlet?key=logout">退出登录</a>
      <%
      } else {
      %>
      <a href="<%= request.getContextPath() %>/login.jsp">登录</a>
      <a href="<%= request.getContextPath() %>/reg.jsp">注册</a>
      <%
        }
      %>
    </div>
  </div>
</header>

<style>
  .header {
    background-color: #2c3e50;
    color: white;
    padding: 15px 0;
    box-shadow: 0 2px 5px rgba(0,0,0,0.1);
  }

  .header-container {
    max-width: 1200px;
    margin: 0 auto;
    padding: 0 20px;
    display: flex;
    justify-content: space-between;
    align-items: center;
  }

  .logo h1 {
    margin: 0;
    font-size: 24px;
  }

  .logo a {
    color: white;
    text-decoration: none;
  }

  .header-menu {
    display: flex;
    gap: 20px;
    align-items: center;
  }

  .header-menu a,
  .header-menu span {
    color: white;
    text-decoration: none;
    font-size: 14px;
    transition: color 0.3s;
  }

  .header-menu a:hover {
    color: #f0ad4e;
  }

  .header-menu .admin-link {
    background-color: #669933;
    color: #fff;
    padding: 4px 10px;
    border-radius: 4px;
    font-size: 13px;
  }

  .header-menu .admin-link:hover {
    background-color: #558822;
    color: #fff;
  }

  .header-menu strong {
    color: #f0ad4e;
  }

  .user-dropdown {
    position: relative;
    display: inline-block;
  }

  .user-dropdown-toggle {
    display: inline-block;
    padding: 4px 0;
  }

  .user-dropdown-menu {
    display: none;
    position: absolute;
    top: 100%;
    right: 0;
    min-width: 170px;
    background: #fff;
    border-radius: 6px;
    box-shadow: 0 8px 20px rgba(0, 0, 0, 0.2);
    overflow: hidden;
    z-index: 999;
  }

  .header-menu .user-dropdown-menu a {
    display: block;
    color: #333;
    padding: 10px 12px;
    font-size: 13px;
    border-bottom: 1px solid #f1f1f1;
  }

  .header-menu .user-dropdown-menu a:last-child {
    border-bottom: none;
  }

  .header-menu .user-dropdown-menu a:hover {
    background: #f7f7f7;
    color: #0275d8;
  }

  .user-dropdown:hover .user-dropdown-menu {
    display: block;
  }
</style>
