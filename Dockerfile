FROM knaito/ubuntu_with_lamp:1.1

MAINTAINER KENICHI NAITO

ENV DEBIAN_FRONTEND noninteractive

COPY files/etc /etc/

RUN apt-get update -y

RUN apt-get install -y perlmagick

RUN apt-get install -y cpanminus

RUN update-rc.d apache2 defaults && \
    update-rc.d mysql defaults

RUN cpanm YAML && \
    cpanm DBI && \
    cpanm DBD::mysql && \
    cpanm Module::Install && \
    cpanm Crypt::DSA && \
    cpanm IPC::Run && \
    cpanm Archive::Zip && \
    cpanm Imager && \
    cpanm -f Mail::Sendmail

COPY files/entry-script.bash /entry-script.bash

RUN chmod a+x /entry-script.bash

CMD ["/entry-script.bash"]
