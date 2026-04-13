# 快速开始指南（QUICK_START）

> 天天果园 FruitDay 水果销售电商系统  
> 面向：新接手项目的开发者（预计 10 分钟内启动）

---

## 目录

1. [环境配置检查清单](#1-环境配置检查清单)
2. [一键启动步骤](#2-一键启动步骤)
3. [登录凭证和测试数据](#3-登录凭证和测试数据)
4. [常用快捷URL链接](#4-常用快捷url链接)

---

## 1. 环境配置检查清单

在启动项目前，请逐项确认以下环境依赖：

### 1.1 必须工具

| 工具 | 推荐版本 | 检查命令 | 备注 |
|------|---------|---------|------|
| JDK | 17（pom.xml 指定） | `java -version` | 需 ≥ JDK 8 |
| Maven | 3.6+ | `mvn -version` | 用于构建项目 |
| MySQL | 5.7 / 8.0 | `mysql --version` | 数据库服务 |
| Tomcat | 8.5 / 9.0 | 查看安装目录 | Web 服务器 |

### 1.2 推荐工具（可选）

| 工具 | 用途 |
|------|------|
| IntelliJ IDEA / Eclipse | 开发 IDE（项目已含 .idea 和 .project 配置） |
| Navicat for MySQL | 数据库可视化管理 |
| Google Chrome | 调试前端页面 |

### 1.3 环境检查命令

```bash
# 检查 JDK 版本
java -version
# 期望输出：java version "17.x.x" 或 openjdk version "17..."

# 检查 Maven
mvn -version
# 期望输出：Apache Maven 3.x.x

# 检查 MySQL 是否运行中
# Windows:
sc query mysql

# Linux/Mac:
systemctl status mysql
# 或
ps aux | grep mysql
```

---

## 2. 一键启动步骤

### 步骤一：克隆或打开项目

```bash
# 如果是全新克隆
git clone https://github.com/BertRoosevelt/java-fruitsday-master.git
cd java-fruitsday-master
```

或者直接在 IDE 中打开已有项目目录。

---

### 步骤二：初始化数据库

```bash
# 登录 MySQL
mysql -u root -p

# 创建数据库（如果不存在）
CREATE DATABASE IF NOT EXISTS fruitday CHARACTER SET utf8 COLLATE utf8_general_ci;

# 使用数据库
USE fruitday;

# 退出 MySQL
EXIT;

# 导入数据库脚本（在项目根目录执行）
mysql -u root -p fruitday < fruitday.sql
```

> **验证**：登录 MySQL 执行 `SHOW TABLES;`，应看到 `fruits`、`hotfruits`、`user`、`shop1`、`shop12` 五张表。

---

### 步骤三：配置数据库连接

编辑文件：`src/main/java/com/fruitDayDB/db/DBUtils.java`

```java
// 找到以下配置行，按实际情况修改
URL = "jdbc:mysql://127.0.0.1:3306/fruitday";
USERNAME = "root";
PASSWORD = "你的MySQL密码";   // ← 修改此处
```

> 如果 MySQL 使用非默认端口，同步修改 `3306` 为实际端口号。

---

### 步骤四：构建项目

```bash
# 进入项目根目录（含 pom.xml 的目录）
cd java-fruitsday-master

# 清理并编译打包（跳过测试）
mvn clean package -DskipTests
```

成功后会在 `target/` 目录生成 `x-test.war` 文件。

---

### 步骤五：部署到 Tomcat

**方式A：手动部署**

```bash
# 将 WAR 文件复制到 Tomcat webapps 目录
cp target/x-test.war /path/to/tomcat/webapps/

# 启动 Tomcat
# Windows:
/path/to/tomcat/bin/startup.bat

# Linux/Mac:
/path/to/tomcat/bin/startup.sh
```

**方式B：IntelliJ IDEA 内置 Tomcat（推荐开发时使用）**

1. `Run → Edit Configurations`
2. 点击 `+` → `Tomcat Server → Local`
3. 在 `Deployment` 标签，点击 `+` 添加 `Artifact`，选择 `x-test:war exploded`
4. 设置 `Application context` 为 `/x-test`
5. 点击运行按钮启动

---

### 步骤六：验证启动成功

打开浏览器，访问以下地址：

```
http://localhost:8080/x-test/index.jsp
```

看到天天果园主页即表示启动成功 ✅

---

## 3. 登录凭证和测试数据

### 3.1 前台消费者账号

| 字段 | 值 |
|------|----|
| 登录页面 | `http://localhost:8080/x-test/login.jsp` |
| 邮箱 | `youwillsee2018@qq.com` |
| 密码 | `suhong1` |
| 用户ID | `1` |

> 该账号同时具有管理员权限，登录后会自动跳转后台。

### 3.2 后台管理员账号

| 字段 | 值 |
|------|----|
| 后台入口 | `http://localhost:8080/x-test/BSindex.jsp` |
| 邮箱 | `youwillsee2018@qq.com` |
| 密码 | `suhong1` |

### 3.3 注册新测试账号

访问注册页面：`http://localhost:8080/x-test/reg.jsp`

填写以下字段：
- 邮箱（用于登录）
- 手机号
- 密码（填写两次）

注册成功后，系统会自动创建对应的购物记录表（`shop{用户ID}`）。

### 3.4 测试商品数据（已内置）

| 商品ID | 名称 | 规格 | 单价 |
|-------|------|------|------|
| 1 | 佳沛新西兰绿奇异果 | 4+2盒 | ¥78 |
| 3 | 枣 | 2斤 | ¥23 |
| 4 | 菠萝 | 1个 | ¥59 |
| 8 | 南非青提 | 2斤 | ¥68 |
| 9 | 里达葡萄 | 2斤 | ¥98 |
| 10 | 墨西哥牛油果 | 6个 | ¥40 |
| 11 | 美国华盛顿红地厘蛇果 | 6个 | ¥30 |
| 14 | 美国佛罗里达葡萄柚 | 6个 | ¥40 |
| 16 | 赣南红心脐橙 | 2斤/4斤 | ¥49 |
| 20 | 紫薯 | 500g | ¥11 |

以上10款商品均已标记为热卖商品，会在主页展示。

---

## 4. 常用快捷URL链接

### 4.1 前台页面

| 页面 | URL |
|------|-----|
| 主页 | `http://localhost:8080/x-test/index.jsp` |
| 登录页 | `http://localhost:8080/x-test/login.jsp` |
| 注册页 | `http://localhost:8080/x-test/reg.jsp` |
| 购物车 | `http://localhost:8080/x-test/ShopServlet?key=show&id=1&boob=cart` |
| 收藏夹 | `http://localhost:8080/x-test/ShopServlet?key=show&id=1&boob=star` |
| 商品详情（示例） | `http://localhost:8080/x-test/FruitServlet?key=info&id=1&fid=1` |

### 4.2 后台管理页面

| 页面 | URL |
|------|-----|
| 后台主页 | `http://localhost:8080/x-test/BSindex.jsp` |
| 用户列表 | `http://localhost:8080/x-test/BSServlet?key=alluser` |
| 添加用户 | `http://localhost:8080/x-test/BSindex2.jsp` |
| 商品列表 | `http://localhost:8080/x-test/BSServlet?key=allfruit` |
| 热卖商品 | `http://localhost:8080/x-test/BSServlet?key=hotfruit` |
| 添加商品 | `http://localhost:8080/x-test/BSindex5.jsp` |

### 4.3 快速调试链接

```
# 直接查看用户ID=1的信息
http://localhost:8080/x-test/BSServlet?key=finduser&id=1

# 直接查看商品ID=1的信息
http://localhost:8080/x-test/BSServlet?key=findfruit&fid=1

# 查询所有商品
http://localhost:8080/x-test/BSServlet?key=allfruit
```

---

## 常见启动问题速查

| 问题现象 | 可能原因 | 解决方法 |
|---------|---------|---------|
| `java.lang.ClassNotFoundException: com.mysql.jdbc.Driver` | MySQL驱动未加载 | 检查 pom.xml 中 mysql-connector-java 依赖，重新 `mvn install` |
| `Communications link failure` | MySQL未启动或连接参数错误 | 启动MySQL，检查 DBUtils.java 中的连接配置 |
| 页面显示 `404 Not Found` | WAR未正确部署或路径错误 | 确认 Tomcat webapps 中有 x-test 目录，检查 URL 路径 |
| 中文乱码 | 编码未设置 | 确认 Servlet 中 `req.setCharacterEncoding("utf-8")` 已设置，JDBC URL 加 `?characterEncoding=utf8` |
| 登录后不跳转后台 | 用户ID不在管理员白名单 | 检查 `UserDaoImpl.root()` 返回的管理员ID列表 |
| `NullPointerException` on login | 用户不存在但代码未判空 | 检查 `UserService.login()` 的调用处，确认用户账号存在 |

---

*文档最后更新：2026-04*
