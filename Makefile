#TOOLCHAIN_URL=http://dn.odroid.com/toolchains/gcc-linaro-arm-none-eabi-4.8-2014.04_linux.tar.xz
UBOOT_BUILD?=$(TOPLEVEL)/build/u-boot
KERNEL_BUILD?=$(TOPLEVEL)/build/linux

all: kernel uboot

#toolchain:
#	mkdir -p toolchain
#	cd toolchain && wget $(TOOLCHAIN_URL)
#	cd $(TOPDIR)/toolchain && tar xJvf gcc-linaro-arm-none-eabi-4.8-2014.04_linux.tar.xz

linux:
	git clone --depth 1 https://github.com/hardkernel/linux.git -b odroidc-3.10.y-android

kernel: linux
	cd linux && make odroidc_defconfig
	make -C linux uImage -j 5
	make -C linux modules modules_install


### UBOOT ##

u-boot:
	git clone https://github.com/hardkernel/u-boot.git -b odroidc-v2011.03

uboot: u-boot linux
	make -C $(UBOOT_SRC) odroidc_config
	make -C $(UBOOT_SRC) -j 5
	make -C u-boot tools
# fixup hardkernel crap
	cp u-boot/build/tools/mkimage linux/arch/arm/boot/mkimage
	echo "cd sd_fuse && ./sd_fusing.sh <device/path/of/your/card>"

clean:
	make -C u-boot clean
	make -C linux mrproper

