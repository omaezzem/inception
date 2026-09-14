FROM debian:bookworm

RUN apt-get update && \
    apt-get install -y mariadb-server && \
    rm -rf /var/lib/apt/lists/*

COPY conf/mariadb.conf /etc/mysql/mariadb.conf.d/50-server.cnf

COPY tools/mrdb.sh /usr/local/bin

RUN chmod +x /usr/local/bin/mrdb.sh

ENTRYPOINT ["/usr/local/bin/mrdb.sh"]