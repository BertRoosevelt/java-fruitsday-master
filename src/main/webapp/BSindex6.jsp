<%@ page import="com.fruitDayDB.vo.User" %>
<%@ page import="com.fruitDayDB.vo.Fruit" %>
<%--
后台 - 编辑商品
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    User adminUser = (User) session.getAttribute("user");
    if (adminUser == null || !adminUser.isAdmin()) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    Fruit fruit = (Fruit) request.getAttribute("fruit");
    if (fruit == null) fruit = new Fruit();
%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8"/>
  <title>编辑商品 - 天天果园后台</title>
</head>
<body>
<jsp:include page="admin/sidebar.jsp"><jsp:param name="active" value="fruits"/></jsp:include>

<div class="admin-main">
  <div class="admin-topbar">
    <h2>✏️ 编辑商品</h2>
    <a href="<%= request.getContextPath() %>/BSServlet?key=allfruit" class="btn btn-secondary">← 返回列表</a>
  </div>
  <div class="admin-body">
    <div class="card" style="max-width:600px;">
      <div class="card-title">编辑商品 ID: <%= fruit.getFid() %></div>
      <form action="<%= request.getContextPath() %>/BSServlet?key=upfruit&fid=<%= fruit.getFid() %>" method="post">
        <div class="form-group">
          <label>商品名称 <span style="color:red">*</span></label>
          <input type="text" name="fname" class="form-control"
                 value="<%= fruit.getFname() != null ? fruit.getFname() : "" %>" required/>
        </div>
        <div class="form-group">
          <label>规格 <span style="color:red">*</span></label>
          <input type="text" name="spec" class="form-control"
                 value="<%= fruit.getSpec() != null ? fruit.getSpec() : "" %>" required/>
        </div>
        <div class="form-group">
          <label>单价（元） <span style="color:red">*</span></label>
          <input type="number" name="up" class="form-control" step="0.01" min="0"
                 value="<%= fruit.getUp() %>" required/>
        </div>
        <div class="form-group">
          <label>商品简介（产地信息）</label>
          <input type="text" name="t1" class="form-control"
                 value="<%= fruit.getT1() != null ? fruit.getT1() : "" %>"/>
        </div>
        <div class="form-group">
          <label>温馨提示（储藏信息）</label>
          <input type="text" name="t2" class="form-control"
                 value="<%= fruit.getT2() != null ? fruit.getT2() : "" %>"/>
        </div>
        <div class="form-group">
          <label>图片数量</label>
          <input type="number" name="inum" class="form-control" min="1" max="99"
                 value="<%= fruit.getInum() %>"/>
        </div>
        <div style="display:flex; gap:10px; margin-top:20px;">
          <button type="submit" class="btn btn-warning">✓ 保存修改</button>
          <a href="<%= request.getContextPath() %>/BSServlet?key=allfruit" class="btn btn-secondary">取消</a>
        </div>
      </form>
    </div>
  </div>
</div>
</div>
</body>
</html>
