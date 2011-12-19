#!/bin/bash

export PNDSDK=$HOME/pandora-dev/arm-2011.03
export PATH=$PNDSDK/bin:$PNDSDK/usr/bin:$PATH
export LIBTOOL_SYSROOT_PATH=$PNDSDK
export PKG_CONFIG_PATH=$PNDSDK/usr/lib/pkgconfig
export PKG_CONFIG=$PNDSDK/bin/arm-none-linux-gnueabi-pkg-config
