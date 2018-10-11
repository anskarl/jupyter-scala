#!/usr/bin/env bash

IMAGE_VERSION="2.0.0"
CACHE_VOLUME_NAME="jupyter_scala_cache"

# create volume CACHE_VOLUME_NAME if not exists
if [ $(docker volume ls | grep "${CACHE_VOLUME_NAME}" | wc -l) -eq 0 ]; then
  echo "creating docker volume '${CACHE_VOLUME_NAME}'"
  docker volume create "${CACHE_VOLUME_NAME}"
else
  echo "Using docker volume '${CACHE_VOLUME_NAME}'"
fi

docker run -it --rm -p 8888:8888 \
  -v "$(pwd)":/home/jovyan/work \
  --mount source="${CACHE_VOLUME_NAME}",target=/home/jovyan/.cache \
  anskarl/jupyter-scala:${IMAGE_VERSION}
