<%@ page import="com.fruitDayDB.vo.Order" %>
<%@ page import="com.fruitDayDB.vo.OrderItem" %>
<%@ page import="com.fruitDayDB.vo.User" %>
<%@ page import="com.fruitDayDB.service.OrderService" %>
<%@ page import="java.util.List" %>
<%--
后台订单详情页
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    User adminUser = (User) session.getAttribute("user");
    if (adminUser == null || !adminUser.isAdmin()) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    Order order = (Order) request.getAttribute("order");
    String statusDisplay = (String) request.getAttribute("statusDisplay");
    User orderUser = (User) request.getAttribute("orderUser");
    if (order == null) {
        response.sendRedirect(request.getContextPath() + "/AdminServlet?key=orders");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8"/>
  <title>订单详情 - 水果超市管理系统后台</title>
</head>
<body>
<jsp:include page="sidebar.jsp"><jsp:param name="active" value="orders"/></jsp:include>

<div class="admin-main">
  <div class="admin-topbar">
    <h2>📦 订单详情</h2>
    <a href="<%= request.getContextPath() %>/AdminServlet?key=orders" class="btn btn-secondary">← 返回列表</a>
  </div>
  <div class="admin-body">

    <% if (request.getParameter("shipped") != null) { %>
    <div class="alert alert-success">✓ 已成功标记发货！</div>
    <% } %>

    <div style="display:grid; grid-template-columns:1fr 1fr; gap:18px;">
      <div class="card">
        <div class="card-title">订单信息</div>
        <table>
          <tr><td style="color:#7f8c8d; width:120px;">订单号</td><td><strong style="color:#3498db; font-size:12px;"><%= order.getOrderNumber() %></strong></td></tr>
          <tr><td style="color:#7f8c8d;">订单状态</td>
          <td>
            <%
              String statusClass = "badge-secondary";
              String s = order.getStatus();
              if ("pending".equals(s)) statusClass = "badge-warning";
              else if ("paid".equals(s)) statusClass = "badge-info";
              else if ("shipped".equals(s)) statusClass = "badge-success";
              else if ("completed".equals(s)) statusClass = "badge-primary";
              else if ("cancelled".equals(s)) statusClass = "badge-danger";
            %>
            <span class="badge <%= statusClass %>"><%= statusDisplay %></span>
          </td></tr>
          <tr><td style="color:#7f8c8d;">订单金额</td><td style="color:#e74c3c; font-weight:bold; font-size:18px;">¥<%= String.format("%.2f", order.getTotalPrice()) %></td></tr>
          <tr><td style="color:#7f8c8d;">下单时间</td><td><%= order.getCreatedAt() %></td></tr>
          <% if (order.getPaidAt() != null) { %><tr><td style="color:#7f8c8d;">支付时间</td><td><%= order.getPaidAt() %></td></tr><% } %>
          <% if (order.getShippedAt() != null) { %><tr><td style="color:#7f8c8d;">发货时间</td><td><%= order.getShippedAt() %></td></tr><% } %>
          <% if (order.getCompletedAt() != null) { %><tr><td style="color:#7f8c8d;">完成时间</td><td><%= order.getCompletedAt() %></td></tr><% } %>
          <% if (order.getRemark() != null && !order.getRemark().isEmpty()) { %>
          <tr><td style="color:#7f8c8d;">备注</td><td><%= order.getRemark() %></td></tr>
          <% } %>
        </table>
      </div>

      <div class="card">
        <div class="card-title">买家信息</div>
        <% if (orderUser != null) { %>
        <table>
          <tr><td style="color:#7f8c8d; width:80px;">用户ID</td><td><%= orderUser.getId() %></td></tr>
          <tr><td style="color:#7f8c8d;">用户名</td><td><%= orderUser.getUname() %></td></tr>
          <tr><td style="color:#7f8c8d;">邮箱</td><td><%= orderUser.getEmail() %></td></tr>
          <tr><td style="color:#7f8c8d;">手机</td><td><%= orderUser.getPhone() %></td></tr>
        </table>
        <% } else { %>
        <p style="color:#7f8c8d;">用户ID: <%= order.getUserId() %></p>
        <% } %>
      </div>
    </div>

    <div class="card">
      <div class="card-title">商品明细</div>
      <table>
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
          List<OrderItem> items = order.getItems();
          double total = 0;
          if (items != null) {
            for (OrderItem item : items) {
              total += item.getSubtotal();
        %>
        <tr>
          <td><%= item.getFruitName() %></td>
          <td>¥<%= String.format("%.2f", item.getPrice()) %></td>
          <td><%= item.getQuantity() %></td>
          <td style="color:#e74c3c; font-weight:bold;">¥<%= String.format("%.2f", item.getSubtotal()) %></td>
        </tr>
        <%
            }
          }
        %>
        <tr style="background:#f8f9fa;">
          <td colspan="3" style="text-align:right; font-weight:bold;">合计</td>
          <td style="color:#e74c3c; font-weight:bold; font-size:18px;">¥<%= String.format("%.2f", order.getTotalPrice()) %></td>
        </tr>
        </tbody>
      </table>
    </div>

    <%-- 操作区 --%>
    <div class="card">
      <div class="card-title">订单操作</div>
      <div style="display:flex; gap:12px;">
        <% if ("paid".equals(order.getStatus())) { %>
        <a href="<%= request.getContextPath() %>/AdminServlet?key=ship&orderId=<%= order.getId() %>"
           class="btn btn-success" onclick="return confirm('确认为此订单标记发货？')">🚚 标记发货</a>
        <% } %>
        <a href="<%= request.getContextPath() %>/AdminServlet?key=orders" class="btn btn-secondary">← 返回列表</a>
      </div>
      <% if (!"paid".equals(order.getStatus())) { %>
      <p style="color:#7f8c8d; font-size:13px; margin-top:12px;">
        当前状态：<%= statusDisplay %>。
        <% if ("pending".equals(order.getStatus())) out.print("等待用户支付，暂无可操作项。"); %>
        <% if ("shipped".equals(order.getStatus())) out.print("商品已发货，等待用户确认收货。"); %>
        <% if ("completed".equals(order.getStatus())) out.print("订单已完成。"); %>
        <% if ("cancelled".equals(order.getStatus())) out.print("订单已取消。"); %>
      </p>
      <% } %>
    </div>
  </div>
</div>
</div>
</body>
</html>
