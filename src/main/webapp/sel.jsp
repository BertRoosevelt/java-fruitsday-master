<%@ page import="com.fruitDayDB.vo.Fruit" %>
<%@ page import="com.fruitDayDB.vo.User" %>
<%@ page import="java.util.List" %>
<%@ page import="com.fruitDayDB.service.FruitService" %>
<%--
商品筛选/浏览页面
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    User user = new User(0);
    if (session.getAttribute("user") != null)
        user = (User) session.getAttribute("user");

    // 获取商品列表 - 优先使用 servlet 设置的属性，否则显示所有
    List<Fruit> selFruits = (List<Fruit>) request.getAttribute("fruits");
    if (selFruits == null) selFruits = FruitService.all();

    String searchKeyword = request.getParameter("keyword");
    if (searchKeyword == null) searchKeyword = (String) request.getAttribute("searchKeyword");
    if (searchKeyword == null) searchKeyword = "";

    String pageTitle = (String) request.getAttribute("title");
    if (pageTitle == null) pageTitle = "全部商品";
%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8"/>
  <title><%= pageTitle %> - 水果超市管理系统</title>
  <link rel="stylesheet" type="text/css" href="css/main.css"/>
  <link rel="stylesheet" type="text/css" href="css/index.css"/>
  <style>
    .sel-wrap { display:flex; gap:20px; max-width:1200px; margin:20px auto; padding:0 16px; }
    .sel-sidebar { width:200px; flex-shrink:0; }
    .sel-main { flex:1; }
    .filter-card { background:#fff; border-radius:6px; box-shadow:0 2px 8px rgba(0,0,0,0.07); padding:16px; margin-bottom:16px; }
    .filter-card h4 { margin:0 0 10px 0; font-size:14px; color:#2c3e50; }
    .filter-item a { display:block; padding:6px 0; font-size:13px; color:#555; text-decoration:none; border-bottom:1px solid #f0f0f0; }
    .filter-item a:hover, .filter-item a.active { color:#3498db; font-weight:bold; }
    .search-bar { display:flex; gap:8px; margin-bottom:18px; }
    .search-bar input { flex:1; padding:10px 14px; border:1px solid #ddd; border-radius:4px; font-size:14px; }
    .search-bar button { padding:10px 20px; background:#3498db; color:#fff; border:none; border-radius:4px; cursor:pointer; font-size:14px; }
    .search-bar button:hover { background:#2980b9; }
    .result-info { color:#7f8c8d; font-size:13px; margin-bottom:14px; }
    .fruit-grid { display:grid; grid-template-columns:repeat(auto-fill, minmax(180px, 1fr)); gap:16px; }
    .fruit-card { background:#fff; border-radius:6px; box-shadow:0 2px 8px rgba(0,0,0,0.07); padding:12px; transition:transform 0.2s, box-shadow 0.2s; }
    .fruit-card:hover { transform:translateY(-3px); box-shadow:0 6px 16px rgba(0,0,0,0.12); }
    .fruit-card img { width:100%; height:140px; object-fit:cover; border-radius:4px; }
    .fruit-card .fname { margin:8px 0 4px; font-weight:bold; font-size:14px; color:#333; }
    .fruit-card .fspec { font-size:12px; color:#7f8c8d; margin-bottom:6px; }
    .fruit-card .fprice { color:#e74c3c; font-weight:bold; font-size:16px; }
    .empty { text-align:center; padding:50px; color:#666; }
  </style>
</head>
<body>
<jsp:include page="head/head.jsp"></jsp:include>

<div class="sel-wrap">
  <div class="sel-sidebar">
    <div class="filter-card">
      <h4>价格筛选</h4>
      <div class="filter-item">
        <a href="<%= request.getContextPath() %>/SELServlet" class="<%= searchKeyword.isEmpty() ? "active" : "" %>">不限</a>
        <a href="<%= request.getContextPath() %>/SELServlet?priceMin=0&priceMax=30">30元以下</a>
        <a href="<%= request.getContextPath() %>/SELServlet?priceMin=30&priceMax=60">30~60元</a>
        <a href="<%= request.getContextPath() %>/SELServlet?priceMin=60&priceMax=100">60~100元</a>
        <a href="<%= request.getContextPath() %>/SELServlet?priceMin=100">100元以上</a>
      </div>
    </div>
    <div class="filter-card">
      <h4>热门分类</h4>
      <div class="filter-item">
        <a href="<%= request.getContextPath() %>/SELServlet?key=search&keyword=奇异果">奇异果</a>
        <a href="<%= request.getContextPath() %>/SELServlet?key=search&keyword=葡萄">葡萄</a>
        <a href="<%= request.getContextPath() %>/SELServlet?key=search&keyword=苹果">苹果</a>
        <a href="<%= request.getContextPath() %>/SELServlet?key=search&keyword=橙">橙子</a>
        <a href="<%= request.getContextPath() %>/SELServlet?key=search&keyword=牛油果">牛油果</a>
      </div>
    </div>
  </div>

  <div class="sel-main">
    <form class="search-bar" method="GET" action="<%= request.getContextPath() %>/SELServlet">
      <input type="hidden" name="key" value="search"/>
      <input type="text" name="keyword" value="<%= searchKeyword %>" placeholder="搜索水果名称..."/>
      <button type="submit">🔍 搜索</button>
    </form>

    <div class="result-info">
      <% if (!searchKeyword.isEmpty()) { %>
      搜索 "<strong><%= searchKeyword %></strong>" 的结果，共 <%= selFruits.size() %> 件商品
      <% } else { %>
      共 <%= selFruits.size() %> 件商品
      <% } %>
    </div>

    <% if (selFruits.isEmpty()) { %>
    <div class="empty">
      <div style="font-size:48px; margin-bottom:16px;">🔍</div>
      <h3>没有找到相关商品</h3>
      <p>试试其他关键词吧！</p>
    </div>
    <% } else { %>
    <div class="fruit-grid">
      <% for (Fruit fruit : selFruits) { %>
      <div class="fruit-card">
        <a href="<%= request.getContextPath() %>/FruitServlet?key=info&fid=<%= fruit.getFid() %>">
          <img src="img/fruits/<%= fruit.getFid() %>/(1).jpg" alt="<%= fruit.getFname() %>"/>
        </a>
        <div class="fname">
          <a href="<%= request.getContextPath() %>/FruitServlet?key=info&fid=<%= fruit.getFid() %>"
             style="color:#333; text-decoration:none;"><%= fruit.getFname() %></a>
        </div>
        <div class="fspec"><%= fruit.getSpec() %></div>
        <div class="fprice">¥<%= String.format("%.2f", fruit.getUp()) %></div>
      </div>
      <% } %>
    </div>
    <% } %>
  </div>
</div>

<jsp:include page="footer/footer.jsp"></jsp:include>
</body>
</html>
