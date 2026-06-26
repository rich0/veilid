# veilid

Docker image for [veilid-server](https://github.com/veilid/veilid).

## Build

```bash
./build-push.sh
```

Pins `VEILID_VERSION` and publishes to `ghcr.io/rich0/veilid`.

## Image

- Base: `ubuntu:resolute`
- Packages: `veilid-server`, `veilid-cli` from [packages.veilid.net](https://packages.veilid.net)
- Ports: `5959/tcp` (client), `5050/tcp` + `5050/udp`
- Config: `/etc/veilid-server/veilid-server.conf`