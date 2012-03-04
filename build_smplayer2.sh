#!/bin/bash

export PATH=$PNDSDK/usr/bin:$PATH 
export CFLAGS="-DPANDORA -O2 -pipe -march=armv7-a -mcpu=cortex-a8 -mtune=cortex-a8 -mfpu=neon -ftree-vectorize -mfloat-abi=softfp -ffast-math -fsingle-precision-constant -fno-inline-functions" 
export CXXFLAGS="-DPANDORA -O2 -pipe -march=armv7-a -mcpu=cortex-a8 -mtune=cortex-a8 -mfpu=neon -ftree-vectorize -mfloat-abi=softfp -ffast-math -fsingle-precision-constant -fno-inline-functions" 

cd quazip-0.4.4
qmake -spec $PNDSDK/../sdk_utils/qmake_linux-pandora-g++ 
make sub-quazip
make -C quazip staticlib
cd ..

# Apply patch to SMPlayer2 CMakefiles.txt to use local quazip build
git apply --directory=SMPlayer2 patches/smplayer2-quazip-build.patch

# copy zlib headers into SMPlayer2/src directory to work around build problems caused by adding $PNDSDK/usr/include to include path
cp $PNDSDK/usr/include/zlib.h SMPlayer2/src
cp $PNDSDK/usr/include/zconf.h SMPlayer2/src

mkdir -p build
cd build
cmake -DCMAKE_BUILD_TYPE=release \
      -DCMAKE_TOOLCHAIN_FILE=$PNDSDK/../sdk_utils/PandoraToolchain.cmake \
      -DQUAZIP_INCLUDE_DIR=../quazip-0.4.4 \
      -DQUAZIP_LIBRARY=../quazip-0.4.4/quazip/libquazip.a \
      ../SMPlayer2
make
