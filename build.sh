#!/usr/bin/env bash

IMAGE_VERSION="1.0.3"

TAG=anskarl/jupyter-scala:${IMAGE_VERSION}

if [ "$1" == "clean" ]; then
    docker rmi -f ${TAG}
fi

docker build -t ${TAG} "$(dirname $0)" 

