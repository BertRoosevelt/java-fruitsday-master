<%--
用户登录页面
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <title>用户登陆 - 天天果园 - 水果网购首选品牌</title>
  <link rel="stylesheet" type="text/css" href="css/main.css"/>
  <style>
    body {
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      min-height: 100vh;
      display: flex;
      justify-content: center;
      align-items: center;
      margin: 0;
      font-family: Arial, sans-serif;
    }

    .login-container {
      background-color: white;
      padding: 40px;
      border-radius: 10px;
      box-shadow: 0 10px 25px rgba(0,0,0,0.2);
      width: 100%;
      max-width: 400px;
    }

    .login-header {
      text-align: center;
      margin-bottom: 30px;
    }

    .login-header h1 {
      margin: 0;
      color: #333;
      font-size: 28px;
    }

    .login-header p {
      color: #999;
      font-size: 14px;
      margin: 10px 0 0 0;
    }

    .form-group {
      margin-bottom: 20px;
    }

    .form-group label {
      display: block;
      margin-bottom: 8px;
      color: #333;
      font-weight: bold;
      font-size: 14px;
    }

    .form-group input {
      width: 100%;
      padding: 12px;
      border: 1px solid #ddd;
      border-radius: 5px;
      font-size: 14px;
      box-sizing: border-box;
      transition: border-color 0.3s;
    }

    .form-group input:focus {
      outline: none;
      border-color: #667eea;
      box-shadow: 0 0 5px rgba(102, 126, 234, 0.3);
    }

    .login-button {
      width: 100%;
      padding: 12px;
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      color: white;
      border: none;
      border-radius: 5px;
      font-size: 16px;
      font-weight: bold;
      cursor: pointer;
      transition: transform 0.2s;
    }

    .login-button:hover {
      transform: translateY(-2px);
    }

    .login-button:active {
      transform: translateY(0);
    }

    .login-footer {
      text-align: center;
      margin-top: 20px;
      font-size: 14px;
      color: #666;
    }

    .login-footer a {
      color: #667eea;
      text-decoration: none;
    }

    .login-footer a:hover {
      text-decoration: underline;
    }

    .error-message {
      background-color: #f8d7da;
      color: #721c24;
      padding: 12px;
      border-radius: 5px;
      margin-bottom: 20px;
      display: none;
    }

    .error-message.show {
      display: block;
    }
  </style>
</head>
<body>
<div class="login-container">
  <div class="login-header">
    <h1>🍎 天天果园</h1>
    <p>会员登录</p>
  </div>

  <%-- 错误提示 --%>
  <%
    String error = request.getParameter("error");
    if (error != null) {
  %>
  <div class="error-message show">
    <%
      if ("invalid".equals(error)) {
        out.print("邮箱/手机号或密码错误");
      } else if ("empty".equals(error)) {
        out.print("请填写完整的登录信息");
      }
    %>
  </div>
  <%
    }
  %>

  <form method="POST" action="<%= request.getContextPath() %>/UserServlet?key=login">
    <div class="form-group">
      <label for="str">邮箱 / 手机号</label>
      <input type="text" id="str" name="str" placeholder="请输入邮箱或手机号" required/>
    </div>

    <div class="form-group">
      <label for="pwd">密码</label>
      <input type="password" id="pwd" name="pwd" placeholder="请输入密码" required/>
    </div>

    <button type="submit" class="login-button">登 录</button>
  </form>

  <div class="login-footer">
    还没有账户？<a href="<%= request.getContextPath() %>/reg.jsp">立即注册</a>
  </div>
</div>
</body>
</html>