#!/bin/bash

# Read git config, and volume config
. ./settings.conf

if [ "$BUILD_VOLUME" == "" ]
then
   echo "--- Create docker volume fluent-bit-src-volume if not exists ---"
   BUILD_VOLUME=fluent-bit-src-volume
   docker volume create $BUILD_VOLUME
else
   echo "--- Try using HOST volume $BUILD_VOLUME for build ---"
fi

echo "--- (Re-)Create compiler container ---"
docker build -f Dockerfile-compiler -t local/fluent-bit-compiler .
if [ "$?" != "0" ]; then echo ERROR; exit 1; fi

echo "--- RUN compiler (with one-time initial clone) ---"
docker run -ti  --name fluent-bit-compiler -v $BUILD_VOLUME:/src local/fluent-bit-compiler
if [ "$?" != "0" ]; then echo ERROR; docker rm fluent-bit-compiler ; exit 1; fi

mkdir -p ./target
if [ "$BUILD_VOLUME" == "fluent-bit-src-volume" ]
then
   echo "--- Copy result from docker build volume to target folder ---"
   docker cp fluent-bit-compiler:/src/fluent-bit/build/bin/fluent-bit ./target/fluent-bit
   if [ "$?" != "0" ]; then echo ERROR; docker rm fluent-bit-compiler ; exit 1; fi
else
   echo "--- Copy result from host source build volume to target folder ---"
   cp -a $BUILD_VOLUME/fluent-bit/build/bin/fluent-bit ./target/fluent-bit
   if [ "$?" != "0" ]; then echo ERROR; docker rm fluent-bit-compiler ; exit 1; fi
fi

# Remove compiler docker entry (not the image)
docker rm fluent-bit-compiler
if [ "$?" != "0" ]; then echo ERROR; exit 1; fi

echo "--- READY ---"

