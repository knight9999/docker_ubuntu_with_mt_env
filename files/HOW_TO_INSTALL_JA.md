How to install MT
----

### Dockerコンテナの起動

```
$ docker pull knaito/ubuntu_with_mt_env
$ docker run --privileged -d --name mt_server -p 8022:22 -p 8080:80 -v ~/Documents/work/docker/mnt/share:/var/mt/ -it knaito/ubuntu_with_mt_env
```

### Terminal, Stop, Start container

```
$ docker exec -it mt_server /bin/bash
$ docker stop mt_server
$ docker start mt_server
```

### MTのインストール

- document root /var/mt/wwwの下にmtディレクトリを作成します。mtディレクトリの下に、すべてのシステムファイル(mt-data-api.cgiなど)とディレクトリを配置します。
- document rootとmtディレクトリに書き込み権限をつけます。
- mt/mt-static/supportディレクトリに、再帰的に書き込み権限をつけます。
- MySQLでデータベースを作成します。
- ブラウザで`http://localhost:8080/mt`にアクセスします。管理者ユーザーとウェブサイトをMTのインストールウィザードにしたがって作成します。

### 詳細情報

https://github.com/knight9999/docker_ubuntu_with_mt_env
