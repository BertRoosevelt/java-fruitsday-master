package com.fruitDayDB.servlet;

import com.fruitDayDB.service.UserService;
import com.fruitDayDB.vo.User;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * 用户 Servlet
 * 处理用户相关的所有请求
 */
public class UserServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        doPost(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("text/html;charset=utf-8");
        req.setCharacterEncoding("utf-8");

        String key = req.getParameter("key");

        if (key == null || key.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/index.jsp");
            return;
        }

        switch (key) {
            case "login":
                doLogin(req, resp);
                break;
            case "logout":
                doLogout(req, resp);
                break;
            case "register":
                doRegister(req, resp);
                break;
            default:
                resp.sendRedirect(req.getContextPath() + "/index.jsp");
        }
    }

    /**
     * 处理登录
     */
    private void doLogin(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String str = req.getParameter("str");
        String pwd = req.getParameter("pwd");

        if (str == null || str.isEmpty() || pwd == null || pwd.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp?error=empty");
            return;
        }

        boolean isEmail = str.contains("@");

        try {
            User user = UserService.login(str, pwd, isEmail);

            if (user != null) {
                req.getSession().setAttribute("user", user);
                // 管理员跳转到后台，普通用户跳转到首页
                if (user.isAdmin()) {
                    resp.sendRedirect(req.getContextPath() + "/BSindex.jsp");
                } else {
                    resp.sendRedirect(req.getContextPath() + "/index.jsp");
                }
            } else {
                resp.sendRedirect(req.getContextPath() + "/login.jsp?error=invalid");
            }
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/login.jsp?error=invalid");
        }
    }

    /**
     * 处理退出登录
     */
    private void doLogout(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getSession().invalidate();
        resp.sendRedirect(req.getContextPath() + "/index.jsp");
    }

    /**
     * 处理注册
     */
    private void doRegister(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String email = req.getParameter("email");
        String phone = req.getParameter("phone");
        String pwd = req.getParameter("pwd");
        String uname = req.getParameter("uname");

        if (email == null || email.isEmpty() || pwd == null || pwd.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/reg.jsp?error=empty");
            return;
        }

        try {
            User newUser = new User();
            newUser.setEmail(email);
            newUser.setPhone(phone);
            newUser.setPwd(pwd);
            newUser.setUname(uname != null && !uname.isEmpty() ? uname : email);

            User user = UserService.add(newUser);

            if (user != null) {
                req.getSession().setAttribute("user", user);
                resp.sendRedirect(req.getContextPath() + "/index.jsp");
            } else {
                resp.sendRedirect(req.getContextPath() + "/reg.jsp?error=failed");
            }
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/reg.jsp?error=failed");
        }
    }
}