#!/bin/bash
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
