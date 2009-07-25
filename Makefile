mplayer: ffmpeg libass
	script/mplayer-config
	$(MAKE) -C mplayer

mplayer-config:
	script/mplayer-config

ffmpeg-config:
	script/ffmpeg-config

ffmpeg: ffmpeg-config
	$(MAKE) -C ffmpeg_build install

libass-config:
	script/libass-config

libass: libass-config
	$(MAKE) -C libass install

noconfig:
	$(MAKE) -C ffmpeg_build install
	$(MAKE) -C libass install
	$(MAKE) -C mplayer

install:
	$(MAKE) -C mplayer install

.PHONY: mplayer-config mplayer ffmpeg-config ffmpeg libass-config libass noconfig install
