FROM alpine:edge
MAINTAINER NexusStar <info@nexustar.name>

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
    php-gd php-iconv php-mcrypt php-mysql \
    php-curl php-opcache php-ctype php-apcu \
    php-intl php-bcmath php-dom php-xmlreader php-pcntl php-posix  \
    curl git mysql-client apk-cron postfix musl \
    openssh-sftp-server openssh linux-pam

RUN rm -rf /var/cache/apk/*

# Configure Apache
RUN sed -i -e 's:#LoadModule rewrite_module:LoadModule rewrite_module:' /etc/apache2/httpd.conf

# Apache permissions to /workspace/public_html
RUN set -i 's/apache:x:1000:1000:Linux User,,,:\/var\/www:\/sbin\/nologin/apache:x:1000:1000:Linux User,,,:\/workspace\/public_html:\/sbin\/nologin/g' /etc/passwd

# Setup SSH.
RUN ssh-keygen -A
RUN echo 'root:root' | chpasswd
RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN mkdir /var/run/sshd && chmod 0755 /var/run/sshd
RUN mkdir -p /root/.ssh/ && touch /root/.ssh/authorized_keys
RUN echo 'session optional pam_loginuid.so' > /etc/pam.d/sshd


# Install Composer.
RUN curl -sS https://getcomposer.org/installer | php
RUN mv composer.phar /usr/local/bin/composer

# Install Drush 8 (master) with composer.
RUN composer global require drush/drush
ENV PATH "/root/.composer/vendor/bin:usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

RUN echo -e "\nexport TERM=xterm" >> ~/.bashrc

ADD files/php-fpm.conf /etc/php/

RUN mkdir -p /var/log/php-fpm/

EXPOSE 80 443 22
VOLUME ["/workspace"]
ENTRYPOINT ["/init"]
