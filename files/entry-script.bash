#!/bin/bash

mkdir -p /var/mt/www

mkdir -p /var/mt/mysql

cp -rpu /var/lib/mysql/* /var/mt/mysql
cp -pu /etc/mysql/mysql.conf.d/mysqld.cnf.docker /etc/mysql/mysql.conf.d/mysqld.cnf

service apache2 start
service mysql start
service postfix start

trap_TERM() {
  echo 'SIGTERM ACCEPTED.'
  service apache2 stop
  service mysql stop
  service postfix stop
  exit 0
}
trap 'trap_TERM' TERM

while :
do
  sleep 5
done
