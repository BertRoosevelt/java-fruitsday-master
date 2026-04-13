# 后台结构说明（BACKEND_STRUCTURE）

> 天天果园 FruitDay 水果销售电商系统  
> 本文档说明后台管理功能的完整组织结构、工作流程及数据流向。

---

## 目录

1. [后台功能组织结构图](#1-后台功能组织结构图)
2. [每个功能模块的工作流](#2-每个功能模块的工作流)
3. [JSP页面与Servlet的对应关系](#3-jsp页面与servlet的对应关系)
4. [数据流动过程说明](#4-数据流动过程说明)

---

## 1. 后台功能组织结构图

### 1.1 整体架构层次

```
┌────────────────────────────────────────────────────────────────┐
│                      浏览器（管理员端）                          │
│              http://localhost:8080/x-test/                      │
└───────────────────────────┬────────────────────────────────────┘
                            │ HTTP 请求/响应
┌───────────────────────────▼────────────────────────────────────┐
│                   表现层（View）                                  │
│                                                                 │
│  BSindex.jsp   ── 欢迎主页                                       │
│  BSindex1.jsp  ── 用户列表展示                                   │
│  BSindex2.jsp  ── 添加用户表单                                   │
│  BSindex3.jsp  ── 编辑用户表单                                   │
│  BSindex4.jsp  ── 商品列表展示（库存/热卖）                       │
│  BSindex5.jsp  ── 添加商品表单                                   │
│  BSindex6.jsp  ── 编辑商品表单                                   │
└───────────────────────────┬────────────────────────────────────┘
                            │ 请求转发 / 数据传递
┌───────────────────────────▼────────────────────────────────────┐
│                 控制层（Controller）                              │
│                                                                 │
│  BSServlet.java                                                 │
│  ├── doGet/doPost  ── 统一入口，按 key 参数路由分发               │
│  ├── 用户管理组                                                  │
│  │   ├── doAlluser()   ── 查询所有用户                           │
│  │   ├── doAdduser()   ── 新增用户                               │
│  │   ├── doDeluser()   ── 删除用户                               │
│  │   ├── doUpuser()    ── 修改用户信息                           │
│  │   └── doFinduser()  ── 查询单个用户                           │
│  └── 商品管理组                                                  │
│      ├── doAllfruit()  ── 查询所有商品                           │
│      ├── doAddfruit()  ── 新增商品                               │
│      ├── doDelfruit()  ── 删除商品                               │
│      ├── doFindfruit() ── 查询单个商品                           │
│      ├── doHotfruit()  ── 查询热卖商品                           │
│      └── doUpfruit()   ── 修改商品信息                           │
└───────────────────────────┬────────────────────────────────────┘
                            │ 业务调用
┌───────────────────────────▼────────────────────────────────────┐
│                 业务逻辑层（Service）                             │
│                                                                 │
│  UserService.java                                               │
│  ├── add(User)       ── 注册/添加用户，创建购物表                 │
│  ├── del(User)       ── 删除用户                                 │
│  ├── alluser()       ── 获取所有用户列表                         │
│  ├── findById(id)    ── 按ID查询用户                             │
│  ├── upUser(User)    ── 更新用户信息                             │
│  ├── root()          ── 获取管理员ID列表                         │
│  └── login(str,pwd)  ── 用户登录验证                             │
│                                                                 │
│  FruitService.java                                              │
│  ├── all()           ── 获取所有商品                             │
│  ├── hot()           ── 获取热卖商品                             │
│  ├── add(Fruit)      ── 添加商品                                 │
│  ├── del(fid)        ── 删除商品                                 │
│  ├── info(fid)       ── 获取商品详情                             │
│  └── up(Fruit)       ── 更新商品信息                             │
└───────────────────────────┬────────────────────────────────────┘
                            │ 数据访问
┌───────────────────────────▼────────────────────────────────────┐
│                 数据访问层（DAO）                                 │
│                                                                 │
│  UserDao (接口) / UserDaoImpl (实现)                            │
│  ├── add(User)       ── INSERT INTO user                        │
│  ├── del(User)       ── DELETE FROM user WHERE id=?            │
│  ├── findAll()       ── SELECT * FROM user                      │
│  ├── findById(id)    ── SELECT * FROM user WHERE id=?          │
│  ├── findByStr(str)  ── 按邮箱/手机查询                          │
│  ├── update(User)    ── UPDATE user SET ...                     │
│  └── root()          ── 查询管理员ID列表                         │
│                                                                 │
│  FruitDao (接口) / FruitDaoImpl (实现)                          │
│  ├── add(Fruit)      ── INSERT INTO fruits                      │
│  ├── del(fid)        ── DELETE FROM fruits WHERE fid=?         │
│  ├── findAll()       ── SELECT * FROM fruits                    │
│  ├── findById(fid)   ── SELECT * FROM fruits WHERE fid=?       │
│  ├── findHot()       ── JOIN hotfruits 查询热卖商品              │
│  └── update(Fruit)   ── UPDATE fruits SET ...                   │
└───────────────────────────┬────────────────────────────────────┘
                            │ JDBC连接
┌───────────────────────────▼────────────────────────────────────┐
│                   数据库工具（DBUtils）                           │
│                                                                 │
│  DBUtils.java                                                   │
│  ├── getConnection()  ── 获取MySQL连接                           │
│  └── close(rs,stmt,conn) ── 关闭连接资源                        │
└───────────────────────────┬────────────────────────────────────┘
                            │ SQL
┌───────────────────────────▼────────────────────────────────────┐
│                   MySQL 数据库 (fruitday)                        │
│                                                                 │
│  user         ── 用户表                                          │
│  fruits       ── 商品表                                          │
│  hotfruits    ── 热卖商品表                                      │
│  shop1        ── 用户1的购物/收藏记录                             │
│  shop{id}     ── 其他用户的购物/收藏记录                          │
└────────────────────────────────────────────────────────────────┘
```

### 1.2 后台功能模块划分

```
后台管理系统（BSServlet + BSindex*.jsp）
│
├── 用户管理模块
│   ├── [查] 用户列表      key=alluser   → BSindex1.jsp
│   ├── [增] 添加用户      key=adduser   ← BSindex2.jsp (表单提交)
│   ├── [删] 删除用户      key=deluser   → 刷新列表
│   ├── [查] 查看用户      key=finduser  → BSindex3.jsp
│   └── [改] 修改用户      key=upuser    ← BSindex3.jsp (表单提交)
│
└── 商品管理模块
    ├── [查] 商品列表      key=allfruit  → BSindex4.jsp
    ├── [查] 热卖商品      key=hotfruit  → BSindex4.jsp
    ├── [增] 添加商品      key=addfruit  ← BSindex5.jsp (表单提交)
    ├── [删] 删除商品      key=delfruit  → 刷新列表
    ├── [查] 查看商品      key=findfruit → BSindex6.jsp
    └── [改] 修改商品      key=upfruit   ← BSindex6.jsp (表单提交)
```

---

## 2. 每个功能模块的工作流

### 2.1 用户管理工作流

#### 查看用户列表

```
管理员点击"全部用户"
    │
    ▼
GET /BSServlet?key=alluser
    │
    ▼
BSServlet.doAlluser()
    │ 调用
    ▼
UserService.alluser()
    │ 调用
    ▼
UserDaoImpl.findAll()
    │ 执行SQL
    ▼
SELECT id, email, phone, pwd, uname FROM user
    │ 返回ResultSet
    ▼
遍历ResultSet，封装为 List<User>
    │ 返回
    ▼
req.setAttribute("allusers", users)
    │ 转发
    ▼
BSindex1.jsp 渲染用户表格（JSP读取allusers属性）
    │
    ▼
管理员看到用户列表（含删除/编辑链接）
```

#### 添加用户

```
管理员点击"添加用户"
    │
    ▼
直接跳转 BSindex2.jsp（无需经过Servlet）
    │
    ▼
管理员填写表单（用户名/邮箱/手机/密码）
    │ 点击"添加"
    ▼
POST /BSServlet?key=adduser
    │ 参数: name1, email1, phone1, pwd1
    ▼
BSServlet.doAdduser()
    │ 构建 User 对象
    ▼
UserService.add(user)
    ├── UserDaoImpl.add(user) → INSERT INTO user VALUES(...)
    │   返回受影响行数
    └── 若成功：
        ├── UserService.login(email, pwd) → 获取新用户对象（含ID）
        └── ShopDaoImpl.newTable(userId) → CREATE TABLE shop{id}
    │ 返回 User 对象（或null表示失败）
    ▼
若 user != null → BSServlet.doAlluser() → 刷新用户列表
若 user == null → 无跳转（当前代码未处理失败情况）
```

#### 删除用户

```
管理员点击"删除"链接
    │
    ▼
GET /BSServlet?key=deluser&id={userId}
    │
    ▼
BSServlet.doDeluser()
    │ 解析 id 参数
    ▼
UserService.del(new User(id))
    │
    ▼
UserDaoImpl.del(user) → DELETE FROM user WHERE id=?
    │ 返回受影响行数
    ▼
BSServlet.doAlluser() → 刷新用户列表
```

#### 查看/编辑用户

```
管理员点击用户名（在列表中）
    │
    ▼
GET /BSServlet?key=finduser&id={userId}
    │
    ▼
BSServlet.doFinduser()
    │
    ▼
UserService.findById(id) → UserDaoImpl.findById(id)
    │ → SELECT * FROM user WHERE id=?
    ▼
req.setAttribute("user", user)
    │ 转发
    ▼
BSindex3.jsp 显示用户信息填入表单
    │ 管理员修改后点击"保存"
    ▼
POST /BSServlet?key=upuser&id={userId}
    │ 参数: name2, email2, phone2, pwd2
    ▼
BSServlet.doUpuser() → UserService.add(user)
    │ （注意：此处复用了 add 方法，实际应调用 upUser）
    ▼
刷新用户列表
```

---

### 2.2 商品管理工作流

#### 查看商品列表

```
管理员点击"库存水果"
    │
    ▼
GET /BSServlet?key=allfruit
    │
    ▼
BSServlet.doAllfruit()
    │
    ▼
FruitService.all() → FruitDaoImpl.findAll()
    │ → SELECT * FROM fruits
    ▼
req.setAttribute("allfruit", fruits)
    │ 转发
    ▼
BSindex4.jsp 渲染商品列表（名称/规格/单价/操作）
```

#### 查看热卖商品

```
管理员点击"热卖水果"
    │
    ▼
GET /BSServlet?key=hotfruit
    │
    ▼
BSServlet.doHotfruit()
    │
    ▼
FruitService.hot() → FruitDaoImpl.findHot()
    │ → SELECT fruits.* FROM fruits
    │     JOIN hotfruits ON fruits.fid = hotfruits.fid
    ▼
req.setAttribute("allfruit", fruits)  ← 复用同一属性名
    │ 转发（同样到 BSindex4.jsp）
    ▼
BSindex4.jsp 展示热卖商品列表
```

#### 添加商品

```
管理员点击"水果入库"
    │
    ▼
直接跳转 BSindex5.jsp（无需经过Servlet）
    │
    ▼
管理员填写商品信息
    │ 点击"添加"
    ▼
POST /BSServlet?key=addfruit
    │ 参数: fid(手动输入ID), fname, spec, up, t1, t2, inum
    ▼
BSServlet.doAddfruit()
    │ 构建 Fruit 对象
    ▼
FruitService.add(fruit) → FruitDaoImpl.add(fruit)
    │ → INSERT INTO fruits VALUES(...)
    ▼
成功 → BSServlet.doAllfruit() → 商品列表
失败（fid已存在）→ 转发到 BSindex5.jsp（重新填写）
```

#### 删除商品

```
管理员点击"删除"链接
    │
    ▼
GET /BSServlet?key=delfruit&fid={fruitId}
    │
    ▼
BSServlet.doDelfruit()
    │
    ▼
FruitService.del(fid) → FruitDaoImpl.del(fid)
    │ → DELETE FROM fruits WHERE fid=?
    ▼
BSServlet.doAllfruit() → 刷新商品列表
```

#### 查看/编辑商品

```
管理员点击商品名称（在列表中）
    │
    ▼
GET /BSServlet?key=findfruit&fid={fruitId}
    │
    ▼
BSServlet.doFindfruit()
    │
    ▼
FruitService.info(fid) → FruitDaoImpl.findById(fid)
    │ → SELECT * FROM fruits WHERE fid=?
    ▼
req.setAttribute("fruit", fruit)
    │ 转发
    ▼
BSindex6.jsp 显示商品信息填入表单
    │ 管理员修改后点击"保存"
    ▼
POST /BSServlet?key=upfruit&fid={fruitId}
    │ 参数: fname, spec, up, t1, t2, inum
    ▼
BSServlet.doUpfruit()
    │
    ▼
FruitService.up(fruit) → FruitDaoImpl.update(fruit)
    │ → UPDATE fruits SET fname=?, spec=?, ... WHERE fid=?
    ▼
BSServlet.doAllfruit() → 刷新商品列表
```

---

## 3. JSP页面与Servlet的对应关系

### 3.1 后台页面对应关系完整映射

| JSP页面 | CSS ID | 功能 | 关联Servlet操作 | 触发方式 |
|---------|--------|------|----------------|---------|
| `BSindex.jsp` | `#x0` | 后台主页（欢迎页） | 无（静态页面） | 直接访问 |
| `BSindex1.jsp` | `#x1` | 用户列表 | `BSServlet?key=alluser` | Servlet转发 |
| `BSindex2.jsp` | `#x2` | 添加用户表单 | 提交到 `key=adduser` | 直接跳转 |
| `BSindex3.jsp` | `#x3` | 编辑用户表单 | `BSServlet?key=finduser` 进入，提交到 `key=upuser` | Servlet转发 |
| `BSindex4.jsp` | `#x4` | 商品列表（库存/热卖） | `BSServlet?key=allfruit` 或 `key=hotfruit` | Servlet转发 |
| `BSindex5.jsp` | `#x5` | 添加商品表单 | 提交到 `key=addfruit` | 直接跳转 |
| `BSindex6.jsp` | `#x6` | 编辑商品表单 | `BSServlet?key=findfruit` 进入，提交到 `key=upfruit` | Servlet转发 |

### 3.2 前台页面对应关系

| JSP页面 | 功能 | 关联Servlet操作 |
|---------|------|----------------|
| `index.jsp` | 主页（热卖商品展示） | `FruitServlet`（加载数据） |
| `login.jsp` | 用户登录 | `UserServlet?key=login` |
| `reg.jsp` | 用户注册 | `UserServlet?key=add` |
| `fruit_info.jsp` | 商品详情 | `FruitServlet?key=info` |
| `sel.jsp` | 搜索结果 | `SELServlet` |
| `showcart.jsp` | 购物车 | `ShopServlet?key=show&boob=cart` |
| `showstar.jsp` | 收藏夹 | `ShopServlet?key=show&boob=star` |

### 3.3 导航链接与CSS分区设计

后台所有页面使用统一的侧边栏导航。内容区通过 `id` 来区分不同功能板块，对应关系如下：

```
侧边栏导航 (class="mean")
│
├── 用户管理
│   ├── 全部用户  → GET BSServlet?key=alluser → 渲染 div#x1 (BSindex1.jsp)
│   └── 添加用户  → 直接打开 BSindex2.jsp    → 渲染 div#x2
│
└── 商品管理
    ├── 库存水果  → GET BSServlet?key=allfruit  → 渲染 div#x4 (BSindex4.jsp)
    ├── 热卖水果  → GET BSServlet?key=hotfruit  → 渲染 div#x4 (BSindex4.jsp)
    └── 水果入库  → 直接打开 BSindex5.jsp       → 渲染 div#x5
```

---

## 4. 数据流动过程说明

### 4.1 完整数据流动链路

```
┌──────────────────────────────────────────────────────────────┐
│  管理员浏览器                                                   │
│  发起 HTTP 请求                                                 │
│  例：GET /BSServlet?key=allfruit                               │
└──────────────────────────────┬───────────────────────────────┘
                               │ HTTP GET/POST
                               ▼
┌──────────────────────────────────────────────────────────────┐
│  BSServlet.doGet() / doPost()                                │
│  1. 读取 key 参数                                              │
│  2. 设置编码：req.setCharacterEncoding("utf-8")               │
│  3. 按 key 路由到对应处理方法                                  │
│     如 key="allfruit" → doAllfruit()                         │
└──────────────────────────────┬───────────────────────────────┘
                               │ 方法调用
                               ▼
┌──────────────────────────────────────────────────────────────┐
│  具体处理方法（如 doAllfruit）                                  │
│  1. 从 req 读取参数（getParameter）                            │
│  2. 构建 VO 对象（如 new Fruit(...)）                          │
│  3. 调用 Service 层                                            │
└──────────────────────────────┬───────────────────────────────┘
                               │ 业务调用
                               ▼
┌──────────────────────────────────────────────────────────────┐
│  FruitService.all()                                          │
│  1. 创建 DAO 实例：new FruitDaoImpl()                         │
│  2. 调用 DAO 方法：fruitDao.findAll()                         │
│  3. 可在此处加业务逻辑（当前版本较简单，直接透传）               │
└──────────────────────────────┬───────────────────────────────┘
                               │ 数据访问
                               ▼
┌──────────────────────────────────────────────────────────────┐
│  FruitDaoImpl.findAll()                                      │
│  1. DBUtils.getConnection() → 获取 JDBC 连接                  │
│  2. 创建 PreparedStatement                                    │
│  3. 执行 SQL：SELECT * FROM fruits                            │
│  4. 遍历 ResultSet                                            │
│  5. 将每行数据封装为 Fruit 对象                                 │
│  6. 添加到 List<Fruit>                                        │
│  7. DBUtils.close(rs, stmt, conn) → 关闭资源                  │
│  8. 返回 List<Fruit>                                          │
└──────────────────────────────┬───────────────────────────────┘
                               │ 返回数据
                               ▼
┌──────────────────────────────────────────────────────────────┐
│  BSServlet.doAllfruit()（续）                                 │
│  1. 接收 List<Fruit> fruits                                   │
│  2. req.setAttribute("allfruit", fruits)  → 存入请求域        │
│  3. req.getRequestDispatcher("BSindex4.jsp").forward(...)    │
└──────────────────────────────┬───────────────────────────────┘
                               │ 请求转发
                               ▼
┌──────────────────────────────────────────────────────────────┐
│  BSindex4.jsp                                                │
│  1. 从 request 读取属性：                                      │
│     (List<Fruit>)request.getAttribute("allfruit")           │
│  2. 遍历列表，用 out.print() 动态生成 HTML 表格行              │
│  3. 每行包含：商品名、规格、单价、删除链接                       │
│  4. 生成完整 HTML 响应                                         │
└──────────────────────────────┬───────────────────────────────┘
                               │ HTTP 响应（HTML）
                               ▼
┌──────────────────────────────────────────────────────────────┐
│  管理员浏览器渲染页面                                           │
│  看到商品列表表格                                               │
└──────────────────────────────────────────────────────────────┘
```

### 4.2 数据在各层之间的转换

| 层次 | 数据形式 | 说明 |
|------|---------|------|
| 浏览器 → Servlet | HTTP 参数字符串 | `req.getParameter("fid")` |
| Servlet → Service | Java VO 对象 | `new Fruit(fid, fname, ...)` |
| Service → DAO | Java VO 对象 | 传递同一对象 |
| DAO → MySQL | SQL 语句 + 参数 | `PreparedStatement` 绑定参数 |
| MySQL → DAO | `ResultSet` | JDBC 游标遍历 |
| DAO → Service | `List<VO>` 或单个 VO | 封装后返回 |
| Service → Servlet | `List<VO>` 或单个 VO | 业务处理后返回 |
| Servlet → JSP | `request` 属性 | `setAttribute` / `getAttribute` |
| JSP → 浏览器 | HTML 字符串 | JSP 动态生成 |

### 4.3 Session 数据流（用户登录状态）

```
用户登录（login.jsp → UserServlet?key=login）
    │
    ▼
UserServlet.doLogin()
    │
    ├── UserService.login() 验证用户名密码
    │   返回 User 对象（密码替换为 "******"）
    │
    ├── UserService.root() 获取管理员ID列表
    │   若当前用户是管理员 → 转发 BSindex.jsp（后台）
    │
    └── 普通用户：
        session.setAttribute("user", user)   ← 存入Session
        转发 index.jsp
        
Session 中的 user 对象在整个会话期间可用：
    - head/head.jsp 读取 session["user"] 显示用户名
    - ShopServlet 读取 session["user"] 获取用户ID
    - fruit_info.jsp 读取 session["user"].id 关联购物操作
```

---

*文档最后更新：2026-04*
