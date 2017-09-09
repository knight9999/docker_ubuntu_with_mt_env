Movable Type用Dockerファイル
---


# 概要

ベースとなるOSは、Ubuntu 16.10です。

Movable Typeを動作させるためのApache,MySQL,ImageMagick,各種CPANファイル
などを組み込んだDockerfileです。

Movable Type本体は入っていません.

ローカル環境にMTを入れて、Docker環境にマウントして利用することを想定しています。


# 使い方

## イメージファイルの作成

`git clone`したディレクトリ(Dockerfileが存在するディレクトリ)に移動して、以下を実行します。

```
$ docker build -t ubuntu_with_mt_env .
```

これで、ローカルにubuntu_with_mt_envイメージが作成されます。

## コンテナの起動

```
$ docker run --privileged -d --name mt_server -p 8022:22 -p 8080:80 -v /path/to/shared/directory:/var/mt/ -it ubuntu_with_mt_env
```

上記では、ポートは、ローカルの8022を22へ、8080を80へフォワードしています。適時、自分の環境に合わせてください。
(Docker 1.13以後ではWindowsでもファイルをマウントして利用できるようになったらしいので、/var/mt/にマウントしています)
マウントしているディレクトリには、wwwディレクトリが必要です。
また、コンテナにはmtという名前をつけていますが、任意のものでOKです。

例１：
```
$ docker run --privileged -d --name mt_server -p 8022:22 -p 8080:80 -v ~/Documents/work/docker/mnt/mt:/var/mt/ -it ubuntu_with_mt_env
```
例２：
```
$ docker run --privileged -d --name mt_server -p 8022:22 -p 8080:80 -v `pwd`/../mnt:/var/mt/ -it ubuntu_with_mt_env
```

これでデーモンが起動しますが、ターミナルは開きません。(本Dockerfileのv1.0とは違います)
ターミナルを開く場合は、後述の`docker exec`を使ってください。

## MTファイルの配置

一番簡単に使うのであれば、コンテナ上のDocument Root /var/mt/wwwの下に(マウントしている場合はホスト上のマウントしているディレクトリでも良い)、mtファイルの一式を起きます。

ディレクトリ構成は

```
mt
  - mysql
  - www
    - mt
      - mt-config.cgi
      - その他のファイル
      - mt-static
        - support
```
となります。

wwwとmtディレクトリは、読み書き可能にして下さい。(MTをインストール完了後は、mtディレクトリは書き込み不可にしても大丈夫です)

また、mt-static/supportディレクトリも、読み書き可能にして下さい。


## データベースの準備

コンテナ内で、データベースを作成してください。mysqlのrootユーザーは、パスワードなしで設定されています。

```
$ mysql -u root
> create database mt_db;
> exit
```

## Postfixの設定

Postfixに必要な設定がある場合は、マウントしているディレクトリ(/path/to/shared/directory)に作られるpostfix以下に
必要なファイル(main.cf)などを置いてください。Dockerコンテナ起動時に、その内容を/etc/postfixにコピーします。
起動時以外には反映されないので注意してください。

### 例：Gmailを中継サーバーに使う。

/etc/postfix/main.cfを/path/to/shared/directory/etc/postfixにコピー


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


## Apacheの設定

Apacheの設定ファイルである`/etc/apache2/sites-enabled/000-default.conf`
では、cgiが使えるように設定してあります。Document Rootを変更する場合は、適時変更を行ってください。


## デーモンを停止する

```
$ docker stop mt
```

## デーモンを起動する

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
