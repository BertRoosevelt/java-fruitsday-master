<%@ page import="com.fruitDayDB.vo.Fruit" %>
<%@ page import="java.util.List" %>
<%@ page import="com.fruitDayDB.vo.User" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
  String ctx = request.getContextPath();

  Fruit fruit=(Fruit)request.getAttribute("fruit");
  List<Fruit> hotFruits=(List<Fruit>)request.getAttribute("fruits");
  if (hotFruits == null) hotFruits = new java.util.ArrayList<>();

  User user=new User(0);
  if(session.getAttribute("user")!=null) {
    user=(User)session.getAttribute("user");
  }

  String tit1="加入购物车";
  if(request.getAttribute("tit1")!=null)
    tit1=(String)request.getAttribute("tit1");

  String tit2="关注商品";
  boolean isFavorite = Boolean.TRUE.equals(request.getAttribute("isFavorite"));
  if(isFavorite)
    tit2="已关注";
%>
<html>
<head>
  <meta charset="utf-8" />
  <title>水果信息 - 水果超市管理系统</title>
  <link rel="stylesheet" type="text/css" href="<%=ctx%>/css/fruit_info.css"/>
  <link rel="stylesheet" type="text/css" href="<%=ctx%>/css/main.css"/>
  <script src="<%=ctx%>/js/imgs.js" type="text/javascript" charset="utf-8"></script>

  <script>
    var ctx = '<%= ctx %>';

    // 数量加减控制
    function changeNum(type, fid) {
      var numSpan = document.getElementById("num" + fid);
      if (!numSpan) return;
      var current = parseInt(numSpan.innerText) || 1;
      if (type === 1) { // 减
        if (current > 1) numSpan.innerText = current - 1;
      } else { // 加
        numSpan.innerText = current + 1;
      }
    }

    // 加入购物车 - AJAX 异步请求，不导致页面导航（复用当前页面）
    function addCart(uid, fid) {
      if (uid === 0 || uid === '0') {
        alert("请先登录后再进行操作！");
        window.location.href = ctx + '/login.jsp';
        return;
      }
      var btn = document.getElementById("cart");
      if (btn && btn.disabled) {
        return;
      }
      var numSpan = document.getElementById("num" + fid);
      var qty = numSpan ? (parseInt(numSpan.innerText) || 1) : 1;

      btn.disabled = true;

      var xhr = new XMLHttpRequest();
      xhr.open("POST", ctx + "/ShopServlet?key=add&fid=" + fid + "&quantity=" + qty, true);
      xhr.setRequestHeader("X-Requested-With", "XMLHttpRequest");
      xhr.onreadystatechange = function() {
        if (xhr.readyState === 4) {
          if (xhr.status === 200) {
            try {
              var data = JSON.parse(xhr.responseText);
              if (data.success) {
                btn.value = "已加入购物车";
                btn.style.backgroundColor = "#CCC";
                btn.style.cursor = "auto";
                alert(data.message || "已加入购物车");
              } else {
                btn.disabled = false;
                alert(data.message || "加入购物车失败");
              }
            } catch(e) {
              btn.disabled = false;
              alert("操作失败，请重试");
            }
          } else {
            btn.disabled = false;
            alert("操作失败，请重试");
          }
        }
      };
      xhr.send();
    }

    // 关注商品 - AJAX 异步请求，支持关注/取消关注切换
    function addStar(uid, fid) {
      if (uid === 0 || uid === '0') {
        alert("请先登录后再进行操作！");
        window.location.href = ctx + '/login.jsp';
        return;
      }
      var btn = document.getElementById("star");

      var xhr = new XMLHttpRequest();
      xhr.open("POST", ctx + "/FruitServlet?key=favorite&fid=" + fid, true);
      xhr.setRequestHeader("X-Requested-With", "XMLHttpRequest");
      xhr.onreadystatechange = function() {
        if (xhr.readyState === 4) {
          if (xhr.status === 200) {
            try {
              var data = JSON.parse(xhr.responseText);
              if (data.success) {
                if (data.favorited) {
                  btn.value = "已关注";
                  btn.style.backgroundColor = "#CCC";
                  btn.style.cursor = "pointer";
                  btn.setAttribute('data-favorited', 'true');
                } else {
                  btn.value = "关注商品";
                  btn.style.backgroundColor = "";
                  btn.style.cursor = "";
                  btn.setAttribute('data-favorited', 'false');
                }
              } else {
                alert(data.message || "操作失败");
              }
            } catch(e) {
              alert("操作失败，请重试");
            }
          } else {
            alert("操作失败，请重试");
          }
        }
      };
      xhr.send();
    }
  </script>
