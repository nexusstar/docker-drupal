# from https://www.drupal.org/requirements/php#drupalversions
FROM php:5.6-apache

RUN a2enmod rewrite

# install the PHP extensions we need
RUN apt-get update && apt-get install -y libpng12-dev libjpeg-dev libpq-dev \
	&& rm -rf /var/lib/apt/lists/* \
	&& docker-php-ext-configure gd --with-png-dir=/usr --with-jpeg-dir=/usr \
	&& docker-php-ext-install gd mbstring pdo pdo_mysql pdo_pgsql zip

# Install Git
RUN apt-get update && apt-get install -y git

# Install xdebug
RUN yes | pecl install xdebug \
    && echo "zend_extension=$(find /usr/local/lib/php/extensions/ -name xdebug.so)" > /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.remote_enable=on" >> /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.remote_autostart=off" >> /usr/local/etc/php/conf.d/xdebug.ini

# Install Composer.
RUN curl -sS https://getcomposer.org/installer | php
RUN mv composer.phar /usr/local/bin/composer

#Install Drush
RUN composer global require drush/drush
RUN composer global update

RUN export PATH="$HOME/.composer/vendor/bin:$PATH"

# set recommended PHP.ini settings
# see https://secure.php.net/manual/en/opcache.installation.php
RUN { \
		echo 'opcache.memory_consumption=128'; \
		echo 'opcache.interned_strings_buffer=8'; \
		echo 'opcache.max_accelerated_files=4000'; \
		echo 'opcache.revalidate_freq=60'; \
		echo 'opcache.fast_shutdown=1'; \
		echo 'opcache.enable_cli=1'; \
	} > /usr/local/etc/php/conf.d/opcache-recommended.ini

WORKDIR /var/www/html

# https://www.drupal.org/node/3060/release
ENV DRUPAL_VERSION 7
ENV DRUPAL_RELEASE 41
ENV MY_SITE mysite

RUN git clone --branch ${DRUPAL_VERSION}.x https://git.drupal.org/project/drupal.git .

# Avoid detached head state
RUN git checkout -b ${MY_SITE} ${DRUPAL_VERSION}.${DRUPAL_RELEASE}
RUN git remote rename origin drupal

VOLUME ["/var/www/html/sites/all/themes/contrib", \
	"/var/www/html/sites/all/themes/custom", \
	"/var/www/html/sites/all/modules/contrib", \
	"/var/www/html/sites/all/modules/custom", \
	"/var/www/html/sites/default/files" ]

EXPOSE 80

RUN chown -R www-data:www-data /var/www/html/sites
