FROM ubuntu:jammy

MAINTAINER Richard Freeman <rich@rich0.org>

LABEL org.opencontainers.image.source https://github.com/rich0/veilid

ENV BACULA_VERSION 13.0.3

# get your key on: https://www.bacula.org/bacula-binary-package-download/
ENV BACULA_KEY 647031b8bc3ae

ENV EMAIL rich@rich0.org

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && apt dist-upgrade -y

RUN apt install software-properties-common gpg wget -y

RUN cd /tmp

RUN wget -O- https://packages.veilid.net/gpg/veilid-packages-key.public | sudo gpg --dearmor -o /usr/share/keyrings/veilid-packages-keyring.gpg

RUN echo "deb [arch=amd64 signed-by=/usr/share/keyrings/veilid-packages-keyring.gpg] https://packages.veilid.net/apt stable main" > /etc/apt/sources.list.d/veilid.list

RUN apt-get update

RUN apt install veilid-server veilid-cli

RUN apt-get clean

