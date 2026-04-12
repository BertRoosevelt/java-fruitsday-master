<%--
用户注册页面
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>用户注册 - 水果超市管理系统</title>
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

        .register-container {
            background-color: white;
            padding: 40px;
            border-radius: 10px;
            box-shadow: 0 10px 25px rgba(0,0,0,0.2);
            width: 100%;
            max-width: 400px;
        }

        .register-header {
            text-align: center;
            margin-bottom: 30px;
        }

        .register-header h1 {
            margin: 0;
            color: #333;
            font-size: 28px;
        }

        .register-header p {
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

        .register-button {
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

        .register-button:hover {
            transform: translateY(-2px);
        }

        .register-footer {
            text-align: center;
            margin-top: 20px;
            font-size: 14px;
            color: #666;
        }

        .register-footer a {
            color: #667eea;
            text-decoration: none;
        }
    </style>
</head>
<body>
<div class="register-container">
    <div class="register-header">
        <h1>🍎 水果超市管理系统</h1>
        <p>新用户注册</p>
    </div>

    <form method="POST" action="<%= request.getContextPath() %>/UserServlet?key=register">
        <div class="form-group">
            <label for="email">邮箱 <span style="color: red;">*</span></label>
            <input type="email" id="email" name="email" placeholder="请输入邮箱" required/>
        </div>

        <div class="form-group">
            <label for="phone">手机号</label>
            <input type="text" id="phone" name="phone" placeholder="请输入手机号（可选）"/>
        </div>

        <div class="form-group">
            <label for="pwd">密码 <span style="color: red;">*</span></label>
            <input type="password" id="pwd" name="pwd" placeholder="请输入密码（最少6位）" required/>
        </div>

        <div class="form-group">
            <label for="uname">昵称</label>
            <input type="text" id="uname" name="uname" placeholder="请输入昵称（可选）"/>
        </div>

        <button type="submit" class="register-button">注 册</button>
    </form>

    <div class="register-footer">
        已有账户？<a href="<%= request.getContextPath() %>/login.jsp">立即登录</a>
    </div>
</div>
</body>
</html>