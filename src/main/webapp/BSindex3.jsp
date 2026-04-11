<%@ page import="com.fruitDayDB.vo.User" %>
<%--
后台 - 编辑用户
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    User adminUser = (User) session.getAttribute("user");
    if (adminUser == null || !adminUser.isAdmin()) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    User editUser = (User) request.getAttribute("user");
    if (editUser == null) editUser = new User();
%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8"/>
  <title>编辑用户 - 天天果园后台</title>
</head>
<body>
<jsp:include page="admin/sidebar.jsp"><jsp:param name="active" value="users"/></jsp:include>

<div class="admin-main">
  <div class="admin-topbar">
    <h2>✏️ 编辑用户</h2>
    <a href="<%= request.getContextPath() %>/BSServlet?key=alluser" class="btn btn-secondary">← 返回列表</a>
  </div>
  <div class="admin-body">
    <div class="card" style="max-width:520px;">
      <div class="card-title">编辑用户 ID: <%= editUser.getId() %></div>
      <form action="<%= request.getContextPath() %>/BSServlet?key=upuser" method="post">
        <input type="hidden" name="id" value="<%= editUser.getId() %>"/>
        <div class="form-group">
          <label>用户名 <span style="color:red">*</span></label>
          <input type="text" name="name2" class="form-control"
                 value="<%= editUser.getUname() != null ? editUser.getUname() : "" %>" required/>
        </div>
        <div class="form-group">
          <label>邮箱 <span style="color:red">*</span></label>
          <input type="email" name="email2" class="form-control"
                 value="<%= editUser.getEmail() != null ? editUser.getEmail() : "" %>" required/>
        </div>
        <div class="form-group">
          <label>手机号</label>
          <input type="text" name="phone2" class="form-control"
                 value="<%= editUser.getPhone() != null ? editUser.getPhone() : "" %>"/>
        </div>
        <div class="form-group">
          <label>密码</label>
          <input type="password" name="pwd2" class="form-control" placeholder="留空则不修改密码"/>
        </div>
        <div style="display:flex; gap:10px; margin-top:20px;">
          <button type="submit" class="btn btn-primary">✓ 保存修改</button>
          <a href="<%= request.getContextPath() %>/BSServlet?key=alluser" class="btn btn-secondary">取消</a>
        </div>
      </form>
    </div>
  </div>
</div>
</div>
</body>
</html>
