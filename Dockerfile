FROM knaito/ubuntu_with_lamp:1.0

MAINTAINER KENICHI NAITO

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update -y

RUN apt-get install -y perlmagick

RUN apt-get install -y cpanminus

RUN update-rc.d apache2 defaults && \
    update-rc.d mysql defaults

RUN cpanm YAML && \
    cpanm DBI && \
    cpanm DBD::mysql && \
    cpanm Crypt::DSA && \
    cpanm IPC::Run && \
    cpanm Archive::Zip && \
    cpanm Imager && \
    cpanm -f Mail::Sendmail

COPY files/000-default.conf /etc/apache2/sites-available/
COPY files/HOW_TO_INSTALL.md /
COPY files/HOW_TO_INSTALL_JA.md /
COPY files/mysqld.cnf /etc/mysql/mysql.conf.d/mysqld.cnf.docker
COPY files/entry-script.bash /entry-script.bash

RUN chmod a+x /entry-script.bash

CMD ["/entry-script.bash"]
