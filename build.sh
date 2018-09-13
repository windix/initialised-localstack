#!/bin/bash

REPO=windix/initialised-localstack
GIT_SHA=`git rev-parse --short HEAD`

docker build -t ${REPO}:latest -t ${REPO}:${GIT_SHA} . && \
docker push ${REPO}:${GIT_SHA} && \
docker push ${REPO}:latest
