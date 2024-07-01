#!/bin/bash
docker stack deploy --compose-file compose1.yaml --detach=false logstash-gateway
