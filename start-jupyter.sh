#!/usr/bin/env bash

IMAGE_VERSION="1.0.0"

docker run -ti --rm -p 8888:8888 \
  -v "$(pwd)":/home/jovyan/work \
  anskarl/jupyter-scala:${IMAGE_VERSION}
