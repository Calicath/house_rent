# 房屋租赁管理系统（House Rental）

基于 Java Servlet + JSP 的房屋租赁管理系统。支持管理员、房东、租客三类角色，覆盖房源发布、搜索看房、租赁交易、支付记录和交流论坛。

## 功能概览

| 角色 | 能力 |
|------|------|
| 访客 | 浏览首页、搜索/查看房源、注册（房东或租客）、登录 |
| 租客 | 个人资料、申请看房、发起租赁、查看支付 |
| 房东 | 房源增删改、处理看房申请、处理交易、个人资料 |
| 管理员 | 用户/房东/租客/房源/交易管理、系统仪表盘 |
| 全体登录用户 | 论坛发帖、评论、编辑/删除自己的帖子 |

## 技术栈

- **语言 / JDK**：Java 11
- **构建**：Maven（WAR 包）
- **Web**：Jakarta Servlet 5 / JSP / JSTL，Bootstrap 5
- **数据库**：MySQL 8，JDBC + Apache Commons DBCP2
- **JSON**：Gson
- **运行**：Apache Tomcat 10（Jakarta EE 9）或 `mvn tomcat7:run`

> 项目依赖 `jakarta.servlet`（Jakarta EE 9）。本地用 IDEA 部署时请使用 **Tomcat 10+**。`pom.xml` 中的 `tomcat7-maven-plugin` 仅用于快速启动开发服务器。

## 系统要求

- JDK 11+
- Maven 3.6+
- MySQL 8.x（默认端口 3306）
- （可选）IntelliJ IDEA

可先运行 `check-environment.bat` 检查 Java、Maven、8080 端口和项目文件是否齐全。

## 快速开始

### 1. 初始化数据库

在 MySQL 中依次执行：

```sql
-- 主库（用户、房屋、交易、看房、支付）
SOURCE database_init.sql;

-- 论坛（帖子、评论）
SOURCE forum_database_init.sql;
```

或在命令行：

```bash
mysql -u root -p < database_init.sql
mysql -u root -p < forum_database_init.sql
```

`database_init.sql` 会创建库 `house_rental_db`（utf8mb4），并插入默认管理员。

### 2. 配置数据库连接

编辑 `src/main/java/com/house/rental/util/DBUtil.java`，与本机 MySQL 一致：

```java
dataSource.setUrl("jdbc:mysql://localhost:3306/house_rental_db?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true");
dataSource.setUsername("root");
dataSource.setPassword("你的密码");
```

### 3. 启动应用

**方式 A：脚本（Windows）**

```bat
start-tomcat.bat
```

会执行 `mvn clean compile package`，再 `mvn tomcat7:run`。

**方式 B：Maven**

```bash
mvn clean package
mvn tomcat7:run
```

访问：[http://localhost:8080/house-rental/](http://localhost:8080/house-rental/)

**方式 C：IDEA**

1. 用 Maven 导入本项目  
2. 配置 Tomcat 10，部署 `house-rental` 的 exploded WAR  
3. Application context 建议设为 `/house-rental`

## 默认账号

| 用户名 | 密码 | 角色 |
|--------|------|------|
| `root` | `123` | 管理员 |
| `admin` | `admin123` | 管理员 |

房东、租客请通过 [注册页](http://localhost:8080/house-rental/register) 自行创建。管理员账号也可再执行 `add_admin_user.sql` 补录。

## 主要页面与路径

| 说明 | 路径 |
|------|------|
| 首页 | `/` |
| 登录 / 注册 / 退出 | `/login`、`/register`、`/logout` |
| 房源搜索 / 详情 | `/house/search`、`/house/detail` |
| 租客控制台 | `/tenant/dashboard` |
| 房东控制台 | `/owner/dashboard` |
| 管理后台 | `/admin/dashboard` |
| 论坛 | `/forum` |

Servlet 使用 `@WebServlet` 注解映射，`web.xml` 几乎为空。

## 项目结构

```
house-rental/
├── pom.xml
├── database_init.sql              # 主库建表 + 默认管理员
├── forum_database_init.sql        # 论坛表
├── add_admin_user.sql             # 补录管理员
├── start-tomcat.bat
├── check-environment.bat
└── src/main/
    ├── java/com/house/rental/
    │   ├── bean/                  # 实体
    │   ├── dao/ + dao/impl/       # 数据访问
    │   ├── service/ + service/impl/
    │   ├── servlet/               # 登录注册、房源
    │   │   ├── admin/
    │   │   ├── owner/
    │   │   ├── tenant/
    │   │   └── forum/
    │   ├── filter/                # 编码等过滤器
    │   └── util/                  # DBUtil、文件上传等
    └── webapp/                    # JSP、静态资源
        ├── index.jsp, login.jsp, register.jsp
        ├── admin/ owner/ tenant/ house/ forum/
        └── WEB-INF/jspf/navbar.jsp
```

分层：**Servlet → Service → DAO → MySQL**。

## 数据库表（摘要）

- `users`：账号，`type` 为 `ADMIN` / `OWNER` / `TENANT`
- `owners` / `tenants`：与 `users` 一对一
- `houses`：房源
- `viewing_records`：看房申请
- `transactions`：租赁交易
- `payments`：支付记录
- `forum_posts` / `forum_comments`：论坛

## 常见问题

**连不上数据库**  
检查 MySQL 是否启动、库名是否为 `house_rental_db`，以及 `DBUtil` 中的用户名密码。若报 Public Key Retrieval，URL 需带 `allowPublicKeyRetrieval=true`。

**中文乱码**  
项目使用 UTF-8；已有 `CharacterEncodingFilter`。请保证 MySQL 为 `utf8mb4`，JSP 为 `UTF-8`。

**404 或上下文不对**  
确认访问前缀为 `/house-rental`（Maven 插件默认 path）。IDEA 部署请与该 context 一致。

**Jakarta vs javax**  
源码是 `jakarta.servlet`。Tomcat 9 及以下会找不到类，请用 Tomcat 10+。

**8080 被占用**  
结束占用进程，或改 `pom.xml` 里 `tomcat7-maven-plugin` 的 `<port>`。

## 说明

仓库中还有若干 `test-*.jsp`、`debug-*.jsp`，便于本地排错，生产环境建议不要暴露。`AuthFilter` 当前未启用 URL 拦截，各 Servlet 自行校验登录与角色。

## 许可证

课程/学习项目，未指定开源许可证。
