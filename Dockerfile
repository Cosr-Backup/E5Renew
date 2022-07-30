FROM cosrbackup/e5renew:latest
LABEL maintainer="support@cosr.eu.org"
	
ENV NGINX_VERSION=1.18.0
ENV TZ=Asia/Shanghai

RUN apk update && \
    apk add --no-cache ca-certificates build-base && \
    apk add --no-cache curl bash tree tzdata && \
    cp -rf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
	
RUN apk add wget gcc g++ make && \ 
    cd /home && \
    wget "https://ftp.exim.org/pub/pcre/pcre-8.44.tar.gz" && \
    tar xvf pcre-8.44.tar.gz && \
    wget "http://nginx.org/download/nginx-1.18.0.tar.gz" && \
    tar xvf nginx-1.18.0.tar.gz

RUN cd /home/nginx-1.18.0 && \
    ./configure --prefix=/usr/local/nginx --conf-path=/usr/local/nginx/nginx.conf --with-pcre=/home/pcre-8.44 --without-http_gzip_module && \
    make && make install && \
    ln -s /usr/local/nginx/sbin/nginx /usr/sbin/ && \
    mkdir -p /usr/local/nginx/conf/vhost/ && \
    rm -rf /home/*

COPY nginx.conf /usr/local/nginx/
COPY entrypoint.sh /usr/sbin/
RUN chmod +x /usr/sbin/entrypoint.sh

EXPOSE 80

STOPSIGNAL SIGTERM

ENTRYPOINT ["entrypoint.sh"]