How to install MT
----

### Dockerコンテナの起動

```
$ docker pull knaito/ubuntu_with_mt_env
$ docker run --privileged -p 8022:22 -p 8080:80 -v /path/to/shared/directory:/mnt/ -it knaito/ubuntu_with_mt_env
```

### MTのインストール

- document root /var/wwwの下にmtディレクトリを作成します。mtディレクトリの下に、すべてのシステムファイル(mt-data-api.cgiなど)とディレクトリを配置します。
- document rootとmtディレクトリに書き込み権限をつけます。
- mt/mt-static/supportディレクトリに、再帰的に書き込み権限をつけます。
- MySQLでデータベースを作成します。
- ブラウザで`http://localhost:8080/mt`にアクセスします。管理者ユーザーとウェブサイトをMTのインストールウィザードにしたがって作成します。
