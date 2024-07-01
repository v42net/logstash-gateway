#!/bin/bash
origin=$(git config --get remote.origin.url)
branch=$(git rev-parse --abbrev-ref HEAD)
name=$(basename ${origin%.*})
repo=$(basename $(dirname ${origin}))/${name}
docker push -a ${repo}