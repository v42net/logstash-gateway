#!/bin/bash
set -e
cd $(dirname $0)
source ./versions
repo=$(git config --get remote.origin.url)
branch=$(git rev-parse --abbrev-ref HEAD)
name=$(basename ${repo%.*})
repo=$(basename $(dirname ${repo}))/${name}
tags="-t ${repo}:$(date +%F) -t ${repo}:${branch}"
if [ $branch == "main" ]; then
    tags="${tags} -t ${repo}:latest"
fi
docker build --no-cache                                     \
     --build-arg DEBIAN_VERSION=${DEBIAN_VERSION}           \
     --build-arg S6_OVERLAY_VERSION=${S6_OVERLAY_VERSION}   \
     --build-arg LOGSTASH_VERSION=${LOGSTASH_VERSION}       \
     --build-arg SCALA_VERSION=${SCALA_VERSION}             \
     --build-arg KAFKA_VERSION=${KAFKA_VERSION}             \
     ${tags} .
docker image prune -f
