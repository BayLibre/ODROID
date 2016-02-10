#TOOLCHAIN_URL=http://dn.odroid.com/toolchains/gcc-linaro-arm-none-eabi-4.8-2014.04_linux.tar.xz
UBOOT_BUILD?=$(TOPLEVEL)/build/u-boot
KERNEL_BUILD?=$(TOPLEVEL)/build/linux

all: linux

#toolchain:
#	mkdir -p $(TOPDIR)/toolchain
#	cd $(TOPDIR)/toolchain && wget $(TOOLCHAIN_URL)
#	cd $(TOPDIR)/toolchain && tar xJvf gcc-linaro-arm-none-eabi-4.8-2014.04_linux.tar.xz
linux:	$(KERNEL_BUILD)/.config
	make -C $(KERNEL_BUILD) LOADADDR=0x00208000 uImage dtbs

$(KERNEL_BUILD)/.config:
	mkdir -p $(KERNEL_BUILD)
	make -C $(KERNEL_SRC) multi_v7_defconfig O=$(KERNEL_BUILD)

uboot:
	mkdir -p $(UBOOT_BUILD)
	make -C $(UBOOT_SRC) odroidc_config O=$(UBOOT_BUILD)
	make -C $(UBOOT_BUILD) -j 5

clean:

