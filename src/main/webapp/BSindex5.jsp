<%@ page import="com.fruitDayDB.vo.User" %>
<%--
后台 - 新增商品
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
  <title>新增商品 - 水果超市管理系统后台</title>
</head>
<body>
<jsp:include page="admin/sidebar.jsp"><jsp:param name="active" value="fruits"/></jsp:include>

<div class="admin-main">
  <div class="admin-topbar">
    <h2>➕ 新增商品</h2>
    <a href="<%= request.getContextPath() %>/BSServlet?key=allfruit" class="btn btn-secondary">← 返回列表</a>
  </div>
  <div class="admin-body">
    <div class="card" style="max-width:600px;">
      <div class="card-title">填写商品信息</div>
      <form action="<%= request.getContextPath() %>/BSServlet?key=addfruit" method="post">
        <div class="form-group">
          <label>商品名称 <span style="color:red">*</span></label>
          <input type="text" name="fname" class="form-control" placeholder="例如：佳沛新西兰绿奇异果" required/>
        </div>
        <div class="form-group">
          <label>规格 <span style="color:red">*</span></label>
          <input type="text" name="spec" class="form-control" placeholder="例如：4+2盒" required/>
        </div>
        <div class="form-group">
          <label>单价（元） <span style="color:red">*</span></label>
          <input type="number" name="up" class="form-control" step="0.01" min="0.01" placeholder="例如：78.00" required/>
        </div>
        <div class="form-group">
          <label>商品简介（产地信息）</label>
          <input type="text" name="t1" class="form-control" placeholder="例如：产地 新西兰 销售规格 6个"/>
        </div>
        <div class="form-group">
          <label>温馨提示（储藏信息）</label>
          <input type="text" name="t2" class="form-control" placeholder="例如：储藏方法 0-4度冷藏"/>
        </div>
        <div class="form-group">
          <label>图片数量</label>
          <input type="number" name="inum" class="form-control" value="1" min="1" max="99"/>
          <small style="color:#7f8c8d; font-size:12px;">对应 img/fruits/{fid}/(1).jpg 等图片文件</small>
        </div>
        <div style="display:flex; gap:10px; margin-top:20px;">
          <button type="submit" class="btn btn-success">✓ 新增商品</button>
          <a href="<%= request.getContextPath() %>/BSServlet?key=allfruit" class="btn btn-secondary">取消</a>
        </div>
      </form>
    </div>
  </div>
</div>
</div>
</body>
</html>
