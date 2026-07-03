FROM ubuntu:resolute AS builder

ENV DEBIAN_FRONTEND=noninteractive

ARG VEILID_VERSION

RUN apt-get update \
 && apt-get install -y --no-install-recommends ca-certificates gnupg wget \
 && wget -O- https://packages.veilid.net/gpg/veilid-packages-key.public \
    | gpg --dearmor -o /usr/share/keyrings/veilid-packages-keyring.gpg \
 && echo "deb [arch=amd64 signed-by=/usr/share/keyrings/veilid-packages-keyring.gpg] https://packages.veilid.net/apt nightly main" \
    > /etc/apt/sources.list.d/veilid.list \
 && apt-get update \
 && apt-get install -y --no-install-recommends \
    veilid-server=${VEILID_VERSION} veilid-cli=${VEILID_VERSION} \
 && rm -rf /var/lib/apt/lists/*

FROM ubuntu:resolute

LABEL org.opencontainers.image.authors="Richard Freeman <rich@rich0.org>"
LABEL org.opencontainers.image.source=https://github.com/rich0/veilid

ENV EMAIL=rich@rich0.org
ENV DEBIAN_FRONTEND=noninteractive

RUN groupadd -g 1000 veilid \
 && useradd -u 1000 -g 1000 -d /var/db/veilid-server -s /usr/sbin/nologin veilid \
 && mkdir -p /var/db/veilid-server/{protected_store,table_store,block_store} /etc/veilid-server \
 && chown -R veilid:veilid /var/db/veilid-server \
 && rm -rf /var/lib/apt/lists/* /usr/share/doc /usr/share/man \
 && find /usr/share/locale -mindepth 1 -maxdepth 1 ! -name 'en*' -exec rm -rf {} + 2>/dev/null || true

COPY --from=builder /usr/bin/veilid-server /usr/bin/veilid-server
COPY --from=builder /usr/bin/veilid-cli /usr/bin/veilid-cli
COPY veilid-server.conf /etc/veilid-server/veilid-server.conf

RUN chown -R veilid:veilid /etc/veilid-server

USER veilid

EXPOSE 5959/tcp
EXPOSE 5050/tcp
EXPOSE 5050/udp

CMD ["/usr/bin/veilid-server","--foreground"]