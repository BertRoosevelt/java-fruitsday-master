# 后台管理系统快速指南（BACKEND_GUIDE）

> 适用人群：新接手本项目的后台开发者  
> 项目名称：天天果园 FruitDay 水果销售电商系统  
> 技术栈：Java 17 + Servlet + JSP + MySQL + Tomcat

---

## 目录

1. [后台系统快速入门（5分钟上手）](#1-后台系统快速入门5分钟上手)
2. [完整URL路由映射表](#2-完整url路由映射表)
3. [各功能模块详细说明](#3-各功能模块详细说明)
4. [常见问题解决方案](#4-常见问题解决方案)
5. [数据库表结构速查表](#5-数据库表结构速查表)

---

## 1. 后台系统快速入门（5分钟上手）

### 1.1 后台系统入口

后台管理系统入口为 `BSindex.jsp`，通过以下方式进入：

1. **直接访问**：浏览器打开 `http://localhost:8080/x-test/BSindex.jsp`
2. **登录跳转**：使用管理员账号在 `login.jsp` 登录后，系统自动跳转至 `BSindex.jsp`

### 1.2 管理员账号

| 字段 | 值 |
|------|----|
| 登录邮箱 | `youwillsee2018@qq.com` |
| 密码 | `suhong1` |
| 用户ID | `1`（管理员ID需在数据库 `root` 表中维护） |

> **注意**：管理员权限通过数据库中维护的 UID 白名单来判断。在 `UserServlet.doLogin()` 中调用 `UserService.root()` 获取管理员 ID 列表，若当前用户 ID 在列表中，则跳转至后台。

### 1.3 后台页面结构一览

```
BSindex.jsp     ─ 后台主页（欢迎页）
├── BSindex1.jsp  ─ 用户列表页
├── BSindex2.jsp  ─ 添加用户页
├── BSindex3.jsp  ─ 编辑用户页
├── BSindex4.jsp  ─ 商品列表页（库存 / 热卖）
├── BSindex5.jsp  ─ 添加商品页
└── BSindex6.jsp  ─ 编辑商品页
```

### 1.4 导航侧边栏功能

后台每个页面左侧有统一的导航栏，包含：

- **用户管理**（点击展开）
  - 全部用户 → 查看所有注册用户列表
  - 添加用户 → 跳转到添加用户表单
- **商品管理**（点击展开）
  - 库存水果 → 查看所有商品列表
  - 热卖水果 → 查看热卖商品列表
  - 水果入库 → 跳转到添加商品表单

---

## 2. 完整URL路由映射表

### 2.1 后台管理 Servlet（BSServlet）

路径前缀：`/BSServlet`

| `key` 参数 | HTTP方法 | 功能描述 | 跳转目标页面 |
|-----------|---------|---------|------------|
| `alluser` | GET | 查询所有用户列表 | `BSindex1.jsp` |
| `deluser` | GET | 删除指定用户（需参数 `id`） | 刷新用户列表 |
| `adduser` | POST | 新增用户（表单提交） | 刷新用户列表 |
| `upuser` | POST | 修改用户信息（表单提交） | 刷新用户列表 |
| `finduser` | GET | 查找单个用户（需参数 `id`） | `BSindex3.jsp` |
| `allfruit` | GET | 查询所有商品列表 | `BSindex4.jsp` |
| `addfruit` | POST | 新增商品（表单提交） | 刷新商品列表 / `BSindex5.jsp` |
| `findfruit` | GET | 查找单个商品（需参数 `fid`） | `BSindex6.jsp` |
| `delfruit` | GET | 删除指定商品（需参数 `fid`） | 刷新商品列表 |
| `hotfruit` | GET | 查看热卖商品列表 | `BSindex4.jsp` |
| `upfruit` | POST | 修改商品信息（表单提交，需参数 `fid`） | 刷新商品列表 |

**URL示例：**

```
# 查看所有用户
GET /x-test/BSServlet?key=alluser

# 删除 id=5 的用户
GET /x-test/BSServlet?key=deluser&id=5

# 查看 fid=1 的商品详情（进入编辑页）
GET /x-test/BSServlet?key=findfruit&fid=1

# 删除 fid=3 的商品
GET /x-test/BSServlet?key=delfruit&fid=3
```

### 2.2 前台消费者端 Servlet

| Servlet | 路径 | 功能 |
|---------|------|------|
| `UserServlet` | `/UserServlet` | 用户注册（`key=add`）、登录（`key=login`） |
| `FruitServlet` | `/FruitServlet` | 商品列表、详情展示 |
| `ShopServlet` | `/ShopServlet` | 购物车（`key=add/del/show/num`）、收藏管理 |
| `selServlet` | `/SELServlet` | 搜索与筛选商品 |

### 2.3 前台JSP页面路由

| 页面文件 | URL路径 | 功能 |
|---------|---------|------|
| `index.jsp` | `/x-test/index.jsp` | 主页 |
| `login.jsp` | `/x-test/login.jsp` | 登录页 |
| `reg.jsp` | `/x-test/reg.jsp` | 注册页 |
| `fruit_info.jsp` | `/x-test/fruit_info.jsp` | 商品详情页 |
| `sel.jsp` | `/x-test/sel.jsp` | 搜索结果页 |
| `showcart.jsp` | `/x-test/showcart.jsp` | 购物车页 |
| `showstar.jsp` | `/x-test/showstar.jsp` | 收藏夹页 |

---

## 3. 各功能模块详细说明

### 3.1 用户管理模块

**对应Servlet方法：** `BSServlet.doAlluser()` / `doAdduser()` / `doDeluser()` / `doUpuser()` / `doFinduser()`

#### 查看用户列表

1. 点击导航栏「用户管理 → 全部用户」
2. 请求：`GET /BSServlet?key=alluser`
3. 后端调用 `UserService.alluser()` → `UserDaoImpl.findAll()`
4. 查询数据库 `user` 表，返回所有用户
5. 将用户列表存入 `request.setAttribute("allusers", users)`
6. 转发至 `BSindex1.jsp` 展示表格

#### 添加用户

1. 点击导航栏「用户管理 → 添加用户」，跳转到 `BSindex2.jsp`
2. 填写表单（用户名、邮箱、手机、密码），提交到 `POST /BSServlet?key=adduser`
3. 参数名：`name1`、`email1`、`phone1`、`pwd1`
4. 后端调用 `UserService.add(user)` 创建用户
5. 成功后刷新用户列表

#### 删除用户

1. 在用户列表页点击「删除」链接
2. 请求：`GET /BSServlet?key=deluser&id={用户ID}`
3. 后端调用 `UserService.del(user)` 删除

#### 编辑用户

1. 在用户列表页点击用户名/邮箱/手机（任一链接），跳转到 `BSindex3.jsp`
2. 请求：`GET /BSServlet?key=finduser&id={用户ID}`
3. 修改信息后提交到 `POST /BSServlet?key=upuser&id={用户ID}`
4. 参数名：`name2`、`email2`、`phone2`、`pwd2`

---

### 3.2 商品管理模块

**对应Servlet方法：** `BSServlet.doAllfruit()` / `doAddfruit()` / `doDelfruit()` / `doFindfruit()` / `doUpfruit()` / `doHotfruit()`

#### 查看商品列表（库存）

1. 点击导航栏「商品管理 → 库存水果」
2. 请求：`GET /BSServlet?key=allfruit`
3. 后端调用 `FruitService.all()` 查询所有商品
4. 转发至 `BSindex4.jsp` 展示商品表格（名称、规格、单价）

#### 查看热卖商品

1. 点击导航栏「商品管理 → 热卖水果」
2. 请求：`GET /BSServlet?key=hotfruit`
3. 后端调用 `FruitService.hot()` 查询热卖商品（`hotfruits` 表）
4. 同样转发至 `BSindex4.jsp`

#### 添加商品

1. 点击导航栏「商品管理 → 水果入库」，跳转到 `BSindex5.jsp`
2. 填写表单，提交到 `POST /BSServlet?key=addfruit`
3. 参数：`fid`（商品ID）、`fname`（名称）、`spec`（规格）、`up`（单价）、`t1`（简介）、`t2`（温馨提示）、`inum`（图片数量/库存）
4. 成功后跳转商品列表；`fid` 已存在则返回 `BSindex5.jsp`

#### 删除商品

1. 在商品列表页点击「删除」链接
2. 请求：`GET /BSServlet?key=delfruit&fid={商品ID}`

#### 编辑商品

1. 在商品列表页点击商品名称/规格/单价（任一链接），跳转到 `BSindex6.jsp`
2. 请求：`GET /BSServlet?key=findfruit&fid={商品ID}`
3. 修改后提交到 `POST /BSServlet?key=upfruit&fid={商品ID}`
4. 参数：`fname`、`spec`、`up`、`t1`、`t2`、`inum`（同添加表单，无需再传 `fid`，`fid` 作为URL参数）

---

## 4. 常见问题解决方案

### Q1：访问后台时页面空白或报错 404

**原因**：Tomcat 未正确部署，或访问路径错误。

**解决步骤：**
1. 确认 Tomcat 已启动，控制台无异常
2. 确认 WAR 包已部署到 `webapps` 目录，应用名为 `x-test`
3. 检查访问路径：`http://localhost:8080/x-test/BSindex.jsp`
4. 若路径带 `/x-test` 前缀，确认 JSP 内的链接也已包含 `/x-test`（部分旧页面写死了路径）

---

### Q2：登录后没有跳转后台，而是跳到了前台主页

**原因**：登录用户的 ID 不在管理员白名单中。

**解决步骤：**
1. 查看 `UserServlet.doLogin()` 中调用 `UserService.root()`
2. 检查数据库中是否有 `root` 相关表或查询（当前代码需确认 `UserDaoImpl.root()` 的实现）
3. 确保你的用户 ID（如 `1`）在管理员名单中

---

### Q3：数据库连接失败

**原因**：数据库未启动或连接参数错误。

**解决步骤：**
1. 确认 MySQL 服务已启动
2. 检查 `src/main/java/com/fruitDayDB/db/DBUtils.java` 中的连接参数：

```java
URL = "jdbc:mysql://127.0.0.1:3306/fruitday";
USERNAME = "root";
PASSWORD = "2004020421";   // ← 修改为实际密码
```

3. 使用 Navicat 或命令行测试连接：

```bash
mysql -u root -p fruitday
```

4. 确认数据库名为 `fruitday`（区分大小写）

---

### Q4：添加商品后页面返回了空的添加表单

**原因**：传入的 `fid`（商品ID）已存在，`FruitService.add()` 返回 `false`。

**解决步骤：**
1. 修改 `fid` 为一个未使用的整数
2. 查询当前最大 `fid`：`SELECT MAX(fid) FROM fruits;`

---

### Q5：删除用户后页面异常

**原因**：删除用户时未同步删除其关联的购物记录表（每个用户注册时会创建独立购物表）。

**解决步骤：**
1. 删除用户前，手动清理其关联数据
2. 或在 `UserService.del()` 中补充清理购物记录的逻辑

---

### Q6：中文乱码

**原因**：Servlet 编码未设置，或 Tomcat 默认编码为 ISO-8859-1。

**解决步骤：**
- 所有 Servlet 已设置：`req.setCharacterEncoding("utf-8")`
- 检查数据库建表时是否指定了 `CHARSET=utf8`
- 检查 JDBC 连接串中是否包含编码参数（可追加）：

```
jdbc:mysql://127.0.0.1:3306/fruitday?useUnicode=true&characterEncoding=utf8
```

---

## 5. 数据库表结构速查表

数据库名：`fruitday`

### 5.1 fruits（商品表）

| 字段名 | 类型 | 说明 |
|--------|------|------|
| `fid` | int(255) PK | 商品ID（主键，手动指定，非自增） |
| `fname` | varchar(255) | 商品名称 |
| `spec` | varchar(255) | 规格（如"4+2盒"、"2斤"） |
| `up` | double | 单价（元） |
| `t1` | longtext | 商品简介（产地、规格等） |
| `t2` | longtext | 温馨提示（储藏、营养等） |
| `inum` | int(11) | 图片数量（同时用于库存控制） |

**注意**：`fid` 非自增，添加商品时需手动填写唯一ID。

---

### 5.2 hotfruits（热卖商品表）

| 字段名 | 类型 | 说明 |
|--------|------|------|
| `fid` | int(11) PK AUTO_INCREMENT | 热卖商品ID（对应 fruits.fid） |

此表只存储商品ID，与 `fruits` 表形成关联。首页展示的热卖商品来自此表。

---

### 5.3 user（用户表）

| 字段名 | 类型 | 说明 |
|--------|------|------|
| `id` | int(255) PK AUTO_INCREMENT | 用户ID |
| `email` | varchar(255) | 邮箱（可用于登录） |
| `phone` | varchar(255) | 手机号 |
| `pwd` | varchar(255) | 密码（明文存储，建议加密） |
| `uname` | varchar(255) | 用户昵称 |

**默认测试账号：**

```sql
INSERT INTO `user` VALUES ('1', 'youwillsee2018@qq.com', '15754326763', 'suhong1', 'youwillsee2018@qq.com');
```

---

### 5.4 shop1（购物记录表 - 用户1专属）

| 字段名 | 类型 | 说明 |
|--------|------|------|
| `fid` | int(11) | 商品ID（关联 fruits.fid） |
| `isStar` | tinyint(1) | 是否已收藏（1=是，0=否） |
| `isCart` | tinyint(1) | 是否在购物车（1=是，0=否） |

**说明**：每个用户注册时会创建一张独立的购物记录表（`shop{用户ID}`）。`shop1` 是用户ID=1的购物表。

---

### 5.5 shop12（购物记录表 - 用户12专属）

结构同 `shop1`，此表带有主键约束（`fid` 为主键）。

---

### 5.6 ER关系图（文字版）

```
user (id) ─── 注册时创建 ───> shop{id} (fid, isStar, isCart)
                                        │
                                        └──> fruits (fid, fname, ...)
                                                    │
                                                    └──> hotfruits (fid)
```

---

*文档最后更新：2026-04*
