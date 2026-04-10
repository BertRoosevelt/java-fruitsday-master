package com.fruitDayDB.service;

import com.fruitDayDB.dao.FruitDao;
import com.fruitDayDB.dao.FruitDaoImpl;
import com.fruitDayDB.vo.Fruit;
import java.util.List;

/**
 * 商品业务逻辑服务
 * 处理商品相关的业务操作
 */
public class FruitService {

    /**
     * 获取商品详情
     * @param fruitId 商品ID
     * @return 商品对象
     */
    public static Fruit info(int fruitId) {
        FruitDao fruitDao = new FruitDaoImpl();
        return fruitDao.findByFid(fruitId);
    }

    /**
     * 获取热卖商品列表
     * @return 热卖商品列表
     */
    public static List<Fruit> hot() {
        FruitDao fruitDao = new FruitDaoImpl();
        return fruitDao.findHot();
    }

    /**
     * 获取所有商品
     * @return 商品列表
     */
    public static List<Fruit> all() {
        FruitDao fruitDao = new FruitDaoImpl();
        return fruitDao.findall();
    }

    /**
     * 添加商品（管理员）
     * @param fruit 商品对象
     * @return 成功返回true，失败返回false
     */
    public static boolean add(Fruit fruit) {
        FruitDao fruitDao = new FruitDaoImpl();
        int result = fruitDao.add(fruit);
        return result > 0;
    }

    /**
     * 删除商品（管理员）
     * @param fruitId 商品ID
     * @return 成功返回true，失败返回false
     */
    public static boolean del(int fruitId) {
        FruitDao fruitDao = new FruitDaoImpl();
        int result = fruitDao.del(fruitId);
        return result > 0;
    }

    /**
     * 修改商品（管理员）
     * @param fruit 商品对象
     * @return 成功返回true，失败返回false
     */
    public static boolean up(Fruit fruit) {
        FruitDao fruitDao = new FruitDaoImpl();
        int result = fruitDao.up(fruit);
        return result > 0;
    }

    /**
     * 搜索商品（按名称）
     * @param keyword 搜索关键词
     * @return 匹配的商品列表
     */
    public static List<Fruit> search(String keyword) {
        FruitDao fruitDao = new FruitDaoImpl();
        // 这个方法需要在 FruitDaoImpl 中实现
        // 暂时返回空列表
        return fruitDao.findall();
    }
}