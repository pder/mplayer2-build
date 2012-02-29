#!/bin/bash

export PATH=$PNDSDK/usr/bin:$PATH 
export CFLAGS="-DPANDORA -O2 -pipe -march=armv7-a -mcpu=cortex-a8 -mtune=cortex-a8 -mfpu=neon -ftree-vectorize -mfloat-abi=soft -ffast-math -fsingle-precision-constant -fno-inline-functions" 
export CXXFLAGS="-DPANDORA -O2 -pipe -march=armv7-a -mcpu=cortex-a8 -mtune=cortex-a8 -mfpu=neon -ftree-vectorize -mfloat-abi=soft -ffast-math -fsingle-precision-constant -fno-inline-functions" 

mkdir -p build
cd build
cmake -DCMAKE_BUILD_TYPE=release -DENABLE_STRICT_COMPILATION=off -DCMAKE_TOOLCHAIN_FILE=$PNDSDK/../sdk_utils/PandoraToolchain.cmake -DPKG_CONFIG_EXECUTABLE=$PNDSDK/arm-none-linux-gnueabi-pkg-config -DSDL_CONFIG=$PNDSDK/usr/bin/sdl-config -DLUA_MATH_LIBRARY=$PNDSDK/arm-none-linux-gnueabi/libc/usr/lib/libm.so ../SMPlayer2
make
