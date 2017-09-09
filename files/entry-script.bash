#!/bin/bash

mkdir -p /var/mt/www

mkdir -p /var/mt/mysql

cp -rpn /var/lib/mysql/* /var/mt/mysql/
cp -pf /etc/mysql/mysql.conf.d/mysqld.cnf.docker /etc/mysql/mysql.conf.d/mysqld.cnf

mkdir -p /var/mt/etc

cp -rpf /var/mt/etc/* /etc/

service rsyslog start
service apache2 start
service mysql start
service postfix start

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
