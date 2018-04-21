FROM knaito/ubuntu_with_lamp:1.1

MAINTAINER KENICHI NAITO

ENV DEBIAN_FRONTEND noninteractive

COPY files/etc /etc/

RUN apt-get update -y

RUN apt-get install -y perlmagick

RUN apt-get install -y cpanminus

RUN update-rc.d apache2 defaults && \
    update-rc.d mysql defaults

RUN apt-get install -y samba

RUN cpanm YAML && \
    cpanm DBI && \
    cpanm DBD::mysql && \
    cpanm Module::Install && \
    cpanm Crypt::DSA && \
    cpanm IPC::Run && \
    cpanm Archive::Zip && \
    cpanm Imager && \
    cpanm -f Mail::Sendmail

RUN apt-get install -y iproute2

RUN apt-get install -y cifs-utils

RUN apt-get install -y dnsutils

RUN apt-get install -y systemd

COPY files/entry-script.bash /entry-script.bash

RUN chmod a+x /entry-script.bash

COPY files/win-mount.bash /bin/win-mount

RUN chmod a+x /bin/win-mount

COPY files/win-umount.bash /bin/win-umount

RUN chmod a+x /bin/win-umount

COPY files/win-checkmount.bash /bin/win-checkmount

RUN chmod a+x /bin/win-checkmount

COPY files/.vimrc /.vimrc

CMD ["/entry-script.bash"]
