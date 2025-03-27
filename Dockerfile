FROM ubuntu:noble

MAINTAINER Richard Freeman <rich@rich0.org>

LABEL org.opencontainers.image.source https://github.com/rich0/veilid

ENV EMAIL rich@rich0.org

ENV DEBIAN_FRONTEND=noninteractive

ARG VEILID_VERSION

RUN apt update && apt dist-upgrade -y

RUN apt install software-properties-common gpg wget -y

RUN cd /tmp

RUN wget -O- https://packages.veilid.net/gpg/veilid-packages-key.public | gpg --dearmor -o /usr/share/keyrings/veilid-packages-keyring.gpg

RUN echo "deb [arch=amd64 signed-by=/usr/share/keyrings/veilid-packages-keyring.gpg] https://packages.veilid.net/apt stable main" > /etc/apt/sources.list.d/veilid.list

RUN apt-get update

RUN apt install veilid-server=$VEILID_VERSION veilid-cli=$VEILID_VERSION

RUN apt-get clean

COPY veilid-server.conf /etc/veilid-server/veilid-server.conf

EXPOSE 5959/tcp

EXPOSE 5050/tcp

EXPOSE 5050/udp

CMD ["/usr/bin/veilid-server","--foreground"]


# /var/db/veilid-server

# veilid-server --foreground 
# port 5959, 5150
# client connects to 5959



