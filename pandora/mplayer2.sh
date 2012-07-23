#!/bin/sh

export HOME=$(pwd)
export LD_LIBRARY_PATH=$(pwd)/lib

./bin/mplayer "$@"
