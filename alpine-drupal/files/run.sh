#!/bin/sh

[ -f /run-pre.sh ] && /run-pre.sh

if [ -d /workspace ] ; then
  chown -R  apache:apache /workspace
fi

if [ ! -d /workspace/public_html ] ; then
  mkdir -p /workspace/public_html
  chown apache:apache /workspace/htdocs
fi

if [! -d /run/apache2 ] ; then
  mkdir -p /run/apache2
  chown apache:apache /run/apache2
fi

# start php-fpm
mkdir -p /workspace/logs/php-fpm
php-fpm

# fix permissions
if [ "$FIX_OWNERSHIP" != "" ] ; then
  chown -R apache:apache /workspace/public_html
fi

# start apache2
mkdir -p /workspace/logs/apache2
mkdir -p /tmp/apache2
chown apache /tmp/apache2
/usr/sbin/apachectl -DFOREGROUND
