VER ?= $(shell git describe)
PND_MAKE=$(PNDSDK)/../sdk_utils/pnd_make.sh
STRIP=$(PNDSDK)/bin/arm-none-linux-gnueabi-strip

mplayer: libav libpostproc libass libdvdcss libdvdread libdvdnav live libcdio
	script/mplayer-config
	$(MAKE) -C mplayer
	$(MAKE) -C mplayer/DOCS/xml

mplayer-config:
	script/mplayer-config

libav-config:
	script/libav-config

libav: libav-config
	$(MAKE) -C libav_build install

libpostproc-config:
	script/libpostproc-config

libpostproc: libav libpostproc-config
	$(MAKE) -C libpostproc install

libass-config:
	script/libass-config

libass: libass-config
	$(MAKE) -C libass install

libdvdcss-config:
	script/libdvdcss-config

libdvdcss: libdvdcss-config
	$(MAKE) -C libdvdcss install

libdvdread-config:
	script/libdvdread-config

libdvdread: libdvdread-config
	$(MAKE) -C libdvdread install

libdvdnav-config:
	script/libdvdnav-config

libdvdnav: libdvdnav-config
	$(MAKE) -C libdvdnav
	$(MAKE) -C libdvdnav install

libcdio-config:
	script/libcdio-config

libcdio: libcdio-config
	touch libcdio/src/iso-read.1 \
		  libcdio/src/iso-info.1 \
		  libcdio/src/cd-read.1 \
		  libcdio/src/cd-info.1 \
		  libcdio/src/cd-drive.1
	$(MAKE) -C libcdio install

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
	cp build_libs/lib/libdvdcss.so.2.1.0 tmp/lib/libdvdcss.so.2
	cp mplayer/mplayer tmp/bin
	cp build/src/smplayer2 tmp/bin
	$(STRIP) tmp/lib/*
	$(STRIP) tmp/bin/*
	cp mplayer/DOCS/HTML/en/MPlayer.html tmp
	groff -mman -Thtml mplayer/DOCS/man/en/mplayer.1 > tmp/mplayer.1.html
	cp -r pandora/* tmp
	$(PND_MAKE) -p smplayer2_$(VER).pnd -d tmp -x tmp/PXML.xml -i pandora/smplayer.png -c

.PHONY: mplayer-config mplayer libav-config libav libpostproc-config libpostproc libass-config libass libdvdcss-config libdvdcss libdvdread-config libdvdread libdvdnav-config libdvdnav libcdio-config libcdio live noconfig install clean
