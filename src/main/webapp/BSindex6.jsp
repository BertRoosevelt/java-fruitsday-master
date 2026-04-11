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
<%
  Fruit fruit=new Fruit("","",0,"","",0);
  if(request.getAttribute("fruit")!=null)
    fruit=(Fruit)request.getAttribute("fruit");
%>
<div class="gong" id="x6">
  <div class="con">
    <div class="form">
      <form action=/x-test/BSServlet?key=upfruit&fid=<%=fruit.getFid()%> method="post">
        <div class="add">
          <span class="add_tit">水果 ：</span>
          <span class="add_text"><input type="text" name="fname" id="fname2" value=<%=fruit.getFname()%> /></span>
        </div>

        <div class="add">
          <span class="add_tit">规格 ：</span>
          <span class="add_text"><input type="text" name="spec" id="spec2" value=<%=fruit.getSpec()%> /></span>
        </div>

        <div class="add">
          <span class="add_tit">单价 ：</span>
          <span class="add_text"><input type="text" name="up" id="up2" value=<%=fruit.getUp()%> /></span>
        </div>

        <div class="add">
          <span class="add_tit">商品简介 ：</span>
          <span class="add_text"><input type="text" class="long" name="t1" id="t12" value=<%=fruit.getT1()%> /></span>
        </div>

        <div class="add">
          <span class="add_tit">温馨提示 ：</span>
          <span class="add_text"><input type="text" class="long" name="t2" id="t22" value=<%=fruit.getT2()%> class="long"/></span>
        </div>

        <div class="add">
          <span class="add_tit">图片个数 ：</span>
          <span class="add_text"><input type="text" name="inum" id="inum2" value=<%=fruit.getInum()%> /></span>
        </div>

        <div class="add_sublmit">
          <input type="submit" value="保存"/>
        </div>
      </form>
    </div>
  </div>
</div>




</body>
</html>

