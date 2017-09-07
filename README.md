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
$ docker run --privileged -d --name mt -p 8022:22 -p 8080:80 -v /path/to/shared/directory:/var/www/ -it ubuntu_with_mt_env
```

上記では、ポートは、ローカルの8022を22へ、8080を80へフォワードしています。適時、自分の環境に合わせてください。
(Docker 1.13以後ではWindowsでもファイルをマウントして利用できるようになったらしいので、/var/www/にマウントしています)
また、コンテナにはmtという名前をつけていますが、任意のものでOKです。

```
$ docker run --privileged -d --name mt -p 8022:22 -p 8080:80 -v ~/Documents/work/docker/mnt/share:/var/www/ -it ubuntu_with_mt_env
```

これでデーモンが起動しますが、ターミナルは開きません。(本Dockerfileのv1.0とは違います)
ターミナルを開く場合は、後述の`docker exec`を使ってください。

## MTファイルの配置

一番簡単に使うのであれば、コンテナ上のDocument Root /var/wwwの下に、mtファイルの一式を起きます。

ディレクトリ構成は

```
www
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
