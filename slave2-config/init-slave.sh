#!/bin/bash
set -e
# 等待主库可用
until mysql -u root -p"$MYSQL_ROOT_PASSWORD" -h "mysql-master" -e "SELECT 1"; do
    echo "Waiting for mysql-master to be available..."
    sleep 5
done


echo "slave2 replication is ready to start replication..."

# 创建并配置监控用户
mysql -u root -p"$MYSQL_ROOT_PASSWORD" <<-EOSQL
    CREATE USER IF NOT EXISTS 'monitor'@'%' IDENTIFIED WITH mysql_native_password BY 'monitor_password';
    GRANT REPLICATION CLIENT ON *.* TO 'monitor'@'%';
    GRANT PROCESS ON *.* TO 'monitor'@'%';
    FLUSH PRIVILEGES;
EOSQL
echo "monitor user is ready to start replication..."

# 配置从服务器
mysql -u root -p"$MYSQL_ROOT_PASSWORD" <<-EOSQL
    CHANGE MASTER TO
        MASTER_HOST='mysql-master',
        MASTER_USER='replica',
        MASTER_PASSWORD='$MYSQL_REPLICATION_PASSWORD',
        MASTER_AUTO_POSITION=1;
    START REPLICA;
EOSQL
