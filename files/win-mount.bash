#!/bin/bash


if [ "$1" = "" ]; then
  echo "Username is not specified"
  echo "formula: mount_win.bash username target_path"
  exit 1
fi

if [ "$2" = "" ]; then
  echo "target_path is not specified"
  echo "sample: /mt/www if your PC's share directory is //localhost/mt/www"
  echo "formula: mount_win.bash username target_path"
  exit 1
fi



name=$1
target_host=$(host -t a docker.for.win.localhost | awk 'NR==1{print $4}')
target_path=$2

echo $name
echo $target_host


check_mount=$(mountpoint /var/mt/www)

if [ "$check_mount" = "/var/mt/www is a mountpoint" ]; then
  echo "Alread mounted /var/mt/www"
  exit 1
fi

mount -t cifs -o username=${name},uid=root,gid=root,rw,file_mode=0777,dir_mode=0777 //${target_host}${target_path} /var/mt/www
