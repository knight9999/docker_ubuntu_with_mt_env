Movable Type用Dockerファイル
---


# 概要

ベースとなるOSは、Ubuntu 17.10です。

Movable Typeを動作させるためのApache,MySQL,ImageMagick,各種CPANファイル
などを組み込んだDockerfileです。

Movable Type本体は入っていません.

ローカル環境にMTを入れて、Docker環境にマウントして利用することを想定しています。


docker hubにビルド済みのイメージがあります。こちらを使うときは、

```
$ docker pull knaito/ubuntu_with_mt_env
```

とします。こちらを使う場合は、イメージファイルの作成をスキップし、以後、ubuntu_with_mt_envは、knaito/ubuntu_with_mt_envと読み替えてください。

# 使い方

## イメージファイルの作成

`git clone`したディレクトリ(Dockerfileが存在するディレクトリ)に移動して、以下を実行します。

```
$ docker build -t ubuntu_with_mt_env .
```

これで、ローカルにubuntu_with_mt_envイメージが作成されます。(名前は `ubuntu_with_mt_env`でなくても、なんでも構いません)

## MySQL用のボリュームの用意

例えば、`mt-storage`という名前のボリュームを作成するのであれば、

```
$ docker volume create mt-storge
```

確認

```
$ docker volume ls
```

削除

```
$ docker volume rm mt-storage
```

## コンテナの起動

例えば、`mt_server`という名前のコンテナを作成するのであれば、次のようにします。

```
$ docker run --privileged -d --name mt_server -p 8022:22 -p 8080:80 -v /path/to/shared/directory:/var/mt/ -v mt-storage:/var/db/mysql  -it ubuntu_with_mt_env
```

ここで、/path/to/shared/directoryは、マウントするディレクトリです。このディレクトリの下にwwwディレクトリが（もしなければ）作成され、以後、Apacheによりマウントされます。

macであれば`pwd`を使って

```
$ docker run --privileged -d --name mt_server -p 8022:22 -p 8080:80 -v `pwd`/mt:/var/mt/ -v mt-storage:/var/db/mysql  -it ubuntu_with_mt_env
```

ともできます。また、上記ではmt-storageというボリュームをコンテナ内の/var/db/mysqlにマウントしていますが、macの場合、mysqlのボリュームを直接ディレクトリにマウントしてもOKです。
その場合は、例えば自分のローカルにmysqlというディレクトリを作成して

```
$ docker run --privileged -d --name mt_server -p 8022:22 -p 8080:80 -v `pwd`/mt:/var/mt/ -v `pwd`/mysql:/var/db/mysql  -it ubuntu_with_mt_env
```

のようにします。



これでデーモンが起動しますが、ターミナルは開きません。(本Dockerfileのv1.0とは違います)
ターミナルを開く場合は、後述の`docker exec`を使ってください。

## コンテナへのログイン

次でログインします

```
$ docker exec -it mt_server bash
```




## MTファイルの配置

一番簡単に使うのであれば、コンテナ上のDocument Root /var/mt/wwwの下に(ホスト上のマウントしているディレクトリ`/path/to/shared/directory`の下の`www`の下でも良い)、mtファイルの一式を起きます。

ディレクトリ構成は

```
mt
  - www
    - mt
      - mt-config.cgi
      - その他のファイル
      - mt-static
        - support
```
となります。

wwwとmtディレクトリは、読み書き可能にして下さい。(MTをインストール完了後は、mtディレクトリは書き込み不可にしても大丈夫です。いつものmtの設定です)

また、mt-static/supportディレクトリも、読み書き可能にして下さい。


## データベースの準備

最初、自動で空のDBが作成されます。名前はmtdbです。自分でDBを作りたい場合、コンテナにログインして作成してください。mysqlのrootユーザーでパスワードなしで設定されています。

```
$ mysql -u root
> create database mt_db;
> exit
```

## 注意事項

mysqlを起動・終了させるためのユーザーdebian-sys-maintはハードコーディングされているので、変更したい場合は、
files/etc/mysql/debian.cnfを修正し、合わせてfiles/entry-script.bashの中のパスワードも変更してください。

## Postfixの設定

Postfixに必要な設定がある場合は、マウントしているディレクトリ(/path/to/shared/directory)に作られるpostfix以下に
必要なファイル(main.cf)などを置いてください。Dockerコンテナ起動時に、その内容を/etc/postfixにコピーします。
起動時以外には反映されないので注意してください。

### 例：Gmailを中継サーバーに使う。

`/etc/postfix/main.cf` を `/path/to/shared/directory/etc/postfix` にコピー

`main.cf` を編集します。
既存の
```
relayhost =
```
を削除

次を追加

```
# GMail
relayhost = [smtp.gmail.com]:587
smtp_use_tls = yes
smtp_tls_CApath = /etc/ssl/certs
smtp_sasl_auth_enable = yes
smtp_sasl_password_maps = hash:/etc/postfix/sasl_passwd
smtp_sasl_tls_security_options = noanonymous
smtp_sasl_mechanism_filter = plain
```

(centOS系の場合は、
```
smtp_tls_CApath = /etc/ssl/certs
```
の代わりに
```
smtp_tls_CAfile = /etc/pki/tls/certs/ca-bundle.crt
```
らしい
)

コンテナ上で次を実行

```
# vi /etc/postfix/sasl_passwd
```
として、
```
[smtp.gmail.com]:587     <gmail_address>:<password>
```
を書き込む。

として、次を実行

```
# chmod 600 /etc/postfix/sasl_passwd
# postmap hash:/etc/postfix/sasl_passwd
```

postmapコマンドで生成されたsasl_psswd.db
を、/path/to/shared/directory/etc/postfixにコピー

反映させるために、hostに戻って

$ docker stop mt_server
$ docker start mt_server

## Gmail側で、安全性の低いアプリからのメールを許可する必要がある

以下にアクセスして、安全性の低いアプリを許可しないといけないようです。

https://support.google.com/accounts/answer/6010255?hl=ja


## Apacheの設定

Apacheの設定ファイルである`/etc/apache2/sites-enabled/000-default.conf`
では、cgiが使えるように設定してあります。Document Rootを変更する場合は、適時変更を行ってください。


## コンテナを停止する

```
$ docker stop mt
```

## コンテナを起動する

```
$ docker start mt
```

## ターミナルに接続

```
$ docker exec -it mt bash
```


## MTのインストール

ブラウザから、

```
http://localhost:8080/mt
```

でMTにアクセスしてください。インストールウィザードにしたがって、インストールを行います。

## ChangeLog


1.2 Based on Ubuntu 17.10. Mysql Volume is separated.
1.0 Based on Ubuntu 16.10
