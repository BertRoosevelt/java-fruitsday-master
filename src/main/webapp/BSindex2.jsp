<%@ page import="com.fruitDayDB.vo.User" %>
<%--
后台 - 添加用户
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
  <meta charset="utf-8"/>
  <title>添加用户 - 天天果园后台</title>
</head>
<body>
<jsp:include page="admin/sidebar.jsp"><jsp:param name="active" value="users"/></jsp:include>

<div class="admin-main">
  <div class="admin-topbar">
    <h2>➕ 添加用户</h2>
    <a href="<%= request.getContextPath() %>/BSServlet?key=alluser" class="btn btn-secondary">← 返回列表</a>
  </div>
  <div class="admin-body">
    <div class="card" style="max-width:520px;">
      <div class="card-title">新建用户账户</div>
      <form action="<%= request.getContextPath() %>/BSServlet?key=adduser" method="post">
        <div class="form-group">
          <label>用户名 <span style="color:red">*</span></label>
          <input type="text" name="name1" class="form-control" placeholder="请输入用户名" required/>
        </div>
        <div class="form-group">
          <label>邮箱 <span style="color:red">*</span></label>
          <input type="email" name="email1" class="form-control" placeholder="请输入邮箱" required/>
        </div>
        <div class="form-group">
          <label>手机号</label>
          <input type="text" name="phone1" class="form-control" placeholder="请输入手机号（可选）"/>
        </div>
        <div class="form-group">
          <label>密码 <span style="color:red">*</span></label>
          <input type="password" name="pwd1" class="form-control" placeholder="请输入密码（最少6位）" required/>
        </div>
        <div style="display:flex; gap:10px; margin-top:20px;">
          <button type="submit" class="btn btn-primary">✓ 添加用户</button>
          <a href="<%= request.getContextPath() %>/BSServlet?key=alluser" class="btn btn-secondary">取消</a>
        </div>
      </form>
    </div>
  </div>
</div>
</div>
</body>
</html>
