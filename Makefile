VER ?= $(shell git describe)
PND_MAKE=$(HOME)/pandora-dev/sdk_utils/pnd_make.sh
STRIP=$(HOME)/pandora-dev/arm-2011.03/bin/arm-none-linux-gnueabi-strip

mplayer: libav libass libdvdread libdvdnav live
	script/mplayer-config
	$(MAKE) -C mplayer
	$(MAKE) -C mplayer/DOCS/xml

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

live:
	cp config.pandora live
	cd live && ./genMakefiles pandora
	$(MAKE) -C live
	mkdir -p build_libs/include
	mkdir -p build_libs/lib
	find live -name '*.hh' | xargs -I {} install {} build_libs/include
	find live -name '*.h' | xargs -I {} install {} build_libs/include
	find live -name '*.a' | xargs -I {} install {} build_libs/lib

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

pnd:
	rm -rf tmp
	mkdir -p tmp/lib
	mkdir -p tmp/bin
	cp build_libs/lib/libdvdnavmini.so.4 tmp/lib
	cp build_libs/lib/libdvdnav.so.4 tmp/lib
	cp build_libs/lib/libdvdread.so.4 tmp/lib
	cp mplayer/mplayer tmp/bin
	cp build/src/smplayer2 tmp/bin
	$(STRIP) tmp/lib/*
	$(STRIP) tmp/bin/*
	cp mplayer/DOCS/HTML/en/MPlayer.html tmp
	groff -mman -Thtml mplayer/DOCS/man/en/mplayer.1 > tmp/mplayer.1.html
	cp -r pandora/* tmp
	$(PND_MAKE) -p smplayer2_$(VER).pnd -d tmp -x tmp/PXML.xml -i pandora/smplayer.png -c

.PHONY: mplayer-config mplayer libav-config libav libass-config libass libdvdread-config libdvdread libdvdnav-config libdvdnav live noconfig install clean
