#!/bin/sh

# This script will be run INSIDE the docker compiler container, do not run it outside of docker...
# It get's the sources, and executes the compile.
# As you will be using a volume mapping to /src, a second or more execution of this will
# re-use everything which is already build, and just rebuild the needed parts to keep it FAST.

# Get the settings (repo and volume mapping)
. /settings.conf

# If /src/fluent-bit does not exist, then clone the repository ONCE
cd /src
if ! test -d fluent-bit
then
   echo "--------------------------------------------------------------------------------------------"
   echo "CLONING Repository $GIT_REPO, branch $GIT_BRANCH"
   echo "--------------------------------------------------------------------------------------------"
   git clone $GIT_REPO
   if [ "$?" != "0" ]; then echo ERROR; exit 1; fi
   cd fluent-bit
   git checkout $GIT_BRANCH
   if [ "$?" != "0" ]; then echo ERROR; exit 1; fi
fi

# Only PULL if we are using a docker-volume.
if test -z "$BUILD_VOLUME" 
then
   echo "--------------------------------------------------------------------------------------------"
   echo "PULLing git repo to get fresh files"
   echo "--------------------------------------------------------------------------------------------"
   cd /src/fluent-bit
   git pull
   if [ "$?" != "0" ]; then echo ERROR; exit 1; fi
else
   echo "--------------------------------------------------------------------------------------------"
   echo "No GIT PULL done! Keep in mind to run that from your host in folder $BUILD_VOLUME"
   echo "--------------------------------------------------------------------------------------------"
fi

echo "--------------------------------------------------------------------------------------------"
echo "`date` Starting MAKE (compile)"
echo "--------------------------------------------------------------------------------------------"

cd /src/fluent-bit/build
cmake -DFLB_DEBUG=On -DFLB_TRACE=On -DFLB_JEMALLOC=On -DFLB_BUFFERING=On ../
if [ "$?" != "0" ]; then echo ERROR; exit 1; fi
make
if [ "$?" != "0" ]; then echo ERROR; exit 1; fi

echo "--------------------------------------------------------------------------------------------"
echo "`date` MAKE (compile) ready"
echo "--------------------------------------------------------------------------------------------"

