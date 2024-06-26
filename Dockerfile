ARG DEBIAN_VERSION
FROM debian:${DEBIAN_VERSION}-slim

ARG S6_OVERLAY_VERSION
ADD https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-noarch.tar.xz /tmp
ADD https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-x86_64.tar.xz /tmp

ARG LOGSTASH_VERSION
ADD https://artifacts.elastic.co/downloads/logstash/logstash-${LOGSTASH_VERSION}-linux-x86_64.tar.gz /tmp

ARG SCALA_VERSION
ARG KAFKA_VERSION
ADD https://downloads.apache.org/kafka/${KAFKA_VERSION}/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz /tmp

COPY image /
COPY versions /etc
RUN /build.sh

ENTRYPOINT ["/init"]
