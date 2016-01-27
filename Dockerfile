# from https://www.drupal.org/requirements/php#drupalversions
FROM php:5.6-apache

RUN a2enmod rewrite

# install the PHP extensions we need
RUN apt-get update && apt-get install -y libpng12-dev libjpeg-dev libpq-dev \
	&& rm -rf /var/lib/apt/lists/* \
	&& docker-php-ext-configure gd --with-png-dir=/usr --with-jpeg-dir=/usr \
	&& docker-php-ext-install gd mbstring pdo pdo_mysql pdo_pgsql zip

# install Git
RUN apt-get update && apt-get install -y git

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
