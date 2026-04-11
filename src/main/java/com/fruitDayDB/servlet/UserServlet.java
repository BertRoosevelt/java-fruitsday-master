package com.fruitDayDB.servlet;

import com.fruitDayDB.service.FavoriteService;
import com.fruitDayDB.service.OrderService;
import com.fruitDayDB.service.UserService;
import com.fruitDayDB.vo.Favorite;
import com.fruitDayDB.vo.Order;
import com.fruitDayDB.vo.User;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

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
            case "center":
                doUserCenter(req, resp);
                break;
            case "updateInfo":
                doUpdateInfo(req, resp);
                break;
            case "updateAddress":
                doUpdateAddress(req, resp);
                break;
            case "changePwd":
                doChangePassword(req, resp);
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
            newUser.setAddress("");

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

    /**
     * 个人中心页面
     */
    private void doUserCenter(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User loginUser = (User) req.getSession().getAttribute("user");
        if (loginUser == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        User userInfo = UserService.findById(loginUser.getId());
        if (userInfo == null) {
            userInfo = loginUser;
        }

        List<Order> orders = OrderService.getUserOrders(loginUser.getId());
        List<Order> paymentOrders = new ArrayList<>();
        for (Order order : orders) {
            if ("paid".equals(order.getStatus()) || "shipped".equals(order.getStatus()) || "completed".equals(order.getStatus())) {
                paymentOrders.add(order);
            }
        }

        List<Favorite> favorites = FavoriteService.getFavorites(loginUser.getId());

        req.setAttribute("userInfo", userInfo);
        req.setAttribute("paymentOrders", paymentOrders);
        req.setAttribute("favorites", favorites);
        req.setAttribute("tab", req.getParameter("tab"));
        req.setAttribute("msg", req.getParameter("msg"));
        req.getRequestDispatcher("/user_center.jsp").forward(req, resp);
    }

    /**
     * 更新个人信息
     */
    private void doUpdateInfo(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        User loginUser = (User) req.getSession().getAttribute("user");
        if (loginUser == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        String email = req.getParameter("email");
        String phone = req.getParameter("phone");
        String uname = req.getParameter("uname");

        if (email == null || email.trim().isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/UserServlet?key=center&tab=info&msg=info_failed");
            return;
        }

        User dbUser = UserService.findByEmail(loginUser.getEmail());
        if (dbUser == null) {
            resp.sendRedirect(req.getContextPath() + "/UserServlet?key=logout");
            return;
        }

        dbUser.setEmail(email.trim());
        dbUser.setPhone(phone != null ? phone.trim() : "");
        dbUser.setUname((uname == null || uname.trim().isEmpty()) ? email.trim() : uname.trim());

        boolean success = UserService.upUser(dbUser);
        if (success) {
            User refreshed = UserService.login(dbUser.getEmail(), dbUser.getPwd(), true);
            if (refreshed != null) {
                req.getSession().setAttribute("user", refreshed);
            }
            resp.sendRedirect(req.getContextPath() + "/UserServlet?key=center&tab=info&msg=info_success");
        } else {
            resp.sendRedirect(req.getContextPath() + "/UserServlet?key=center&tab=info&msg=info_failed");
        }
    }

    /**
     * 更新收货地址
     */
    private void doUpdateAddress(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        User loginUser = (User) req.getSession().getAttribute("user");
        if (loginUser == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        User dbUser = UserService.findByEmail(loginUser.getEmail());
        if (dbUser == null) {
            resp.sendRedirect(req.getContextPath() + "/UserServlet?key=logout");
            return;
        }

        String address = req.getParameter("address");
        dbUser.setAddress(address != null ? address.trim() : "");

        boolean success = UserService.upUser(dbUser);
        if (success) {
            User refreshed = UserService.login(dbUser.getEmail(), dbUser.getPwd(), true);
            if (refreshed != null) {
                req.getSession().setAttribute("user", refreshed);
            }
            resp.sendRedirect(req.getContextPath() + "/UserServlet?key=center&tab=address&msg=address_success");
        } else {
            resp.sendRedirect(req.getContextPath() + "/UserServlet?key=center&tab=address&msg=address_failed");
        }
    }

    /**
     * 修改密码
     */
    private void doChangePassword(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        User loginUser = (User) req.getSession().getAttribute("user");
        if (loginUser == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        String oldPwd = req.getParameter("oldPwd");
        String newPwd = req.getParameter("newPwd");
        String confirmPwd = req.getParameter("confirmPwd");

        if (oldPwd == null || newPwd == null || confirmPwd == null ||
                oldPwd.trim().isEmpty() || newPwd.trim().isEmpty() || confirmPwd.trim().isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/UserServlet?key=center&tab=password&msg=pwd_empty");
            return;
        }

        if (!newPwd.equals(confirmPwd)) {
            resp.sendRedirect(req.getContextPath() + "/UserServlet?key=center&tab=password&msg=pwd_not_match");
            return;
        }

        User verify = UserService.login(loginUser.getEmail(), oldPwd, true);
        if (verify == null) {
            resp.sendRedirect(req.getContextPath() + "/UserServlet?key=center&tab=password&msg=pwd_wrong_old");
            return;
        }

        boolean success = UserService.updatePassword(loginUser.getId(), newPwd);
        if (success) {
            User refreshed = UserService.login(loginUser.getEmail(), newPwd, true);
            if (refreshed != null) {
                req.getSession().setAttribute("user", refreshed);
            }
            resp.sendRedirect(req.getContextPath() + "/UserServlet?key=center&tab=password&msg=pwd_success");
        } else {
            resp.sendRedirect(req.getContextPath() + "/UserServlet?key=center&tab=password&msg=pwd_failed");
        }
    }
}
