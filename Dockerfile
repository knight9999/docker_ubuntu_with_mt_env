FROM ubuntu:16.10

MAINTAINER KENICHI NAITO

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update

RUN apt-get install -y apt-utils

RUN apt-get install -y build-essential

RUN apt-get install -y debconf-utils

RUN apt-get install -y mysql-server mysql-client libmysqlclient-dev

RUN apt-get install -y apache2

RUN apt-get install -y imagemagick

RUN apt-get install -y perlmagick 

RUN apt-get install -y postfix

RUN apt-get install -y vim

RUN apt-get install -y cpanminus

RUN update-rc.d apache2 defaults && \
    update-rc.d mysql defaults 

RUN a2enmod cgi

RUN cpanm YAML && \
    cpanm DBI && \
    cpanm DBD::mysql && \
    cpanm Crypt::DSA && \
    cpanm IPC::Run && \
    cpanm Archive::Zip && \
    cpanm Imager && \
    cpanm Mail::Sendmail

COPY 000-default.conf /etc/apache2/sites-available/

ENTRYPOINT service apache2 start && service mysql start && service postfix start && bash

