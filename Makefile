mplayer: libav libass
	script/mplayer-config
	$(MAKE) -C mplayer

mplayer-config:
	script/mplayer-config

libav-config:
	script/libav-config

libav: libav-config
	$(MAKE) -C libav_build install

libass-config:
	script/libass-config

libass: libass-config
	$(MAKE) -C libass install

noconfig:
	$(MAKE) -C libav_build install
	$(MAKE) -C libass install
	$(MAKE) -C mplayer

install:
	$(MAKE) -C mplayer install

clean:
	-rm -rf libav_build
	-$(MAKE) -C libass distclean
	-$(MAKE) -C mplayer distclean

.PHONY: mplayer-config mplayer libav-config libav libass-config libass noconfig install clean
