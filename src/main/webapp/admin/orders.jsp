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
  <title>订单管理 - 水果超市管理系统后台</title>
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