</head>
<body onload="show()">
<jsp:include page="head/head.jsp"></jsp:include>

<div class="fruit_info">
  <div class="img_box">
    <%
      String cname="show";
      int imgCount = Math.min(fruit.getInum(), 3);
      if (imgCount < 1) imgCount = 1;
      for(int i=1;i<=imgCount;i++)
      {
        out.println("<div id=\"p"+(i-1)+"\" class=\"" + cname + "\"><img src=\"" + ctx + "/img/fruits/" + fruit.getFid() + "/(" + i + ").jpg\" onerror=\"this.src='"+ctx+"/img/default.jpg'\"/></div>");
        cname="non";
      }
    %>

    <div class="img_to">
      <ul >
        <%
          for(int i=1;i<=imgCount;i++)
          {
            out.print("<li><img src=\"" + ctx + "/img/fruits/"+fruit.getFid()+"/("+i+").jpg\" id=\"s"+(i-1)+"\" onMouseMove=\"himg(this.id)\" onerror=\"this.src='"+ctx+"/img/default.jpg'\"/></li>");
          }
        %>
      </ul>
    </div>
  </div>

  <div class="fruit_text">
    <div class="fname"><%=fruit.getFname()%></div>
    <p>&nbsp;</p>
    <div class="spec"><input type="radio" checked="checked" name="fnum_radio" value="fnum_radio" /><%=fruit.getSpec()%></div>
    <div class="up">￥<%=fruit.getUp()%></div>
    <div class="fid">商品编号:<%=fruit.getFid()%></div>
    <hr />

    <form method="post" id="fform">
      <div class="fform">
        <div class="fform1">
          <div class="Uaddress">配送至 :
            <select name="address" id="sel">
              <option value="上海">上海</option>
              <option value="吉林">吉林</option>
              <option value="山西">山西</option>
              <option value="北京">北京</option>
            </select>
          </div>
          <!-- 数量操作区修改绑定的JS函数 -->
          <div class="Unum">
            <span id="numl" onclick="changeNum(1,<%=fruit.getFid()%>)">-</span>
            <span id="num<%=fruit.getFid()%>">1</span>
            <span id="numr" onclick="changeNum(0,<%=fruit.getFid()%>)">+</span>
          </div>
        </div>
        <div class="btn-row">
          <div class="Uadd"><input type="button" name="add" id="cart" value="<%=tit1%>" onclick="addCart(<%=user.getId()%>,<%=fruit.getFid()%>)"
                  <%=("已加入购物车".equals(tit1) ? "disabled style=\"background-color:#CCC;cursor:auto;\"" : "")%>/></div>
          <div class="starbutton"><input type="button" name="add" id="star" value="<%=tit2%>" onclick="addStar(<%=user.getId()%>,<%=fruit.getFid()%>)"
                                         data-favorited="<%=isFavorite%>"
                  <%=(isFavorite ? "style=\"background-color:#CCC;cursor:pointer;\"" : "")%>/></div>
        </div>
      </div>
    </form>

    <hr />
    <div class="finfo">
      <h3>商品简介</h3>
      <p id="finfo_text"><%=fruit.getT1()%></p>
    </div>
    <hr />
    <div class="fpro">
      <h3>温馨提示</h3>
      <p id="fpro_text"><%=fruit.getT2()%></p>
    </div>
    <hr />
  </div>

  <div class="fruit_hot">
    <div class="hf_title"><span class="ht_l">用户评价</span><span class="ht_r" style="font-size: 12px; color: #999;">好评率 99%</span></div>

    <style>
      .review_box {
        width: 100%;
        height: 480px; /* 大约显示6条评价 */
        overflow: hidden; /* 隐藏超出部分 */
        background: #fdfdfd;
        border: 1px solid #eee;
        padding: 0;
        cursor: pointer;
      }
      .review_list {
        list-style: none;
        padding: 0;
        margin: 0;
      }
      .review_item {
        padding: 12px 15px;
        border-bottom: 1px dashed #eaeaea;
        box-sizing: border-box;
      }
      .rev_top {
        display: flex;
        justify-content: space-between;
        font-size: 12px;
        color: #888;
        margin-bottom: 6px;
      }
      .rev_user {
        color: #e4393c;
        font-weight: bold;
      }
      .rev_content {
        font-size: 13px;
        color: #333;
        line-height: 1.6;
      }
    </style>

    <div class="review_box" id="reviewBox">
      <ul class="review_list" id="reviewList">
        <!-- JS将动态填充此处 -->
      </ul>
    </div>

    <script>
      // 评价词库
      var subjects = ["水果", "果肉", "包装", "物流", "味道", "整体"];
      var adjs = ["非常新鲜", "个头很大", "口感极佳", "水分很足", "甜度爆表", "物超所值", "精美无损", "非常满意"];
      var actions = ["强烈推荐！", "下次还会回购。", "家里人都很喜欢吃。", "送礼也很合适~", "完全超出了预期。", "值得购买！"];
      var firstNames = ["赵", "钱", "孙", "李", "周", "吴", "郑", "王", "刘", "陈", "张"];

      // 随机生成一条评价数据
      function generateReview() {
        var user = firstNames[Math.floor(Math.random() * firstNames.length)] + "***" + Math.floor(Math.random() * 10);
        var date = new Date(new Date().getTime() - Math.random() * 10000000000);
        var dateStr = date.getFullYear() + "-" + String(date.getMonth() + 1).padStart(2, '0') + "-" + String(date.getDate()).padStart(2, '0');

        var s = subjects[Math.floor(Math.random() * subjects.length)];
        var a = adjs[Math.floor(Math.random() * adjs.length)];
        var act = actions[Math.floor(Math.random() * actions.length)];
        var content = "这家的" + s + a + "，" + act;

        return { user: user, date: dateStr, content: content };
      }

      // 创建 DOM 节点
      function createReviewLi(data) {
        var li = document.createElement("li");
        li.className = "review_item";
        li.innerHTML =
                '<div class="rev_top">' +
                '<span class="rev_user">' + data.user + '</span>' +
                '<span class="rev_date">' + data.date + '</span>' +
                '</div>' +
                '<div class="rev_content">' + data.content + '</div>';
        return li;
      }

      var list = document.getElementById("reviewList");
      var reviewBox = document.getElementById("reviewBox");

      // 初始加载 8 条数据保证足够填满可视区域
      for (var i = 0; i < 8; i++) {
        list.appendChild(createReviewLi(generateReview()));
      }

      // 使用 transform 平滑滚动
      var offset = 0;
      var scrollSpeed = 0.5; // 控制滚动快慢
      var isHover = false;   // 鼠标悬停标记

      // 鼠标进入暂停滚动，方便用户阅读
      reviewBox.addEventListener("mouseenter", function() {
        isHover = true;
      });
      reviewBox.addEventListener("mouseleave", function() {
        isHover = false;
      });

      function doScroll() {
        if (!isHover) {
          offset += scrollSpeed;
          var firstItem = list.children[0];

          // 当偏移量大于等于第一条评论的高度时，进行无缝切换
          if (firstItem && offset >= firstItem.offsetHeight) {
            // 减去单个节点高度，保留余数，消除闪动
            offset -= firstItem.offsetHeight;
            list.removeChild(firstItem);
            list.appendChild(createReviewLi(generateReview()));
          }

          // 硬件加速，提升渲染性能，防止闪屏
          list.style.transform = "translateY(-" + offset + "px)";
        }

        requestAnimationFrame(doScroll);
      }

      // 启动平滑滚动
      requestAnimationFrame(doScroll);
    </script>
  </div>
</div>

<jsp:include page="footer/footer.jsp"></jsp:include>
</body>
</html>