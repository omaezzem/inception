FROM debian:bookworm 

RUN apt-get update && \
    apt-get install -y nginx openssl && \
    rm -rf /var/lib/apt/lists/*

COPY conf/nginx.conf /etc/nginx/conf.d/default.conf

#OpenSSL kaygenerate self-signed certificate.
#don't encrypt the private key with another password.
#certificate valid for 365 days.

RUN mkdir -p /etc/nginx/ssl && \
    openssl req -x509 -nodes -days 365 \ 
    -newkey rsa:2048 \
    -keyout /etc/nginx/ssl/inception.key \
    -out /etc/nginx/ssl/inception.crt \
    -subj "/CN=omaezzem.42.fr"

#khali nginx fl foreground 
nginx -g "daemon off;"