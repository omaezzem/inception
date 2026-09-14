FROM debian:bookworm

RUN apt-get update && \
    apt-get install -y mariadb-server && \
    rm -rf /var/lib/apt/lists/*

COPY conf/mariadb.conf /etc/mysql/mariadb.conf.d/50-server.cnf

COPY tools/mrdb.sh /usr/local/bin

RUN chmod +x /usr/local/bin/mrdb.sh

#"When a container is created from this image, start by executing this script."
ENTRYPOINT ["/usr/local/bin/mrdb.sh"]