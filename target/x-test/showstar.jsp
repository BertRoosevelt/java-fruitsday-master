<%@ page import="com.fruitDayDB.vo.Fruit" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="com.fruitDayDB.vo.User" %>
<%@ page import="com.fruitDayDB.service.ShopService" %>
<%--
我的收藏页面
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <title>我的收藏 - 天天果园</title>
  <link rel="stylesheet" type="text/css" href="css/main.css"/>
  <style>
    .fav-container { max-width: 1000px; margin: 20px auto; }
    .fav-header { background:#f5f5f5; padding:15px; margin-bottom:20px; border-radius:5px; }
    .fav-table { width:100%; border-collapse:collapse; background:#fff; border-radius:5px; box-shadow:0 2px 8px rgba(0,0,0,0.07); }
    .fav-table th { background:#f8f9fa; padding:12px 15px; text-align:left; border-bottom:2px solid #dee2e6; font-size:13px; }
    .fav-table td { padding:14px 15px; border-bottom:1px solid #f0f0f0; }
    .fav-table tr:hover td { background:#f8f9fb; }
    .btn { display:inline-block; padding:6px 14px; border:none; border-radius:4px; cursor:pointer; font-size:13px; text-decoration:none; }
    .btn-primary { background:#3498db; color:#fff; }
    .btn-danger { background:#e74c3c; color:#fff; }
    .empty { text-align:center; padding:50px; color:#666; }
  </style>
</head>
<body>
<jsp:include page="head/head.jsp"></jsp:include>

<div class="fav-container">
  <div class="fav-header">
    <h2>⭐ 我的收藏</h2>
  </div>

  <%
    List<com.fruitDayDB.vo.Cart> favorites = ShopService.getFavorites(user.getId());
  %>

  <% if (favorites == null || favorites.isEmpty()) { %>
  <div class="empty">
    <div style="font-size:48px; margin-bottom:16px;">⭐</div>
    <h3>收藏夹是空的</h3>
    <p>快去挑选你喜欢的水果吧！</p>
    <a href="<%= request.getContextPath() %>/index.jsp" class="btn btn-primary">返回首页</a>
  </div>
  <% } else { %>
  <table class="fav-table">
    <thead>
    <tr>
      <th>商品</th>
      <th>商品ID</th>
      <th>操作</th>
    </tr>
    </thead>
    <tbody>
    <%
      for (com.fruitDayDB.vo.Cart cart : favorites) {
        com.fruitDayDB.vo.Fruit fruit = com.fruitDayDB.service.FruitService.info(cart.getFruitId());
        if (fruit == null) continue;
    %>
    <tr>
      <td>
        <div style="display:flex; align-items:center; gap:12px;">
          <img src="img/fruits/<%= fruit.getFid() %>/(1).jpg"
               style="width:50px; height:50px; object-fit:cover; border-radius:4px;"
               alt="<%= fruit.getFname() %>"/>
          <div>
            <a href="<%= request.getContextPath() %>/FruitServlet?key=info&fid=<%= fruit.getFid() %>"
               style="color:#333; font-weight:bold; text-decoration:none;"><%= fruit.getFname() %></a>
            <div style="color:#7f8c8d; font-size:13px;"><%= fruit.getSpec() %></div>
            <div style="color:#e74c3c; font-weight:bold;">¥<%= String.format("%.2f", fruit.getUp()) %></div>
          </div>
        </div>
      </td>
      <td><%= fruit.getFid() %></td>
      <td>
        <a href="<%= request.getContextPath() %>/FruitServlet?key=info&fid=<%= fruit.getFid() %>"
           class="btn btn-primary">查看</a>
        <a href="<%= request.getContextPath() %>/ShopServlet?key=unfavorite&fruitId=<%= fruit.getFid() %>"
           class="btn btn-danger"
           onclick="return confirm('确定要取消收藏？')">取消收藏</a>
      </td>
    </tr>
    <%
      }
    %>
    </tbody>
  </table>
  <% } %>
</div>

<jsp:include page="footer/footer.jsp"></jsp:include>
</body>
</html>
