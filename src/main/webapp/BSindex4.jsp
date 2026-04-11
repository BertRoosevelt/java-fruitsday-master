<%@ page import="com.fruitDayDB.vo.User" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="com.fruitDayDB.vo.Fruit" %>
<%--
后台 - 商品列表（含热卖管理）
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    User adminUser = (User) session.getAttribute("user");
    if (adminUser == null || !adminUser.isAdmin()) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    String pageTitle = "🍎 商品列表";
    if ("hot".equals(request.getAttribute("listType"))) pageTitle = "🔥 热卖商品管理";
    List<Fruit> fruits = new ArrayList<Fruit>();
    if (request.getAttribute("allfruit") != null) {
        fruits = (List<Fruit>) request.getAttribute("allfruit");
    }
%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8"/>
  <title>商品管理 - 天天果园后台</title>
</head>
<body>
<jsp:include page="admin/sidebar.jsp"><jsp:param name="active" value="fruits"/></jsp:include>

<div class="admin-main">
  <div class="admin-topbar">
    <h2><%= pageTitle %></h2>
    <a href="<%= request.getContextPath() %>/BSindex5.jsp" class="btn btn-success">➕ 新增商品</a>
  </div>
  <div class="admin-body">
    <div class="card">
      <div class="card-title">商品列表（共 <%= fruits.size() %> 件）</div>
      <table>
        <thead>
        <tr>
          <th>ID</th>
          <th>商品名称</th>
          <th>规格</th>
          <th>单价（元）</th>
          <th>库存（图片数）</th>
          <th>操作</th>
        </tr>
        </thead>
        <tbody>
        <%
          for (Fruit fruit : fruits) {
        %>
        <tr>
          <td><%= fruit.getFid() %></td>
          <td><strong><%= fruit.getFname() %></strong></td>
          <td><%= fruit.getSpec() %></td>
          <td style="color:#e74c3c; font-weight:bold;">¥<%= String.format("%.2f", fruit.getUp()) %></td>
          <td><%= fruit.getInum() %></td>
          <td>
            <a href="<%= request.getContextPath() %>/BSServlet?key=findfruit&fid=<%= fruit.getFid() %>"
               class="btn btn-warning">编辑</a>
            <a href="<%= request.getContextPath() %>/BSServlet?key=sethot&fid=<%= fruit.getFid() %>"
               class="btn btn-primary" title="设为热卖">🔥 热卖</a>
            <a href="<%= request.getContextPath() %>/BSServlet?key=delfruit&fid=<%= fruit.getFid() %>"
               class="btn btn-danger"
               onclick="return confirm('确定要删除商品「<%= fruit.getFname() %>」？')">删除</a>
          </td>
        </tr>
        <%
          }
        %>
        </tbody>
      </table>
      <% if (fruits.isEmpty()) { %>
      <div style="text-align:center; padding:30px; color:#7f8c8d;">暂无商品数据</div>
      <% } %>
    </div>
  </div>
</div>
</div>
</body>
</html>
