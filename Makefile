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

images: linux
	mkdir -p $(TFTP_DIR)
	cp $(KERNEL_BUILD)/arch/arm/boot/dts/meson8b-odroidc1.dtb $(TFTP_DIR)
	cp $(KERNEL_BUILD)/arch/arm/boot/*Image $(TFTP_DIR)

.initramfs:
	wget http://images.validation.linaro.org/functional-test-images/common/linaro-image-minimal-initramfs-genericarmv7a.cpio.gz.u-boot
	mv linaro-image-minimal-initramfs-genericarmv7a.cpio.gz.u-boot $(TFTP_DIR)/initramfs.cpio.gz.u-boot
	touch .initramfs

$(KERNEL_BUILD)/.config:
	mkdir -p $(KERNEL_BUILD)
	make -C $(KERNEL_SRC) multi_v7_defconfig O=$(KERNEL_BUILD)

uenv:
	echo "dhcp" > uenv.tmpl

uboot:
	mkdir -p $(UBOOT_BUILD)
	make -C $(UBOOT_SRC) odroidc_config O=$(UBOOT_BUILD)
	make -C $(UBOOT_BUILD) -j 5

clean:

