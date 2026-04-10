<%@ page import="java.util.List" %>
<%@ page import="com.fruitDayDB.vo.Fruit" %>
<%@ page import="com.fruitDayDB.service.FruitService" %>
<%--
前台首页
显示所有商品和热卖商品
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8" />
  <title>天天果园 - 水果网购首选品牌</title>
  <link rel="stylesheet" type="text/css" href="css/main.css"/>
  <link rel="stylesheet" type="text/css" href="css/index.css"/>
  <script src="js/imgs.js" type="text/javascript" charset="utf-8"></script>
</head>
<body>
<jsp:include page="head/head.jsp"></jsp:include>

<div class="content">
  <h2>🍎 热卖商品</h2>
  <div class="products-grid">
    <%
      // 在 JSP 中直接调用 Service，而不是通过 Servlet
      List<Fruit> hotFruits = FruitService.hot();

      if (hotFruits != null && !hotFruits.isEmpty()) {
        for (Fruit fruit : hotFruits) {
    %>
    <div class="product-card">
      <div class="product-image">
        <img src="img/fruit<%= fruit.getFid() %>.jpg" alt="<%= fruit.getFname() %>"
             onerror="this.src='img/default.jpg'"/>
      </div>
      <div class="product-info">
        <h3><%= fruit.getFname() %></h3>
        <p class="spec"><%= fruit.getSpec() %></p>
        <p class="price">¥<%= String.format("%.2f", fruit.getUp()) %></p>
        <div class="product-actions">
          <a href="<%= request.getContextPath() %>/FruitServlet?key=info&fid=<%= fruit.getFid() %>"
             class="btn btn-view">查看详情</a>
          <a href="<%= request.getContextPath() %>/ShopServlet?key=add&fruitId=<%= fruit.getFid() %>&quantity=1"
             class="btn btn-cart">加入购物车</a>
        </div>
      </div>
    </div>
    <%
      }
    } else {
    %>
    <div style="text-align: center; padding: 50px; color: #999;">
      <p>暂无热卖商品</p>
    </div>
    <%
      }
    %>
  </div>

  <hr style="margin: 40px 0; border: none; border-top: 1px solid #ddd;">

  <h2>🛒 所有商品</h2>
  <div class="products-grid">
    <%
      // 获取所有商品
      List<Fruit> allFruits = FruitService.all();

      if (allFruits != null && !allFruits.isEmpty()) {
        for (Fruit fruit : allFruits) {
    %>
    <div class="product-card">
      <div class="product-image">
        <img src="img/fruit<%= fruit.getFid() %>.jpg" alt="<%= fruit.getFname() %>"
             onerror="this.src='img/default.jpg'"/>
      </div>
      <div class="product-info">
        <h3><%= fruit.getFname() %></h3>
        <p class="spec"><%= fruit.getSpec() %></p>
        <p class="price">¥<%= String.format("%.2f", fruit.getUp()) %></p>
        <div class="product-actions">
          <a href="<%= request.getContextPath() %>/FruitServlet?key=info&fid=<%= fruit.getFid() %>"
             class="btn btn-view">查看详情</a>
          <a href="<%= request.getContextPath() %>/ShopServlet?key=add&fruitId=<%= fruit.getFid() %>&quantity=1"
             class="btn btn-cart">加入购物车</a>
        </div>
      </div>
    </div>
    <%
      }
    } else {
    %>
    <div style="text-align: center; padding: 50px; color: #999;">
      <p>暂无商品</p>
    </div>
    <%
      }
    %>
  </div>
</div>

<jsp:include page="footer/footer.jsp"></jsp:include>
</body>
</html>