How to install MT
----

### Run docker container

```
$ docker pull knaito/ubuntu_with_mt_env
$ docker run --privileged -d --name mt -p 8022:22 -p 8080:80 -v ~/Documents/work/docker/mnt/share:/var/mt/ -it ubuntu_with_mt_env
```

### Install MT

- Create mt directory under the document root /var/mt/www. Put all mt system files (mt-data-api.cgi and other cgi files) and directories. Put execute permission on all .cgi files.
- put write permission on document root and mt directory.
- put write permission recursively on mt/mt-static/support directory.
- create database on MySQL.
- open `http://localhost:8080/mt` by your browser. Create admin user and website according to the MT install wizard.
