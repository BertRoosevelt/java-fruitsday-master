<%@ page import="java.util.List" %>
<%@ page import="com.fruitDayDB.service.ShopService" %>
<%@ page import="com.fruitDayDB.vo.User" %>
<%--
购物车页面
显示用户的购物车商品列表
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8" />
  <title>购物车 - 天天果园</title>
  <link rel="stylesheet" type="text/css" href="css/main.css"/>
  <style>
    .cart-container {
      max-width: 1000px;
      margin: 20px auto;
    }
    .cart-header {
      background-color: #f5f5f5;
      padding: 15px;
      margin-bottom: 20px;
      border-radius: 5px;
    }
    .cart-table {
      width: 100%;
      border-collapse: collapse;
      margin-bottom: 20px;
    }
    .cart-table th {
      background-color: #f0f0f0;
      padding: 10px;
      text-align: left;
      border-bottom: 2px solid #ddd;
    }
    .cart-table td {
      padding: 15px 10px;
      border-bottom: 1px solid #ddd;
    }
    .cart-item-name {
      color: #333;
      font-weight: bold;
    }
    .cart-item-price {
      color: #d9534f;
      font-size: 18px;
      font-weight: bold;
    }
    .quantity-input {
      width: 50px;
      padding: 5px;
      border: 1px solid #ddd;
      border-radius: 3px;
    }
    .btn {
      padding: 8px 15px;
      margin: 0 5px;
      border: none;
      border-radius: 3px;
      cursor: pointer;
      font-size: 14px;
    }
    .btn-update {
      background-color: #5cb85c;
      color: white;
    }
    .btn-update:hover {
      background-color: #4cae4c;
    }
    .btn-remove {
      background-color: #d9534f;
      color: white;
    }
    .btn-remove:hover {
      background-color: #c9302c;
    }
    .cart-summary {
      background-color: #f9f9f9;
      padding: 20px;
      border-radius: 5px;
      text-align: right;
      margin-bottom: 20px;
    }
    .total-price {
      font-size: 24px;
      color: #d9534f;
      font-weight: bold;
      margin: 10px 0;
    }
    .cart-actions {
      text-align: right;
      margin-top: 20px;
    }
    .btn-checkout {
      background-color: #0275d8;
      color: white;
      padding: 12px 30px;
      font-size: 16px;
      margin-left: 10px;
    }
    .btn-checkout:hover {
      background-color: #025aa5;
    }
    .btn-continue {
      background-color: #6c757d;
      color: white;
      padding: 12px 30px;
      font-size: 16px;
    }
    .btn-continue:hover {
      background-color: #5a6268;
    }
    .empty-cart {
      text-align: center;
      padding: 50px;
      color: #666;
    }
    .empty-cart-icon {
      font-size: 60px;
      margin-bottom: 20px;
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
    .alert-error {
      background-color: #f8d7da;
      color: #721c24;
      border: 1px solid #f5c6cb;
    }
  </style>
</head>
<body>
<jsp:include page="head/head.jsp"></jsp:include>

<div class="cart-container">
  <div class="cart-header">
    <h2>🛒 购物车</h2>
  </div>

  <%-- 成功提示 --%>
  <% if (request.getParameter("success") != null) { %>
  <div class="alert alert-success">
    ✓ 操作成功！
  </div>
  <% } %>

  <%-- 清空成功提示 --%>
  <% if (request.getParameter("cleared") != null) { %>
  <div class="alert alert-success">
    ✓ 购物车已清空
  </div>
  <% } %>

  <%-- 错误提示 --%>
  <% if (request.getAttribute("error") != null) { %>
  <div class="alert alert-error">
    ✗ <%= request.getAttribute("error") %>
  </div>
  <% } %>

  <%
    User user = (User) session.getAttribute("user");
    List<ShopService.CartItemDetail> cartItems =
            (List<ShopService.CartItemDetail>) request.getAttribute("cartItems");
    Double cartTotal = (Double) request.getAttribute("cartTotal");
    Integer cartCount = (Integer) request.getAttribute("cartCount");

    if (cartItems == null || cartItems.isEmpty()) {
  %>
  <div class="empty-cart">
    <div class="empty-cart-icon">🛒</div>
    <h3>购物车是空的</h3>
    <p>快去选购商品吧！</p>
    <a href="<%= request.getContextPath() %>/index.jsp" class="btn btn-continue">
      返回首页继续购物
    </a>
  </div>
  <%
  } else {
  %>
  <table class="cart-table">
    <thead>
    <tr>
      <th>商品名称</th>
      <th>规格</th>
      <th>单价</th>
      <th>数量</th>
      <th>小计</th>
      <th>操作</th>
    </tr>
    </thead>
    <tbody>
    <%
      for (ShopService.CartItemDetail item : cartItems) {
    %>
    <tr>
      <td class="cart-item-name"><%= item.getFruitName() %></td>
      <td><%= item.getSpec() != null ? item.getSpec() : "-" %></td>
      <td class="cart-item-price">¥<%= String.format("%.2f", item.getPrice()) %></td>
      <td>
        <form method="POST" action="<%= request.getContextPath() %>/ShopServlet?key=updateQty" style="display:inline;">
          <input type="hidden" name="fruitId" value="<%= item.getFruitId() %>"/>
          <input type="number" name="quantity" value="<%= item.getQuantity() %>"
                 min="1" max="999" class="quantity-input"/>
          <button type="submit" class="btn btn-update">更新</button>
        </form>
      </td>
      <td class="cart-item-price">¥<%= String.format("%.2f", item.getSubtotal()) %></td>
      <td>
        <a href="<%= request.getContextPath() %>/ShopServlet?key=remove&fruitId=<%= item.getFruitId() %>"
           class="btn btn-remove" onclick="return confirm('确定删除此商品？')">删除</a>
      </td>
    </tr>
    <%
      }
    %>
    </tbody>
  </table>

  <div class="cart-summary">
    <div>购物车共有 <strong><%= cartCount %></strong> 件商品</div>
    <div class="total-price">合计：¥<%= String.format("%.2f", cartTotal) %></div>
  </div>

  <div class="cart-actions">
    <a href="<%= request.getContextPath() %>/index.jsp" class="btn btn-continue">
      继续购物
    </a>
    <a href="<%= request.getContextPath() %>/ShopServlet?key=clear" class="btn btn-remove"
       onclick="return confirm('确定要清空购物车？')">
      清空购物车
    </a>
    <a href="<%= request.getContextPath() %>/OrderServlet?key=create" class="btn btn-checkout">
      下单结算
    </a>
  </div>
  <%
    }
  %>
</div>

<jsp:include page="footer/footer.jsp"></jsp:include>
</body>
</html>