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
  if(request.getAttribute("tit2")!=null)
    tit2=(String)request.getAttribute("tit2");
%>
<html>
<head>
  <meta charset="utf-8" />
  <title>水果信息 - 天天果园</title>
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

    // 关注商品 - AJAX 异步请求，不导致页面导航（复用当前页面）
    function addStar(uid, fid) {
      if (uid === 0 || uid === '0') {
        alert("请先登录后再进行操作！");
        window.location.href = ctx + '/login.jsp';
        return;
      }
      var btn = document.getElementById("star");
      if (btn && btn.disabled) {
        return;
      }

      btn.disabled = true;

      var xhr = new XMLHttpRequest();
      xhr.open("POST", ctx + "/FruitServlet?key=favorite&fid=" + fid, true);
      xhr.setRequestHeader("X-Requested-With", "XMLHttpRequest");
      xhr.onreadystatechange = function() {
        if (xhr.readyState === 4) {
          if (xhr.status === 200) {
            try {
              var data = JSON.parse(xhr.responseText);
              if (data.success) {
                btn.value = "已关注";
                btn.style.backgroundColor = "#CCC";
                btn.style.cursor = "auto";
                alert(data.message || "已关注");
              } else {
                btn.disabled = false;
                alert(data.message || "操作失败");
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
            <%=("已关注".equals(tit2) ? "disabled style=\"background-color:#CCC;cursor:auto;\"" : "")%>/></div>
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

  <div class="fruit_hot" >
    <div class="hf_title"><span class="ht_l">热卖商品</span><span class="ht_r"><a href="<%=ctx%>/SELServlet?key=hot">MORE+</a></span></div>
    <%
      int i=1;
      for(Fruit fruits:hotFruits) {
        out.print("    <div class=\"hot_fruit\">\n" +
                "      <div class=\"hf_img\"><a href=\""+ctx+"/FruitServlet?key=info&id="+user.getId()+"&fid="+fruits.getFid()+"\"><img src=\""+ctx+"/img/fruits/"+fruits.getFid()+"/(1).jpg\" onerror=\"this.src='"+ctx+"/img/default.jpg'\"/></a></div>\n" +
                "      <div c=\"hf_text\">\n" +
                "        <div class=\"hf_name\"><a href=\""+ctx+"/FruitServlet?key=info&id="+user.getId()+"&fid="+fruits.getFid()+"\">"+fruits.getFname()+"</a></div>\n" +
                "        <div class=\"hf_mon\">现货：￥<span>"+fruits.getUp()+"</span></div>\n" +
                "      </div>\n" +
                "    </div>");
        i++;
        if(i==4) break;
      }
    %>
  </div>
</div>

<jsp:include page="footer/footer.jsp"></jsp:include>
</body>
</html>