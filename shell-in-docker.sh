#!/bin/bash

./build-in-docker.sh
docker run -it verify-metadata-generator /bin/sh
