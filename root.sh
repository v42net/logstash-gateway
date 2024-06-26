#!/bin/bash
set -e
cd $(dirname $0)
source ./versions
repo=$(git config --get remote.origin.url)
branch=$(git rev-parse --abbrev-ref HEAD)
name=$(basename ${repo%.*})
repo=$(basename $(dirname ${repo}))/${name}
docker run -it --rm -h ${name} --name ${name} ${repo}:${branch} /bin/bash
