# 我的图书数据库作业

> 本文件对应必做第 **1** 项「环境与说明」。第 2–6 项（建表、数据、查询、排错、Git）以 `sql/` 下三个文件与本 README 的对应小节为准。

## 环境

- **MySQL 版本：`26.10.0`**（MySQL Community Server - GPL）
  - 作业要求 8.0 / 8.4；本机安装的是更新的 **26.10.0**。该版本向后兼容 8.x 语法，8.0 起引入的 `utf8mb4_0900_ai_ci` 排序规则可直接使用。
  - 版本证据：`SELECT VERSION();` 返回 `26.10.0`，见 `screenshots/version.png`。
  - 若必须严格落在 8.0/8.4：需卸载本机服务并安装 MySQL 8.4 官方安装包（详见文末「换版本说明」）。
- **本地安装 / Docker：本地安装**（未使用 Docker）
  - Windows 服务名：`MySQL2610`（状态 Running）
  - 监听：`127.0.0.1:3306`（仅本机，未对公网开放）
  - 图形客户端：DataGrip
  - **数据目录在仓库之外**：服务由 `mysqld.exe --defaults-file="E:\project\MySQL\my.ini"` 启动，数据目录位于该配置指定的路径下（`E:\project\MySQL\`），**不在本 Git 仓库内**，因此不存在误提交数据库数据文件的问题（对应必做第 6 项要求）。
- **数据库名称：`bookshop`**
  - 字符集：`utf8mb4`
  - 排序规则：`utf8mb4_0900_ai_ci`
- **连接方式**（本文件不记录密码）
  - 命令行：
    ```
    "C:\Program Files\MySQL\MySQL Server 26.10\bin\mysql.exe" -u root -p
    ```
  - DataGrip：Host `127.0.0.1` ｜ Port `3306` ｜ User `root` ｜ Database `bookshop`
  - 密码通过客户端凭据保存或运行时输入，不写入仓库；`demo.py` 中通过环境变量 `BOOKSHOP_USER` / `BOOKSHOP_PASSWORD` 读取，避免硬编码。

## 从空库复现

前提：本机已安装并启动 MySQL，且 `mysql -u root -p` 能登录（不需要事先存在 `bookshop` 库）。

1. **建库**
   ```sql
   CREATE DATABASE bookshop
       CHARACTER SET utf8mb4
       COLLATE utf8mb4_0900_ai_ci;
   ```
2. **建表**（`sql/schema.sql`）
   ```
   mysql -u root -p bookshop < sql/schema.sql
   ```
   预期：`authors`、`books` 两张表创建成功；`books.author_id` 上有指向 `authors.id` 的外键。
3. **灌入示例数据**（`sql/seed.sql`，4 位作者 / 8 本书）
   ```
   mysql -u root -p bookshop < sql/seed.sql
   ```
   预期：`authors` 新增 4 行，`books` 新增 8 行，其中至少 2 本库存为 0。
4. **逐条执行查询**（`sql/queries.sql`，Q1–Q6 每题上方注释写明预期结果）
   ```
   mysql -u root -p bookshop < sql/queries.sql
   ```
5. **核对环境**（对应 `screenshots/version.png`）
   ```sql
   SELECT VERSION();                            -- 已确认：26.10.0
   SHOW VARIABLES LIKE 'character_set_server';  -- 服务器默认值
   SHOW VARIABLES LIKE 'collation_server';      -- 服务器默认值
   ```
   实测 `SELECT VERSION()` 返回 `26.10.0`；两条 `SHOW VARIABLES` 用于确认服务器默认字符集。

> 注意：`SHOW VARIABLES` 读的是**服务器默认值**，与第 1 步建库时显式指定的**库级**字符集是两件事。即使服务器默认值不是 `utf8mb4`，本作业也不受影响：库级字符集在 `CREATE DATABASE` 时指定，表级字符集在 `sql/schema.sql` 中逐表写明 `DEFAULT CHARSET=utf8mb4`，三层（服务器 / 库 / 表）各自独立，以更具体的一层为准。

## 截图

| 文件 | 内容 | 说明 |
|---|---|---|
| `screenshots/version.png` | `SELECT VERSION()` 结果 `26.10.0` + 连接信息 `root@localhost:3306` | 未包含任何密码字段 |
| `screenshots/results.png` | Q1–Q6 执行结果 | 待补（第 4 项完成后截图） |

## 设计解释

- 主键为什么存在：保证id这一列值唯一非空
- 外键：保证某一列的每个值都必须能在父表的主键/唯一列里找到

## 问题

### 写SQL时 MySQL 服务停了
- 表现：Server Status offline  
Local TCP endpoint is unavaliable (localhost:3306)

- 解决方法  
  ```powershell
  Start-Service MySQL2610
  ```


## AI 辅助使用说明

- 未使用 / 使用工具与范围：**第 1 项（环境与说明）使用了 AI 辅助整理 README 结构**，包括版本信息的组织方式、复现步骤的排序、以及「服务器 / 库 / 表」三层字符集区别的表述。
- 我自己审阅、修改和验证了哪些内容：
  - 版本号 `26.10.0`、服务名 `MySQL2610`、端口 `3306`、库名 `bookshop`、字符集与排序规则，全部来自本机实际查询结果（`SELECT VERSION()` / `SHOW VARIABLES` 截图）与本机服务状态，非模型推测。
  - 复现命令逐条在本机执行过，`mysql -u root -p` 的调用路径来自本机安装目录。


## 换版本说明（仅在必须使用 8.0/8.4 时）

1. `services.msc` 中停止 `MySQL2610` 服务并设为手动启动，避免占用 3306 端口。
2. 安装 MySQL 8.4 官方 MSI，服务名默认 `MySQL84`，端口同为 3306。
3. 重新执行本 README「从空库复现」的 1–5 步；`utf8mb4_0900_ai_ci` 在 8.0/8.4 中均可用，脚本无需改动。
4. 重新截图 `screenshots/version.png`（此时期望 `8.4.x`）。
