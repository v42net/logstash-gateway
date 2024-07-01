#!/bin/bash
set -e

echo "Creating docker logstash-gateway config ..."
if docker config inspect logstash-gateway >/dev/null 2>/dev/null; then
    docker config rm logstash-gateway
fi
docker config create logstash-gateway gateway.cfg

echo "Creating docker logstash-gateway secret ..."
if docker secret inspect logstash-gateway >/dev/null 2>/dev/null; then
    docker secret rm logstash-gateway
fi
docker secret create logstash-gateway secrets.cfg
