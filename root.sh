#!/bin/bash
set -e
cd $(dirname $0)
source ./versions
repo=$(git config --get remote.origin.url)
branch=$(git rev-parse --abbrev-ref HEAD)
name=$(basename ${repo%.*})
repo=$(basename $(dirname ${repo}))/${name}

names="-h ${name} --name ${name}"
config="-v ./config.cfg:/config.cfg"
secrets="-v ./secrets.cfg:/run/secrets/secrets.cfg"
data="-v /shared/logstash-gateway-node:/data"
image="${repo}:${branch}"

docker run -it --rm ${names} ${config} ${secrets} ${data} ${image} /bin/bash
