TOOLCHAIN_URL=http://dn.odroid.com/toolchains/gcc-linaro-arm-none-eabi-4.8-2014.04_linux.tar.xz

all: uboot toolchain

toolchain:
	mkdir -p $(TOPDIR)/toolchain
	cd $(TOPDIR)/toolchain && wget $(TOOLCHAIN_URL)
	cd $(TOPDIR)/toolchain && tar xJvf gcc-linaro-arm-none-eabi-4.8-2014.04_linux.tar.xz

uboot:
	make -C u-boot odroidc_config
	make -C u-boot -j 5

clean:

