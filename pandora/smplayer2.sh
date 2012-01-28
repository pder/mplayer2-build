#!/bin/sh

export HOME=$(pwd)
export LD_LIBRARY_PATH=$(pwd)/lib

# copy over a default preferences file
mkdir -p smplayer2
cp -n smplayer2.ini.default ./smplayer2/smplayer2.ini

./bin/smplayer2 "$@"
