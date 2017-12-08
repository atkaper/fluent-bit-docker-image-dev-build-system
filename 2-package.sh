#!/bin/bash

echo "--- Build fluent-bit docker image ---"
docker build -f Dockerfile-fluent-bit -t local/fluent-bit .
if [ "$?" != "0" ]; then echo ERROR; exit 1; fi

