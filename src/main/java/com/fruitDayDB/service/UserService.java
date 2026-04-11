package com.fruitDayDB.service;

import com.fruitDayDB.dao.UserDao;
import com.fruitDayDB.dao.UserDaoImpl;
import com.fruitDayDB.vo.User;
import java.util.List;

/**
 * 用户业务逻辑服务
 * 处理用户相关的所有业务操作
 */
public class UserService {

    /**
     * 添加新用户
     * @param user 用户对象
     * @return 新用户对象（成功）或 null（失败）
     */
    public static User add(User user) {
        UserDao userDao = new UserDaoImpl();
        int num = userDao.add(user);

        if (num == 1) {
            // 用户添加成���，自动登录
            User newUser = UserService.login(user.getEmail(), user.getPwd(), true);

            if (newUser != null) {
                // 登录成功
                return newUser;
            } else {
                // 登录失败，删除已创建的用户
                UserService.del(user);
                return null;
            }
        }

        return null;
    }

    /**
     * 用户登录
     * @param str 邮箱或手机号
     * @param pwd 密码
     * @param isEmail 是否按邮箱查询（true=邮箱，false=手机）
     * @return 用户对象（成功）或 null（失败）
     */
    public static User login(String str, String pwd, boolean isEmail) {
        UserDao userDao = new UserDaoImpl();
        User user = userDao.findByStr(str, isEmail);

        if (user == null) {
            return null;
        }

        // 密码验证
        if (pwd != null && pwd.equals(user.getPwd())) {
            // 验证成功，隐藏密码后返回
            user.setPwd("******");
            return user;
        }

        return null;
    }

    /**
     * 删除用户
     * @param user 用户对象
     * @return 成功返回 true，失败返回 false
     */
    public static boolean del(User user) {
        UserDao userDao = new UserDaoImpl();
        int num = userDao.del(user);
        return num == 1;
    }

    /**
     * 获取所有用户
     * @return 用户列表
     */
    public static List<User> alluser() {
        UserDao userDao = new UserDaoImpl();
        return userDao.findAll();
    }

    /**
     * 获取管理员列表
     * @return 管理员用户ID列表
     */
    public static List<Integer> root() {
        UserDao userDao = new UserDaoImpl();
        return userDao.root();
    }

    /**
     * 更新用户信息
     * @param user 用户对象
     * @return 成功返回 true，失败返回 false
     */
    public static boolean upUser(User user) {
        UserDao userDao = new UserDaoImpl();
        int num = userDao.update(user);
        return num == 1;
    }

    /**
     * 修改用户密码
     * @param userId 用户ID
     * @param newPwd 新密码
     * @return 成功返回 true，失败返回 false
     */
    public static boolean updatePassword(int userId, String newPwd) {
        UserDao userDao = new UserDaoImpl();
        User user = new User();
        user.setId(userId);
        user.setPwd(newPwd);
        int num = userDao.upPwd(user);
        return num == 1;
    }

    /**
     * 根据 ID 查询用户
     * @param id 用户 ID
     * @return 用户对象
     */
    public static User findById(int id) {
        UserDao userDao = new UserDaoImpl();
        return userDao.findById(id);
    }

    /**
     * 根据邮箱查询用户
     * @param email 邮箱
     * @return 用户对象
     */
    public static User findByEmail(String email) {
        UserDao userDao = new UserDaoImpl();
        return userDao.findByStr(email, true);
    }

    /**
     * 根据手机号查询用户
     * @param phone 手机号
     * @return 用户对象
     */
    public static User findByPhone(String phone) {
        UserDao userDao = new UserDaoImpl();
        return userDao.findByStr(phone, false);
    }

    /**
     * 检查邮箱是否已被注册
     * @param email 邮箱
     * @return 已注册返回 true，未注册返回 false
     */
    public static boolean isEmailExists(String email) {
        User user = findByEmail(email);
        return user != null;
    }

    /**
     * 检查手机号是否已被注册
     * @param phone 手机号
     * @return 已注册返回 true，未注册返回 false
     */
    public static boolean isPhoneExists(String phone) {
        User user = findByPhone(phone);
        return user != null;
    }
}
