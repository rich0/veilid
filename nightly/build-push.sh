#!/bin/bash
set -euo pipefail
VEILID_VERSION=20260131
IMAGE=registry.rich0.org/public/veilid
docker build . --pull --no-cache --build-arg VEILID_VERSION=$VEILID_VERSION \
  --tag "$IMAGE:nightly-$VEILID_VERSION" --tag "$IMAGE:nightly"
docker push "$IMAGE:nightly-$VEILID_VERSION"
docker push "$IMAGE:nightly"
