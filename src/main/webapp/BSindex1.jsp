<%@ page import="com.fruitDayDB.vo.User" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%--
后台用户管理页面
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    User adminUser = (User) session.getAttribute("user");
    if (adminUser == null || !adminUser.isAdmin()) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8" />
  <title>用户管理 - 水果超市管理系统后台</title>
</head>
<body>
<jsp:include page="admin/sidebar.jsp"><jsp:param name="active" value="users"/></jsp:include>

<div class="admin-main">
  <div class="admin-topbar">
    <h2>👥 用户管理</h2>
    <a href="<%= request.getContextPath() %>/BSindex2.jsp" class="btn btn-primary">➕ 添加用户</a>
  </div>

  <div class="admin-body">
    <div class="card">
      <div class="card-title">用户列表</div>
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
            <a href="<%= request.getContextPath() %>/BSServlet?key=finduser&id=<%= user.getId() %>"
               class="btn btn-warning">编辑</a>
            &nbsp;
            <a href="<%= request.getContextPath() %>/BSServlet?key=deluser&id=<%= user.getId() %>"
               class="btn btn-danger" onclick="return confirm('确定要删除用户「<%= user.getUname() %>」？')">删除</a>
          </td>
        </tr>
        <%
            }
          }
        %>
        </tbody>
      </table>
      <% if (users.isEmpty()) { %>
      <div style="text-align:center; padding:30px; color:#7f8c8d;">暂无用户数据</div>
      <% } %>
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
