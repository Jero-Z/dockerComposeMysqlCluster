#!/bin/bash
set -e
echo "master start create "
# 创建监控用户并授予权限
mysql -u root -p"$MYSQL_ROOT_PASSWORD" <<-EOSQL
    CREATE USER IF NOT EXISTS 'monitor'@'%' IDENTIFIED WITH mysql_native_password BY '$MYSQL_MONITOR_PASSWORD';
    GRANT REPLICATION CLIENT ON *.* TO 'monitor'@'%';
    GRANT PROCESS ON *.* TO 'monitor'@'%';
    FLUSH PRIVILEGES;
EOSQL
echo "master monitor user created"

# 创建复制用户并授予权限
mysql -u root -p"$MYSQL_ROOT_PASSWORD" <<-EOSQL
    CREATE USER IF NOT EXISTS 'replica'@'%' IDENTIFIED WITH mysql_native_password BY '$MYSQL_REPLICATION_PASSWORD';
    GRANT REPLICATION SLAVE ON *.* TO 'replica'@'%';
    FLUSH PRIVILEGES;
EOSQL
echo "master replication user created"
