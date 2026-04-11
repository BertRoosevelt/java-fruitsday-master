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
<!DOCTYPE html>
<html>
<head>

  <meta charset="utf-8" />
  <title></title>
  <link rel="stylesheet" type="text/css" href="css/BSindex.css"/>
  <link rel="stylesheet" type="text/css" href="css/main.css"/>
  <script src="js/BSindex.js" type="text/javascript" charset="utf-8"></script>
  <%
    String show="x0";
    if(request.getAttribute("sky")!=null)
      show=(String)request.getAttribute("sky");
  %>
</head>
<body >
<div class="mean">
  <div class="logo">
    <a href="index.jsp"><img src="img/alogo.png" alt="" /></a>
  </div>
  <div class="mean_ul">
    <div class="mean_li" onclick="sss('u')">用户管理</div>
    <div class="user_list" id="user_list">
      <div class="mm"><a href="/x-test/BSServlet?key=alluser">全部用户</a></div>
      <div class="mm"><a href="BSindex2.jsp">添加用户</a></div>
    </div>
    <div class="mean_li" onclick="sss('f')">商品管理</div>
    <div class="fruit_list" id="fruit_list">
      <div class="mm"><a href="/x-test/BSServlet?key=allfruit">库存水果</a></div>
      <div class="mm"><a href="/x-test/BSServlet?key=hotfruit">热卖水果</a></div>
      <div class="mm"><a href="BSindex5.jsp">水果入库</a></div>
    </div>
  </div>
</div>


<div class="gong" id="x3">
  <div class="con">
    <%
      User user3=new User(1,"","","","");
      if(request.getAttribute("user")!=null)
        user3=(User)request.getAttribute("user");
    %>
    <div class="form">
      <form action=/x-test/BSServlet?key=upuser&id=<%=user3.getId()%> method="post">
        <div class="add">
          <span class="add_tit">用户名 ：</span>
          <span class="add_text"><input type="text" name="name1" id="name2" value=<%=user3.getUname()%> /></span>
        </div>

        <div class="add">
          <span class="add_tit">邮箱 ：</span>
          <span class="add_text"><input type="text" name="email2" id="email2" value=<%=user3.getEmail()%> /></span>
        </div>

        <div class="add">
          <span class="add_tit">手机 ：</span>
          <span class="add_text"><input type="text" name="phone2" id="phone2" value=<%=user3.getPhone()%> /></span>
        </div>

        <div class="add">
          <span class="add_tit">密码 ：</span>
          <span class="add_text"><input type="text" name="pwd2" id="pwd2" value=<%=user3.getPwd()%> /></span>
        </div>
        <div class="add_sublmit">
          <input type="submit" value="保存"/>
        </div>
      </form>
    </div>
  </div>
</div>

<div class="gong" id="x4">


</body>
</html>

