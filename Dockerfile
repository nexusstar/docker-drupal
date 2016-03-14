FROM gliderlabs/alpine:edge
MAINTAINER NexusStar <nexus.star@nexusstar.name>

# isntall mysql
RUN apk add --update --no-cache supervisor mysql mysql-client

# install apache
RUN apk add --update --no-cache apache2 apache2-utils

#install php
RUN apk add --update --no-cache php \
	wget \
	curl \
	git \
	zlib \
	gzip \
	tar \
	php-apache2 \
	php-ctype \
	php-curl \
	php-curl \
	php-dom \
	php-gd \
	php-intl \
	php-json \
	php-mysql \
	php-opcache \
	php-openssl \
	php-pdo \
	php-phar \
	php-zlib \
	php-xml \
	php-sqlite3

# remove cache just in case
RUN rm -rf /var/cache/apk/*

# Install Composer.
RUN curl -sS https://getcomposer.org/installer | php
RUN mv composer.phar /usr/local/bin/composer

# Install Drush 8 (master) with composer.
RUN composer global require drush/drush
ENV PATH "/root/.composer/vendor/bin:usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

# Install Drupal Console.
RUN curl http://drupalconsole.com/installer -L -o drupal.phar
RUN mv drupal.phar /usr/local/bin/drupal && chmod +x /usr/local/bin/drupal
RUN drupal init --override

# Setup PHP
RUN sed -i 's/display_errors = Off/display_errors = On/' /etc/php/php.ini

# Install Drupal.
RUN rm -rf /var/www
RUN cd /var && \
	drupal site:new www 8.0.5

RUN mkdir -p /var/www/sites/default/files && \
	chmod a+w /var/www/sites/default -R && \
	mkdir /var/www/sites/all/modules/contrib -p && \
	mkdir /var/www/sites/all/modules/custom && \
	mkdir /var/www/sites/all/themes/contrib -p && \
	mkdir /var/www/sites/all/themes/custom && \
	cp /var/www/sites/default/default.settings.php /var/www/sites/default/settings.php && \
	cp /var/www/sites/default/default.services.yml /var/www/sites/default/services.yml && \
	chmod 0664 /var/www/sites/default/settings.php && \
	chmod 0664 /var/www/sites/default/services.yml

RUN chown -R apache:apache /var/www/

# Configure mysql
RUN /usr/bin/mysql_install_db --user=mysql
RUN /etc/init.d/mysql start
RUN rc-update add mysql default
RUN /usr/bin/mysqladmin -u root password 'password'

RUN rc-update add mysql default && \
	cd /var/www && \
	drupal site:install standard \
		--site-name="Drupal 8" \
		--db-type=mysql \
		--db-user=root \
		--db-pass="password" \
		--db-name=drupal \
		--site-mail=admin@example.com \
		--account-name=admin \
		--account-mail=admin@example.com \
		--account-pass=admin

RUN /etc/init.d/mysql start && \
	cd /var/www && \
	drupal module:install admin_toolbar --latest && \
	drupal module:install simpletest

EXPOSE 80 3306 22
CMD exec supervisord -n
