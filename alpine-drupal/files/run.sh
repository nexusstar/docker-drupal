#!/bin/sh

[ -f /run-pre.sh ] && /run-pre.sh

if [ -d /workspace ] ; then
  chown -R  apache:www-data /workspace
fi

if [ ! -d /workspace/public_html ] ; then
  mkdir -p /workspace/public_html
  chown apache:www-data /workspace/htdocs
fi

if [! -d /run/apache2 ] ; then
  mkdir -p /run/apache2
  chown apache:www-data /run/apache2
fi

# start php-fpm
mkdir -p /workspace/logs/php-fpm
php-fpm
postfix start

# start apache2
mkdir -p /workspace/logs/apache2
mkdir -p /tmp/apache2
chown apache /tmp/apache2
/usr/sbin/apachectl -DFOREGROUND
