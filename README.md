# veilid

Docker image for [veilid-server](https://github.com/veilid/veilid).

## Image

- Registry: `registry.rich0.org/public/veilid` (Zot, public anonymous pull)
- Base: `ubuntu:resolute`
- Packages: `veilid-server`, `veilid-cli` from [packages.veilid.net](https://packages.veilid.net)
- Ports: `5959/tcp` (client), `5050/tcp` + `5050/udp`
- Config: `/etc/veilid-server/veilid-server.conf`

### Pull

```bash
docker pull registry.rich0.org/public/veilid:latest
# or pin a version
docker pull registry.rich0.org/public/veilid:0.5.5
```

Public pulls do not require login.

## Build and publish

```bash
docker login registry.rich0.org -u ci-push -p '<password>'
./build-push.sh
```

Pins `VEILID_VERSION` and publishes to `registry.rich0.org/public/veilid` (`:<version>` and `:latest`).

Nightly builds (from `nightly/`):

```bash
cd nightly
./build-push.sh
```

Tags `:nightly-<date>` and `:nightly`.
