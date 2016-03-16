FROM alpine:edge
MAINTAINER Etopian Inc. <contact@etopian.com>

# Add s6-overlay
ENV S6_OVERLAY_VERSION v1.17.1.1

ADD https://github.com/just-containers/s6-overlay/releases/download/${S6_OVERLAY_VERSION}/s6-overlay-amd64.tar.gz /tmp/s6-overlay.tar.gz
RUN tar xvfz /tmp/s6-overlay.tar.gz -C /

ADD root /

# Add the files
RUN rm /etc/s6/services/s6-fdholderd/down

RUN apk --update add php-apache2 apache2-utils && rm -rf /var/cache/apk/*

RUN apk update \
    && apk add bash less ca-certificates \
    php-fpm php-json php-zlib php-xml php-pdo php-phar php-openssl \
    php-pdo_mysql php-mysqli \
    php-gd php-iconv php-mcrypt \
    php-mysql php-curl php-opcache php-ctype php-apcu \
    php-intl php-bcmath php-dom php-xmlreader curl git \
    mysql-client php-pcntl php-posix apk-cron postfix musl

RUN rm -rf /var/cache/apk/*

# Configure apache
RUN sed -i -e 's:/var/www/localhost/htdocs:/workspace/public_html:' /etc/apache2/httpd.conf

RUN sed -i -e 's:#LoadModule rewrite_module:LoadModule rewrite_module:' /etc/apache2/httpd.conf

RUN sed -ie ':/workspace/public_html:{n;s:AllowOverride none:AllowOverride All:}' /etc/apache2/httpd.conf

# Install Composer.
RUN curl -sS https://getcomposer.org/installer | php
RUN mv composer.phar /usr/local/bin/composer

# Install Drush 8 (master) with composer.
RUN composer global require drush/drush
ENV PATH "/root/.composer/vendor/bin:usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

ADD files/php-fpm.conf /etc/php/

ADD files/postfix/main.cf /etc/postfix/main.cf.new
ADD files/postfix/setup_ses.sh /setup_ses.sh


RUN mkdir -p /var/log/php-fpm/ && \
    chmod +x /setup_ses.sh

# configure postfix use to amazon ses to send mail.
ENV SES_HOST="email-smtp.us-east-1.amazonaws.com" SES_PORT="587" \
    SES_USER="" SES_SECRET="" TERM="xterm" \
    DB_HOST="172.17.0.1" DB_USER="" DB_PASS="" DB_NAME=""

RUN /setup_ses.sh

EXPOSE 80 443
VOLUME ["/workspace"]
ENTRYPOINT ["/init"]
