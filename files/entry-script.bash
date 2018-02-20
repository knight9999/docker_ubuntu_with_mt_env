#!/bin/bash

if [ ! -e /var/mt/www ]; then
  mkdir -p /var/mt/www
  chmod a+w /var/mt/www
fi

if [ ! -e /var/db/mysql ]; then
  mkdir -p /var/db/mysql
fi
chmod a+w /var/db/mysql

cp -rpn /var/lib/mysql/* /var/db/mysql/

mkdir -p /var/mt/etc

cp -rpf /var/mt/etc/* /etc/

service rsyslog start
service apache2 start
service mysql start
service postfix start

if [ ! -e /started ]; then
  mysql -uroot -e "GRANT ALL PRIVILEGES ON *.* TO 'debian-sys-maint'@'localhost' IDENTIFIED BY 'asdjklsd1xja' WITH GRANT OPTION;"
  V=$(mysql -uroot --skip-column-names -B -e "show databases like 'mtdb';")
  if [[ -z "$V" ]]; then
    echo "Create root@% user"
    mysql -uroot -e "CREATE DATABASE mtdb;"
  fi
fi

touch /started

trap_TERM() {
  echo 'SIGTERM ACCEPTED.'
  service apache2 stop
  service mysql stop
  service postfix stop
  service rsyslog stop
  exit 0
}
trap 'trap_TERM' TERM

while :
do
  sleep 5
done
