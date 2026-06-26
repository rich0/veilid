FROM ubuntu:resolute

LABEL org.opencontainers.image.authors="Richard Freeman <rich@rich0.org>"

LABEL org.opencontainers.image.source=https://github.com/rich0/veilid

ENV EMAIL=rich@rich0.org

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && apt dist-upgrade -y

RUN apt install software-properties-common gpg wget -y

WORKDIR /tmp

RUN wget -O- https://packages.veilid.net/gpg/veilid-packages-key.public | gpg --dearmor -o /usr/share/keyrings/veilid-packages-keyring.gpg

RUN echo "deb [arch=amd64 signed-by=/usr/share/keyrings/veilid-packages-keyring.gpg] https://packages.veilid.net/apt stable main" > /etc/apt/sources.list.d/veilid.list

RUN apt-get update

ARG VEILID_VERSION

RUN apt install veilid-server=$VEILID_VERSION veilid-cli=$VEILID_VERSION

RUN apt-get clean

COPY veilid-server.conf /etc/veilid-server/veilid-server.conf

RUN groupadd --gid 1000 veilid \
 && useradd --uid 1000 --gid 1000 --no-create-home --shell /usr/sbin/nologin veilid \
 && mkdir -p /var/db/veilid-server/protected_store \
             /var/db/veilid-server/table_store \
             /var/db/veilid-server/block_store \
 && chown -R veilid:veilid /var/db/veilid-server \
 && chown -R veilid:veilid /etc/veilid-server

USER veilid

EXPOSE 5959/tcp

EXPOSE 5050/tcp

EXPOSE 5050/udp

CMD ["/usr/bin/veilid-server","--foreground"]


# /var/db/veilid-server

# veilid-server --foreground 
# port 5959, 5150
# client connects to 5959



