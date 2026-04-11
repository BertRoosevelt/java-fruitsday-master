<%@ page import="com.fruitDayDB.vo.User" %>
<%@ page import="java.util.List" %>
<%@ page import="com.fruitDayDB.vo.Fruit" %>
<%@ page import="com.fruitDayDB.service.FruitService" %>
<%--
前台首页
显示 banner 轮播、热卖商品和全部商品
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8" />
  <title>天天果园-水果网购首选品牌，水果，我们只挑有来头的！</title>
  <link rel="stylesheet" type="text/css" href="css/main.css"/>
  <link rel="stylesheet" type="text/css" href="css/index.css"/>
  <script src="js/imgs.js" type="text/javascript" charset="utf-8"></script>
</head>
<body onload="fimg()">
<jsp:include page="head/head.jsp"></jsp:include>
<%
  User user = new User(0);
  if (session.getAttribute("user") != null)
    user = (User) session.getAttribute("user");
  int uid = user.getId();

  List<Fruit> hotFruits = (List<Fruit>) request.getAttribute("fruits");
  if (hotFruits == null)
    hotFruits = FruitService.hot();

  List<Fruit> allFruits = FruitService.all();
%>

<div class="banner-wrap">
  <div class="banner">
    <div id="p0" class="show"><a href="<%= request.getContextPath() %>/SELServlet?key=hot"><img src="img/index/h0.jpg" alt="天天果园促销活动1"/></a></div>
    <div id="p1" class="non"><a href="<%= request.getContextPath() %>/SELServlet?key=hot"><img src="img/index/h1.jpg" alt="天天果园促销活动2"/></a></div>
    <div id="p2" class="non"><a href="<%= request.getContextPath() %>/SELServlet?key=hot"><img src="img/index/h2.jpg" alt="天天果园促销活动3"/></a></div>
    <div id="p3" class="non"><a href="<%= request.getContextPath() %>/SELServlet?key=hot"><img src="img/index/h3.jpg" alt="天天果园促销活动4"/></a></div>
    <div id="p4" class="non"><a href="<%= request.getContextPath() %>/SELServlet?key=hot"><img src="img/index/h4.jpg" alt="天天果园促销活动5"/></a></div>
    <div class="banner_nav">
      <span id="l0" onmouseover="simg('1')" onmouseout="fimg()"></span>
      <span id="l1" onmouseover="simg('2')" onmouseout="fimg()"></span>
      <span id="l2" onmouseover="simg('3')" onmouseout="fimg()"></span>
      <span id="l3" onmouseover="simg('4')" onmouseout="fimg()"></span>
      <span id="l4" onmouseover="simg('5')" onmouseout="fimg()"></span>
    </div>
  </div>
</div>

<div class="con">
  <!-- Hot products section -->
  <div class="section-header">
    <h2>热卖商品</h2>
    <a href="<%= request.getContextPath() %>/SELServlet?key=hot" class="more-link">查看全部 &rsaquo;</a>
  </div>
  <div class="fruit-grid">
    <%
      if (hotFruits != null && !hotFruits.isEmpty()) {
        for (Fruit fruit : hotFruits) {
    %>
    <div class="fruit-card">
      <a href="<%= request.getContextPath() %>/FruitServlet?key=info&id=<%= uid %>&fid=<%= fruit.getFid() %>">
        <img src="img/fruits/<%= fruit.getFid() %>/(1).jpg" alt="<%= fruit.getFname() %>"/>
      </a>
      <div class="fname">
        <a href="<%= request.getContextPath() %>/FruitServlet?key=info&id=<%= uid %>&fid=<%= fruit.getFid() %>"><%= fruit.getFname() %></a>
      </div>
      <div class="fspec"><%= fruit.getSpec() %></div>
      <div class="fprice">¥<%= String.format("%.2f", fruit.getUp()) %></div>
    </div>
    <%
        }
      } else {
    %>
    <div class="empty-state"><p>暂无热卖商品</p></div>
    <%
      }
    %>
  </div>

  <!-- All products section -->
  <div class="section-header">
    <h2>全部商品</h2>
    <a href="<%= request.getContextPath() %>/SELServlet" class="more-link">进入商品列表 &rsaquo;</a>
  </div>
  <div class="fruit-grid">
    <%
      if (allFruits != null && !allFruits.isEmpty()) {
        for (Fruit fruit : allFruits) {
    %>
    <div class="fruit-card">
      <a href="<%= request.getContextPath() %>/FruitServlet?key=info&id=<%= uid %>&fid=<%= fruit.getFid() %>">
        <img src="img/fruits/<%= fruit.getFid() %>/(1).jpg" alt="<%= fruit.getFname() %>"/>
      </a>
      <div class="fname">
        <a href="<%= request.getContextPath() %>/FruitServlet?key=info&id=<%= uid %>&fid=<%= fruit.getFid() %>"><%= fruit.getFname() %></a>
      </div>
      <div class="fspec"><%= fruit.getSpec() %></div>
      <div class="fprice">¥<%= String.format("%.2f", fruit.getUp()) %></div>
    </div>
    <%
        }
      } else {
    %>
    <div class="empty-state"><p>暂无商品</p></div>
    <%
      }
    %>
  </div>
</div>

<jsp:include page="footer/footer.jsp"></jsp:include>
</body>
</html>
