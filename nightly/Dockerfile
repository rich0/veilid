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

RUN adduser --system --group veilid \
 && groupmod -o -g 1000 veilid \
 && usermod -o -u 1000 -g 1000 veilid \
 && mkdir -p /var/db/veilid-server/{protected_store,table_store,block_store,ipc} /etc/veilid-server \
 && chown -R veilid:veilid /var/db/veilid-server \
 && chmod 0750 /var/db/veilid-server /var/db/veilid-server/protected_store \
    /var/db/veilid-server/table_store /var/db/veilid-server/block_store /var/db/veilid-server/ipc \
 && rm -rf /var/lib/apt/lists/* /usr/share/doc /usr/share/man \
 && find /usr/share/locale -mindepth 1 -maxdepth 1 ! -name 'en*' -exec rm -rf {} + 2>/dev/null || true

COPY --from=builder --chown=veilid:veilid /usr/bin/veilid-server /usr/bin/veilid-server
COPY --from=builder --chown=veilid:veilid /usr/bin/veilid-cli /usr/bin/veilid-cli
COPY --chown=veilid:veilid veilid-server.conf /etc/veilid-server/veilid-server.conf

RUN chmod 755 /usr/bin/veilid-server /usr/bin/veilid-cli

USER veilid

EXPOSE 5959/tcp
EXPOSE 5050/tcp
EXPOSE 5050/udp

CMD ["/usr/bin/veilid-server","--foreground"]