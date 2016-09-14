FROM alpine:latest
MAINTAINER William Huba <william.huba@docurated.com>

ENV VAULT_VERSION 0.6.1

RUN apk update && apk add --no-cache \
    openssl \
    jq \
    curl \
    bash

COPY assets/* /opt/resource/
WORKDIR /opt/resource
