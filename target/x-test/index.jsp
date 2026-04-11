<%@ page import="com.fruitDayDB.vo.User" %>
<%@ page import="java.util.List" %>
<%@ page import="com.fruitDayDB.vo.Fruit" %>
<%@ page import="com.fruitDayDB.service.FruitService" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
  String ctx = request.getContextPath();

  // 1. 获取当前登录用户
  User user = new User(0);
  if (session.getAttribute("user") != null) {
    user = (User) session.getAttribute("user");
  }
  int uid = user.getId();

  // 2. 加载热门商品（增加容错）
  List<Fruit> hotFruits = null;
  String loadError = null;
  try {
    hotFruits = (List<Fruit>) request.getAttribute("fruits");
    if (hotFruits == null) {
      hotFruits = FruitService.hot();
    }
  } catch (Throwable t) {
    loadError = t.getClass().getName() + (t.getMessage() != null ? (": " + t.getMessage()) : "");
  }
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
  <meta charset="utf-8" />
  <title>天天果园 - 水果网购首选品牌</title>
  <link rel="stylesheet" type="text/css" href="<%=ctx%>/css/main.css"/>
  <!-- 保留旧的js用于其他页面可能依赖的内容，但首页轮播不再依赖它 -->
  <script src="<%=ctx%>/js/imgs.js" type="text/javascript" charset="utf-8"></script>

  <style>
    /* ================= 首页专属现代化UI ================= */
    body { background-color: #f4f4f4; font-family: "PingFang SC", "Microsoft YaHei", sans-serif; }
    .wrapper { max-width: 1200px; margin: 0 auto; }

    /* --- Banner 模块 --- */
    .modern-banner-wrap { width: 100%; background: #fff; margin-bottom: 30px; }
    .modern-banner { position: relative; width: 100%; height: 460px; overflow: hidden; display: flex; justify-content: center; background: #e9ecef; }
    .modern-banner .slide { position: absolute; top:0; left:0; width: 100%; height: 100%; opacity: 0; transition: opacity 0.6s ease-in-out; z-index: 1; }
    .modern-banner .slide.show { opacity: 1; z-index: 2; }
    .modern-banner .slide a { display: block; width: 100%; height: 100%; }
    .modern-banner .slide img { width: 100%; height: 100%; object-fit: cover; object-position: center; }

    /* 轮播指示器 */
    .banner-indicators { position: absolute; bottom: 20px; left: 50%; transform: translateX(-50%); z-index: 10; display: flex; gap: 10px; background: rgba(0,0,0,0.2); padding: 6px 14px; border-radius: 20px; }
    .banner-indicators span { width: 12px; height: 12px; background: rgba(255,255,255,0.6); border-radius: 50%; cursor: pointer; transition: all 0.3s; }
    .banner-indicators span:hover, .banner-indicators span.active { background: #669933; transform: scale(1.2); }

    /* --- 热门商品模块 --- */
    .section-header { text-align: center; margin: 40px 0 30px; position: relative; }
    .section-header h2 { font-size: 28px; color: #333; font-weight: bold; margin: 0 0 10px; letter-spacing: 2px; }
    .section-header p { font-size: 14px; color: #999; }
    .section-header::after { content: ""; display: block; width: 60px; height: 3px; background: #669933; margin: 15px auto 0; border-radius: 2px; }

    .product-grid { display: grid; grid-template-columns: repeat(5, 1fr); gap: 20px; padding-bottom: 60px; }
    .product-card { background: #fff; border-radius: 8px; overflow: hidden; transition: all 0.3s ease; display: block; text-decoration: none; position: relative; }
    .product-card:hover { transform: translateY(-5px); box-shadow: 0 15px 30px rgba(0,0,0,0.1); }

    .product-img-box { width: 100%; height: 230px; overflow: hidden; background: #f9f9f9; position: relative; }
    .product-img-box img { width: 100%; height: 100%; object-fit: cover; transition: transform 0.5s; }
    .product-card:hover .product-img-box img { transform: scale(1.05); }

    .product-info { padding: 15px; text-align: left; }
    .product-name { font-size: 16px; color: #333; font-weight: 500; margin-bottom: 6px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
    .product-spec { font-size: 13px; color: #888; margin-bottom: 12px; height: 18px; overflow: hidden; }
    .product-bottom { display: flex; justify-content: space-between; align-items: center; }
    .product-price { color: #ff5000; font-size: 20px; font-weight: bold; }
    .product-price small { font-size: 14px; margin-right: 2px; }

    /* 购买按钮 */
    .buy-btn { width: 32px; height: 32px; background: #669933; border-radius: 50%; display: flex; align-items: center; justify-content: center; transition: background 0.2s; color: #fff; font-weight: bold; font-size: 18px; line-height: 1; }
    .product-card:hover .buy-btn { background: #55802b; }

    /* 错误提示框 */
    .error-alert { background: #fff3cd; color: #856404; padding: 15px; border-radius: 6px; margin: 20px 0; border: 1px solid #ffeeba; }
    .empty-state { text-align: center; padding: 80px 0; color: #999; font-size: 16px; background: #fff; border-radius: 8px; }
  </style>
</head>
<body>

<!-- 引入公共头部 -->
<jsp:include page="head/head.jsp"></jsp:include>

<!-- 1. 现代化巨幅海报 Banner (点击前往热卖页) -->
<div class="modern-banner-wrap">
  <div class="modern-banner" id="banner-container">
    <div class="slide show"><a href="<%=ctx%>/SELServlet?key=hot"><img src="<%=ctx%>/img/index/h0.jpg" alt="天天果园活动1" onerror="this.src='<%=ctx%>/img/default-banner.jpg'"/></a></div>
    <div class="slide"><a href="<%=ctx%>/SELServlet?key=hot"><img src="<%=ctx%>/img/index/h1.jpg" alt="天天果园活动2" onerror="this.src='<%=ctx%>/img/default-banner.jpg'"/></a></div>
    <div class="slide"><a href="<%=ctx%>/SELServlet?key=hot"><img src="<%=ctx%>/img/index/h2.jpg" alt="天天果园活动3" onerror="this.src='<%=ctx%>/img/default-banner.jpg'"/></a></div>
    <div class="slide"><a href="<%=ctx%>/SELServlet?key=hot"><img src="<%=ctx%>/img/index/h3.jpg" alt="天天果园活动4" onerror="this.src='<%=ctx%>/img/default-banner.jpg'"/></a></div>
    <div class="slide"><a href="<%=ctx%>/SELServlet?key=hot"><img src="<%=ctx%>/img/index/h4.jpg" alt="天天果园活动5" onerror="this.src='<%=ctx%>/img/default-banner.jpg'"/></a></div>

    <div class="banner-indicators" id="banner-indicators">
      <span class="active"></span>
      <span></span>
      <span></span>
      <span></span>
      <span></span>
    </div>
  </div>
</div>

<div class="wrapper">
  <!-- 容错：如果数据库连接失败，展示提示而不是页面崩溃 -->
  <% if (loadError != null) { %>
  <div class="error-alert">
    <strong>系统异常：</strong> 此刻无法加载商品数据。详细原因：<%= loadError %>
  </div>
  <% } %>

  <!-- 2. 热门商品精选列表 -->
  <div class="section-header">
    <h2>热卖甄选</h2>
    <p>大家都在买的当季新鲜好果</p>
  </div>

  <% if (hotFruits != null && !hotFruits.isEmpty()) { %>
  <div class="product-grid">
    <% for (Fruit fruit : hotFruits) { %>
    <a href="<%=ctx%>/FruitServlet?key=info&id=<%= uid %>&fid=<%= fruit.getFid() %>" class="product-card">
      <div class="product-img-box">
        <img src="<%=ctx%>/img/fruits/<%= fruit.getFid() %>/(1).jpg"
             alt="<%= fruit.getFname() %>"
             onerror="this.onerror=null;this.src='<%=ctx%>/img/default.jpg'"/>
      </div>
      <div class="product-info">
        <div class="product-name"><%= fruit.getFname() %></div>
        <div class="product-spec"><%= fruit.getSpec() != null ? fruit.getSpec() : "精选佳品" %></div>
        <div class="product-bottom">
          <div class="product-price"><small>¥</small><%= String.format("%.2f", fruit.getUp()) %></div>
          <div class="buy-btn" title="查看详情">+</div>
        </div>
      </div>
    </a>
    <% } %>
  </div>
  <% } else if (loadError == null) { %>
  <div class="empty-state">
    暂无热卖商品数据，敬请期待！
  </div>
  <% } %>
</div>

<!-- 引入公共尾部 -->
<jsp:include page="footer/footer.jsp"></jsp:include>

<!-- ===== 轮播图控制脚本 ===== -->
<script>
  document.addEventListener("DOMContentLoaded", function() {
    const slides = document.querySelectorAll('.modern-banner .slide');
    const indicators = document.querySelectorAll('.banner-indicators span');
    const bannerContainer = document.getElementById('banner-container');
    let currentIndex = 0;
    let timer = null;

    if (slides.length === 0) return;

    // 切换到指定索引的图片
    function showSlide(index) {
      slides[currentIndex].classList.remove('show');
      indicators[currentIndex].classList.remove('active');
      currentIndex = index;
      slides[currentIndex].classList.add('show');
      indicators[currentIndex].classList.add('active');
    }

    // 播放下一张
    function nextSlide() {
      let nextIndex = (currentIndex + 1) % slides.length;
      showSlide(nextIndex);
    }

    // 启动定时器 (每 3000ms 切换)
    function startAutoPlay() {
      if (!timer) {
        timer = setInterval(nextSlide, 3000);
      }
    }

    // 停止定时器
    function stopAutoPlay() {
      if (timer) {
        clearInterval(timer);
        timer = null;
      }
    }

    // 绑定指示器悬浮事件
    indicators.forEach((indicator, index) => {
      indicator.addEventListener('mouseenter', () => {
        stopAutoPlay();
        showSlide(index);
      });
    });

    // 鼠标进入区域停止轮播，移出继续
    bannerContainer.addEventListener('mouseenter', stopAutoPlay);
    bannerContainer.addEventListener('mouseleave', startAutoPlay);

    // 启动轮播
    startAutoPlay();
  });
</script>

</body>
</html>