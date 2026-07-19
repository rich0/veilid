#!/bin/bash
set -euo pipefail
VEILID_VERSION=0.5.7
IMAGE=registry.rich0.org/public/veilid
docker build . --pull --no-cache --build-arg VEILID_VERSION=$VEILID_VERSION \
  --tag "$IMAGE:$VEILID_VERSION" --tag "$IMAGE:latest"
docker push "$IMAGE:$VEILID_VERSION"
docker push "$IMAGE:latest"
