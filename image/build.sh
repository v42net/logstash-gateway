#!/bin/bash
set -e
echo "------------------------------------------------------------------"
echo "RUN image/build.sh"
echo "------------------------------------------------------------------"

apt-get -y update 
apt-get -y upgrade 
apt-get -f -y install git iputils-ping net-tools procps xz-utils 
apt-get --purge autoremove 
apt-get clean

tar -C / -Jxpf /tmp/s6-overlay-noarch.tar.xz
tar -C / -Jxpf /tmp/s6-overlay-x86_64.tar.xz

tar -C /opt -xpf /tmp/logstash-${LOGSTASH_VERSION}-linux-x86_64.tar.gz
mv /opt/logstash-${LOGSTASH_VERSION} /opt/logstash

tar -C /opt -xpf /tmp/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz
mv /opt/kafka_${SCALA_VERSION}-${KAFKA_VERSION} /opt/kafka

echo "------------------------------------------------------------------"
echo "DONE image/build.sh"
echo "------------------------------------------------------------------"
rm -rf /build* /tmp/*