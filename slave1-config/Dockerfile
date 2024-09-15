FROM mysql:8.0
COPY ./init-slave.sh /docker-entrypoint-initdb.d/
RUN chmod +x /docker-entrypoint-initdb.d/init-slave.sh