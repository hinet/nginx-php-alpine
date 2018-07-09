FROM alpine:3.8

LABEL maintainer="hinet <63603636@qq.com>" \
    license="MIT" \
    org.label-schema.schema-version="1.0" \
    org.label-schema.vendor="graze" \
    org.label-schema.name="nginx-php5-alpine" \
    org.label-schema.description="small nginx php5 image based on alpine" \
    org.label-schema.vcs-url="https://github.com/hinet/docker-nginx-php5"

RUN apk add -U --no-cache \
    nginx \
    php5 \
    php5-apcu \
    php5-bcmath \
    php5-ctype \
    php5-curl \
    php5-dom \
    php5-exif \
    php5-gd \
    php5-iconv \
    php5-intl \
    php5-json \
    php5-mysql \
    php5-mysqli \
    php5-opcache \
    php5-openssl \
    php5-pcntl \
    php5-pdo_mysql \
    php5-phar \
    php5-posix \
    php5-xml \
    php5-xsl \
    php5-zip \
    php5-zlib \
    php5-fpm \
    php5-mcrypt \
    supervisor \
    curl \
    && rm -rf /var/cache/apk/*

COPY config/default.conf /etc/nginx/conf.d/default.conf
COPY config/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

RUN sed -i "s/;cgi.force_redirect = 1/cgi.force_redirect = 0/g" /etc/php5/php.ini
RUN sed -i "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo = 1/g" /etc/php5/php.ini
RUN sed -i "s/;fastcgi.impersonate = 1/fastcgi.impersonate = 1/g" /etc/php5/php.ini

EXPOSE 80
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]

RUN mkdir -p /run/nginx
RUN mkdir -p /wwwroot
RUN echo "<?php phpinfo();?>">/wwwroot/index.php
RUN touch /etc/php5/fpm.d/www.conf

WORKDIR /wwwroot
VOLUME ["/wwwroot"]

