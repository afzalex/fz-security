#!/bin/bash

DOCKER_IMAGE_NAME="${1:-fzsecurity}"

rm -rf .build
git clone --branch main --single-branch --depth 1 "file://$(pwd)" .build
rm -rf .build/.git

docker image rm -f "${DOCKER_IMAGE_NAME}"
docker container rm -f "${DOCKER_IMAGE_NAME}"
docker build --tag "${DOCKER_IMAGE_NAME}" .