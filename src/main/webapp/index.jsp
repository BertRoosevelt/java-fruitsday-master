<%@ page import="com.fruitDayDB.vo.User" %>
<%@ page import="java.util.List" %>
<%@ page import="com.fruitDayDB.vo.Fruit" %>
<%@ page import="com.fruitDayDB.service.FruitService" %>
<%--
前台首页
显示 banner 轮播和热卖商品
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
%>

<div class="banner">
  <div id="p0" class="show"><a href="http://www.tiantianfruit.com/"><img src="img/index/h0.jpg" alt=""/></a></div>
  <div id="p1" class="non"><a href="http://www.tiantianfruit.com/"><img src="img/index/h1.jpg" alt=""/></a></div>
  <div id="p2" class="non"><a href="http://www.tiantianfruit.com/"><img src="img/index/h2.jpg" alt=""/></a></div>
  <div id="p3" class="non"><a href="http://www.tiantianfruit.com/"><img src="img/index/h3.jpg" alt=""/></a></div>
  <div id="p4" class="non"><a href="http://www.tiantianfruit.com/"><img src="img/index/h4.jpg" alt=""/></a></div>
  <div class="banner_nav">
    <span id="l0" onmouseover="simg('1')" onmouseout="fimg()">1</span>
    <span id="l1" onmouseover="simg('2')" onmouseout="fimg()">2</span>
    <span id="l2" onmouseover="simg('3')" onmouseout="fimg()">3</span>
    <span id="l3" onmouseover="simg('4')" onmouseout="fimg()">4</span>
    <span id="l4" onmouseover="simg('5')" onmouseout="fimg()">5</span>
  </div>
</div>

<div class="con">
  <div class="fruitboxs">
    <%
      if (hotFruits != null) {
        for (Fruit fruit : hotFruits) {
    %>
    <div class="fruit_box">
      <div class="fruit_img">
        <a href="<%= request.getContextPath() %>/FruitServlet?key=info&id=<%= uid %>&fid=<%= fruit.getFid() %>">
          <img src="img/fruits/<%= fruit.getFid() %>/(1).jpg" alt="<%= fruit.getFname() %>"/>
        </a>
      </div>
      <div class="fruit_name">
        <a href="<%= request.getContextPath() %>/FruitServlet?key=info&id=<%= uid %>&fid=<%= fruit.getFid() %>"><%= fruit.getFname() %></a>
      </div>
      <div class="fruit_num"><%= fruit.getSpec() %></div>
      <div class="fruit_mon">￥<%= fruit.getUp() %></div>
      <div class="flogo"><img src="img/flogo.png"/></div>
    </div>
    <%
        }
      }
    %>
  </div>
</div>

<jsp:include page="footer/footer.jsp"></jsp:include>
</body>
</html>