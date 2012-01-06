mplayer: libav libass libdvdread libdvdnav
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

libdvdread-config:
	script/libdvdread-config

libdvdread: libdvdread-config
	$(MAKE) -C libdvdread install

libdvdnav-config:
	script/libdvdnav-config

libdvdnav: libdvdnav-config
	$(MAKE) -C libdvdnav
	$(MAKE) -C libdvdnav install

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
	-$(MAKE) -C libdvdread distclean
	-$(MAKE) -C libdvdnav distclean

.PHONY: mplayer-config mplayer libav-config libav libass-config libass libdvdread-config libdvdread libdvdnav-config libdvdnav noconfig install clean
