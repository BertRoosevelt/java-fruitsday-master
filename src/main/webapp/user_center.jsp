<%@ page import="com.fruitDayDB.vo.User" %>
<%@ page import="com.fruitDayDB.vo.Order" %>
<%@ page import="com.fruitDayDB.vo.Favorite" %>
<%@ page import="com.fruitDayDB.vo.Fruit" %>
<%@ page import="com.fruitDayDB.service.FruitService" %>
<%@ page import="com.fruitDayDB.service.OrderService" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    User userInfo = (User) request.getAttribute("userInfo");
    if (userInfo == null) {
        userInfo = user;
    }
    String tab = (String) request.getAttribute("tab");
    if (tab == null || tab.trim().isEmpty()) {
        tab = "info";
    }
    String msg = (String) request.getAttribute("msg");
    List<Order> paymentOrders = (List<Order>) request.getAttribute("paymentOrders");
    List<Favorite> favorites = (List<Favorite>) request.getAttribute("favorites");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8"/>
    <title>个人中心 - 天天果园</title>
    <link rel="stylesheet" type="text/css" href="css/main.css"/>
    <style>
        .uc-wrap {max-width: 1050px; margin: 20px auto; display: flex; gap: 20px;}
        .uc-menu {width: 220px; background: #fff; border: 1px solid #e8e8e8; border-radius: 6px; padding: 10px 0;}
        .uc-menu a {display: block; padding: 12px 18px; color: #333; text-decoration: none; border-left: 3px solid transparent;}
        .uc-menu a.active {background: #f7fbff; color: #0275d8; border-left-color: #0275d8; font-weight: bold;}
        .uc-main {flex: 1; background: #fff; border: 1px solid #e8e8e8; border-radius: 6px; padding: 20px;}
        .uc-title {margin: 0 0 16px 0; font-size: 20px;}
        .uc-alert {padding: 10px 14px; border-radius: 4px; margin-bottom: 15px;}
        .uc-success {background: #e8f8ee; color: #1b7a3f; border: 1px solid #b8e5c8;}
        .uc-error {background: #ffecec; color: #b54545; border: 1px solid #ffd0d0;}
        .uc-form-item {margin-bottom: 14px;}
        .uc-form-item label {display: block; margin-bottom: 6px; color: #666; font-size: 13px;}
        .uc-form-item input, .uc-form-item textarea {width: 100%; box-sizing: border-box; border: 1px solid #ddd; border-radius: 4px; padding: 8px 10px; font-size: 14px;}
        .uc-btn {background: #0275d8; color: #fff; border: none; border-radius: 4px; padding: 8px 16px; cursor: pointer;}
        .uc-table {width: 100%; border-collapse: collapse;}
        .uc-table th, .uc-table td {border-bottom: 1px solid #f0f0f0; padding: 10px; text-align: left;}
        .uc-empty {color: #888; padding: 20px 0;}
        .uc-link-btn {display: inline-block; margin-top: 10px; color: #0275d8; text-decoration: none;}
    </style>
</head>
<body>
<jsp:include page="head/head.jsp"></jsp:include>
<div class="uc-wrap">
    <div class="uc-menu">
        <a href="<%= request.getContextPath() %>/UserServlet?key=center&tab=info" class="<%= "info".equals(tab) ? "active" : "" %>">个人信息记录</a>
        <a href="<%= request.getContextPath() %>/UserServlet?key=center&tab=payments" class="<%= "payments".equals(tab) ? "active" : "" %>">支付记录</a>
        <a href="<%= request.getContextPath() %>/UserServlet?key=center&tab=favorites" class="<%= "favorites".equals(tab) ? "active" : "" %>">收藏商品</a>
        <a href="<%= request.getContextPath() %>/UserServlet?key=center&tab=address" class="<%= "address".equals(tab) ? "active" : "" %>">收货地址管理</a>
        <a href="<%= request.getContextPath() %>/UserServlet?key=center&tab=password" class="<%= "password".equals(tab) ? "active" : "" %>">修改密码</a>
    </div>
    <div class="uc-main">
        <% if ("info_success".equals(msg) || "address_success".equals(msg) || "pwd_success".equals(msg)) { %>
        <div class="uc-alert uc-success">操作成功</div>
        <% } %>
        <% if ("info_failed".equals(msg) || "address_failed".equals(msg) || "pwd_failed".equals(msg) || "pwd_empty".equals(msg) || "pwd_not_match".equals(msg) || "pwd_wrong_old".equals(msg)) { %>
        <div class="uc-alert uc-error">操作失败，请检查输入后重试</div>
        <% } %>

        <% if ("info".equals(tab)) { %>
        <h2 class="uc-title">个人信息记录</h2>
        <form method="post" action="<%= request.getContextPath() %>/UserServlet">
            <input type="hidden" name="key" value="updateInfo"/>
            <div class="uc-form-item">
                <label>昵称</label>
                <input type="text" name="uname" value="<%= userInfo.getUname() == null ? "" : userInfo.getUname() %>"/>
            </div>
            <div class="uc-form-item">
                <label>邮箱</label>
                <input type="email" name="email" value="<%= userInfo.getEmail() == null ? "" : userInfo.getEmail() %>" required/>
            </div>
            <div class="uc-form-item">
                <label>手机号</label>
                <input type="text" name="phone" value="<%= userInfo.getPhone() == null ? "" : userInfo.getPhone() %>"/>
            </div>
            <button class="uc-btn" type="submit">保存信息</button>
        </form>
        <% } %>

        <% if ("payments".equals(tab)) { %>
        <h2 class="uc-title">支付记录</h2>
        <% if (paymentOrders == null || paymentOrders.isEmpty()) { %>
        <div class="uc-empty">暂无支付记录</div>
        <% } else { %>
        <table class="uc-table">
            <thead>
            <tr>
                <th>订单号</th>
                <th>金额</th>
                <th>状态</th>
                <th>时间</th>
            </tr>
            </thead>
            <tbody>
            <% for (Order order : paymentOrders) { %>
            <tr>
                <td><a href="<%= request.getContextPath() %>/OrderServlet?key=detail&orderId=<%= order.getId() %>"><%= order.getOrderNumber() %></a></td>
                <td>¥<%= String.format("%.2f", order.getTotalPrice()) %></td>
                <td><%= OrderService.getStatusDisplay(order.getStatus()) %></td>
                <td><%= order.getCreatedAt() %></td>
            </tr>
            <% } %>
            </tbody>
        </table>
        <a class="uc-link-btn" href="<%= request.getContextPath() %>/OrderServlet?key=list">查看全部订单</a>
        <% } %>
        <% } %>

        <% if ("favorites".equals(tab)) { %>
        <h2 class="uc-title">收藏商品</h2>
        <% if (favorites == null || favorites.isEmpty()) { %>
        <div class="uc-empty">暂无收藏商品</div>
        <% } else { %>
        <table class="uc-table">
            <thead>
            <tr>
                <th>商品</th>
                <th>价格</th>
                <th>收藏时间</th>
            </tr>
            </thead>
            <tbody>
            <% for (Favorite favorite : favorites) {
                Fruit fruit = FruitService.info(favorite.getFruitId());
                if (fruit == null) continue;
            %>
            <tr>
                <td><a href="<%= request.getContextPath() %>/FruitServlet?key=info&fid=<%= fruit.getFid() %>"><%= fruit.getFname() %></a></td>
                <td>¥<%= String.format("%.2f", fruit.getUp()) %></td>
                <td><%= favorite.getCreatedAt() %></td>
            </tr>
            <% } %>
            </tbody>
        </table>
        <a class="uc-link-btn" href="<%= request.getContextPath() %>/showstar.jsp">管理收藏</a>
        <% } %>
        <% } %>

        <% if ("address".equals(tab)) { %>
        <h2 class="uc-title">收货地址管理</h2>
        <form method="post" action="<%= request.getContextPath() %>/UserServlet">
            <input type="hidden" name="key" value="updateAddress"/>
            <div class="uc-form-item">
                <label>收货地址</label>
                <textarea name="address" rows="4" placeholder="请输入详细收货地址"><%= userInfo.getAddress() == null ? "" : userInfo.getAddress() %></textarea>
            </div>
            <button class="uc-btn" type="submit">保存地址</button>
        </form>
        <% } %>

        <% if ("password".equals(tab)) { %>
        <h2 class="uc-title">修改密码</h2>
        <form method="post" action="<%= request.getContextPath() %>/UserServlet">
            <input type="hidden" name="key" value="changePwd"/>
            <div class="uc-form-item">
                <label>当前密码</label>
                <input type="password" name="oldPwd" required/>
            </div>
            <div class="uc-form-item">
                <label>新密码</label>
                <input type="password" name="newPwd" required/>
            </div>
            <div class="uc-form-item">
                <label>确认新密码</label>
                <input type="password" name="confirmPwd" required/>
            </div>
            <button class="uc-btn" type="submit">更新密码</button>
        </form>
        <% } %>
    </div>
</div>
<jsp:include page="footer/footer.jsp"></jsp:include>
</body>
</html>
