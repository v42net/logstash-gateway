#!/bin/bash
docker stack deploy --compose-file compose3.yaml --detach=false logstash-gateway
