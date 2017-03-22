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
$ docker build -t ubuntu_with_mt_env:1.0 .
```

これで、ローカルにubuntu_with_mt_envイメージが作成されます。

## コンテナの起動

```
$ docker run --privileged -p 8022:22 -p 8080:80 -v [/path_to_your_local_pc_public_path]:/mnt/ -it ubuntu_with_mt_env:1.0
```

上記では、ポートは、ローカルの8022を22へ、8080を80へフォワードしています。適時、自分の環境に合わせてください。
また [/path_to_your_local_pc_public_path]は、ローカルPC上の公開ディレクトリ(Document Rootとして利用したいディレクトリ)のパスを指定します。

例えば、私の環境では次のようになります。

```
$ docker run --privileged -p 8022:22 -p 8080:80 -v ~/Documents/work/docker/mnt/mt_public:/mnt/ -it ubuntu_with_mt_env:1.0
```


## MTファイルの配置

一番簡単に使うのであればローカルPC上の公開ディレクトリ(ここでは、mt_publicとしています)の下に、mtファイルの一式を起きます。

ディレクトリ構成は

```
mt_public
  - mt
    - mt-config.cgi
    - その他のファイル
    - mt-static
      - support
```
となります。

mt_publicとmtディレクトリは、読み書き可能にして下さい。(MTをインストール完了後は、mtディレクトリは書き込み不可にしても大丈夫です)

また、supportディレクトリも、読み書き可能にして下さい。
/

## データベースの準備

コンテナ内で、データベースを作成してください。mysqlのrootユーザーは、パスワードなしで設定されています。

```
$ mysql -u root
> create database mt_db;
> exit
```

## Apacheの設定

Apacheの設定ファイルである`/etc/apache2/sites-enabled/000-default.conf`
では、Document Rootとして`/mnt`がマウントされているので、このまま利用出来ます。マウントするディレクトリは、適時変更してください。

## MTのインストール

ブラウザから、

```
http://localhost:8080/mt
```

でMTにアクセスしてください。インストールウィザードにしたがって、インストールを行います。
