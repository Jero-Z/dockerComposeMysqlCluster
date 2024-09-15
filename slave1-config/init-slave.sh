#!/bin/bash
set -e
# 等待主库可用
until mysql -u root -p"$MYSQL_ROOT_PASSWORD" -h "mysql-master" -e "SELECT 1"; do
    echo "Waiting for mysql-master to be available..."
    sleep 5
done

echo "slave1 replication is ready to start replication..."

# 检查并配置监控用户
if mysql -u root -p"$MYSQL_ROOT_PASSWORD" -e "SELECT * FROM mysql.user WHERE User='monitor'" | grep -q 'monitor'; then
    echo "monitor user already exists."
else
    mysql -u root -p"$MYSQL_ROOT_PASSWORD" <<EOSQL
        CREATE USER 'monitor'@'%' IDENTIFIED WITH mysql_native_password BY '$MYSQL_MONITOR_PASSWORD';
        GRANT REPLICATION CLIENT ON *.* TO 'monitor'@'%';
        GRANT PROCESS ON *.* TO 'monitor'@'%';
        FLUSH PRIVILEGES;
EOSQL

    echo "monitor user created and configured."
fi

# 配置从服务器
mysql -u root -p"$MYSQL_ROOT_PASSWORD" <<EOSQL
    CHANGE MASTER TO
        MASTER_HOST='mysql-master',
        MASTER_USER='replica',
        MASTER_PASSWORD='$MYSQL_REPLICATION_PASSWORD',
        MASTER_AUTO_POSITION=1;
    START REPLICA;
EOSQL
