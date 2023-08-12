#!/bin/bash
docker build . --pull --no-cache --tag ghcr.io/rich0/veilid && docker push ghcr.io/rich0/veilid
