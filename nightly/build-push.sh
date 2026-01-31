#!/bin/bash
VEILID_VERSION=20260131
docker build . --pull --no-cache --build-arg VEILID_VERSION=$VEILID_VERSION --tag ghcr.io/rich0/veilid:nightly-$VEILID_VERSION --tag ghcr.io/rich0/veilid:nightly && docker push ghcr.io/rich0/veilid:nightly-$VEILID_VERSION && docker push ghcr.io/rich0/veilid:nightly
#VEILID_VERSION=0.1.7
#docker build . --pull --no-cache --build-arg VEILID_VERSION=$VEILID_VERSION --tag ghcr.io/rich0/veilid:$VEILID_VERSION && docker push ghcr.io/rich0/veilid:$VEILID_VERSION 



