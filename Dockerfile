FROM amd64/debian:buster-slim

LABEL maintainer="masafumi.hasegawa@gmail.com"

ENV DEBIAN_FRONTEND noninteractive

COPY sources.list /etc/apt/sources.list
RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install -y --no-install-recommends tzdata locales curl perl adduser patch supervisor libio-socket-ssl-perl libgomp1 ca-certificates libcrypt-openssl-rsa-perl

RUN curl -fLs --output /tmp/lms.deb https://downloads.slimdevices.com/LogitechMediaServer_v8.3.0/logitechmediaserver_8.3.0_amd64.deb
RUN dpkg -i /tmp/lms.deb
RUN rm -f /tmp/lms.deb

COPY ./logitechmediaserver.conf /etc/supervisor/conf.d/logitechmediaserver.conf

RUN apt-get clean
RUN rm -rf /var/cache/apt/archives/* /var/lib/apt/lists/*

EXPOSE 3483/udp 3483 9000 9090

CMD /usr/bin/supervisord
