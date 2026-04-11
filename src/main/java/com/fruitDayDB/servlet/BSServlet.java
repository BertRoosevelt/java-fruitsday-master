package com.fruitDayDB.servlet;

import com.fruitDayDB.service.FruitService;
import com.fruitDayDB.service.UserService;
import com.fruitDayDB.vo.Fruit;
import com.fruitDayDB.vo.User;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

/**
 * 后台管理 Servlet（仅管理员可访问）
 */
public class BSServlet extends HttpServlet {

    /** 检查管理员权限，未登录或非管理员则跳转到登录页 */
    private boolean checkAdmin(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        User user = (User) req.getSession().getAttribute("user");
        if (user == null || !user.isAdmin()) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return false;
        }
        return true;
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("text/html;charset=utf-8");
        req.setCharacterEncoding("utf-8");
        doGet(req,resp);
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("text/html;charset=utf-8");
        req.setCharacterEncoding("utf-8");
        if (!checkAdmin(req, resp)) return;

        String key=req.getParameter("key");

        if("alluser".equals(key))
            doAlluser(req,resp);
        else if("deluser".equals(key))
            doDeluser(req,resp);
        else if("adduser".equals(key))
            doAdduser(req,resp);
        else if("upuser".equals(key))
            doUpuser(req,resp);
        else if("finduser".equals(key))
            doFinduser(req, resp);
        else if("allfruit".equals(key))
            doAllfruit(req,resp);
        else if("addfruit".equals(key))
            doAddfruit(req,resp);
        else if("findfruit".equals(key))
            doFindfruit(req,resp);
        else if("delfruit".equals(key))
            doDelfruit(req,resp);
        else if("hotfruit".equals(key))
            doHotfruit(req,resp);
        else if("upfruit".equals(key))
            doUpfruit(req,resp);
        else if("sethot".equals(key))
            doSetHot(req, resp);
        else if("removehot".equals(key))
            doRemoveHot(req, resp);
        else
            resp.sendRedirect(req.getContextPath() + "/BSindex.jsp");

    }
    protected void doUpfruit(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String fname=req.getParameter("fname");
        String spec=req.getParameter("spec");
        double up= Double.parseDouble(req.getParameter("up"));
        String t1=req.getParameter("t1");
        String t2=req.getParameter("t2");
        int inum= Integer.parseInt(req.getParameter("inum"));
        int fid= Integer.parseInt(req.getParameter("fid"));
        Fruit fruit=new Fruit(fid,fname,spec,up,t1,t2,inum);

        FruitService.up(fruit);

        doAllfruit(req,resp);

    }
    protected void doHotfruit(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        List<Fruit> fruits= FruitService.hot();

        req.setAttribute("allfruit",fruits);

        req.getRequestDispatcher("BSindex4.jsp").forward(req, resp);
    }
    protected void doDelfruit(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        int fid= Integer.parseInt(req.getParameter("fid"));

        FruitService.del(fid);

        doAllfruit(req, resp);


    }
    protected void doFindfruit(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        int fid= Integer.parseInt(req.getParameter("fid"));

        Fruit fruit=null;

        fruit=FruitService.info(fid);

        req.setAttribute("fruit",fruit);

        req.getRequestDispatcher("BSindex6.jsp").forward(req, resp);
    }

    protected void doAddfruit(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String fname=req.getParameter("fname");
        String spec=req.getParameter("spec");
        double up= Double.parseDouble(req.getParameter("up"));
        String t1=req.getParameter("t1");
        String t2=req.getParameter("t2");
        int inum= Integer.parseInt(req.getParameter("inum"));
        // fid is AUTO_INCREMENT, so we pass 0 and let DB assign it
        Fruit fruit=new Fruit(fname,spec,up,t1,t2,inum);

        boolean boo=FruitService.add(fruit);

        if(boo)
           doAllfruit(req,resp);
        else
            req.getRequestDispatcher("BSindex5.jsp").forward(req, resp);
    }
    protected void doAllfruit(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        List<Fruit> fruits= FruitService.all();

        req.setAttribute("allfruit",fruits);

        req.getRequestDispatcher("BSindex4.jsp").forward(req, resp);

    }

    protected void doAlluser(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        List<User> users= UserService.alluser();
        System.out.println(users.toString());
        if(users.size()>0||users!=null)
        {
            req.setAttribute("allusers",users);

            req.getRequestDispatcher("BSindex1.jsp").forward(req, resp);
        }


    }

    protected void doDeluser(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        int id=Integer.parseInt(req.getParameter("id"));

        User user=new User(id);

        UserService.del(user);


        doAlluser(req, resp);

    }

    protected void doAdduser(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String uname=req.getParameter("name1");
        String email=req.getParameter("email1");
        String phone=req.getParameter("phone1");
        String pwd=req.getParameter("pwd1");

        User user=new User(email,phone,pwd,uname);

        User boo=UserService.add(user);

        if(boo!=null)
        {
            doAlluser(req,resp);
        }


    }

    protected void doUpuser(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String uname=req.getParameter("name2");
        String email=req.getParameter("email2");
        String phone=req.getParameter("phone2");
        String pwd=req.getParameter("pwd2");
        int id=Integer.parseInt(req.getParameter("id"));

        User user=new User(id,email,phone,pwd,uname);

        boolean ok=UserService.upUser(user);

        doAlluser(req, resp);

    }

    protected void doFinduser(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        int id=Integer.parseInt(req.getParameter("id"));

        User user=UserService.findById(id);

        if(user!=null)
        {
            req.setAttribute("user",user);
        }

        req.getRequestDispatcher("BSindex3.jsp").forward(req, resp);
    }

    protected void doSetHot(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        int fid = Integer.parseInt(req.getParameter("fid"));
        FruitService.setHot(fid);
        doAllfruit(req, resp);
    }

    protected void doRemoveHot(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        int fid = Integer.parseInt(req.getParameter("fid"));
        FruitService.removeHot(fid);
        doAllfruit(req, resp);
    }
}
