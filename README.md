# localMysql 项目 README

本项目是一个使用 Docker Compose 部署的 MySQL 主从复制集群，包含一个主节点和两个从节点。同时，项目还包括一个 ProxySQL 代理服务器，用于管理和路由数据库流量。

## 环境变量

在 `.env` 文件中定义了以下环境变量：

* `MYSQL_ROOT_PASSWORD`: MySQL 根用户密码
* `MYSQL_REPLICATION_USER`: 复制用户
* `MYSQL_REPLICATION_PASSWORD`: 复制用户密码
* `MYSQL_MONITOR_PASSWORD`: 监控用户密码

## 使用方法

1. 克隆项目到本地
2. 创建并编辑 `.env` 文件，根据需要设置环境变量
3. 运行 `docker-compose up` 启动集群
4. 使用 MySQL 客户端连接到 ProxySQL 代理服务器（默认端口为 6033）

## 注意事项

* 请确保在启动集群之前已经安装了 Docker 和 Docker Compose
* 本项目使用的 MySQL 和 ProxySQL 版本可能会随着时间推移而更新，请确保在使用时检查版本兼容性
* 在生产环境中，需要根据实际情况调整配置文件和环境变量

## 项目结构

* `master-config`: 主节点配置文件夹
* `slave1-config` 和 `slave2-config`: 从节点配置文件夹
* `proxysql`: ProxySQL 配置文件夹
* `Docker-compose.yml`: Docker Compose 配置文件
* `.env` 和 `.envexample`: 环境变量文件
* `.gitignore`: Git 忽略文件
