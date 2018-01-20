#!/usr/bin/env bash

IMAGE_VERSION="1.0.2"
COURSIER_VOLUME_NAME="jupyter_scala_coursier"

# create volume COURSIER_VOLUME_NAME if not exists
if [ $(docker volume ls | grep "${COURSIER_VOLUME_NAME}" | wc -l) -eq 0 ]; then
  echo "creating docker volume '${COURSIER_VOLUME_NAME}'"
  docker volume create "${COURSIER_VOLUME_NAME}"
else
  echo "Using docker volume '${COURSIER_VOLUME_NAME}'"
fi

docker run -it --rm -p 8888:8888 \
  -v "$(pwd)":/home/jovyan/work \
  --mount source="${COURSIER_VOLUME_NAME}",target=/home/jovyan/.coursier \
  anskarl/jupyter-scala:${IMAGE_VERSION}