CROSS_COMPILE?=
ARCH?=x86

KDIR=kernel
KTARGET=kbuild
KGIT=git://github.com/torvalds/linux.git
KDEFCONFIG=allyesconfig
KARCH=$(ARCH)

UDIR=uboot
UTARGET=ubuild
UGIT=git://git.denx.de/u-boot.git
UDEFCONFIG=sandbox_defconfig
UARCH=sandbox

KMOD_DIR=kmod

.DEFAULT: help
.PHONY: help all clean purge $(KTARGET) $(UTARGET) $(KMOD_DIR)

help:
	@echo "Supported targets:"
	@echo " all\t- builds everything"
	@echo " clean\t- cleans everything"
	@echo " purge\t- cleans everything (completly)"
	@echo " remove\t- deletes $(UDIR) and $(KDIR)"
	@echo " $(KDIR)\t- gets kernel source"
	@echo " $(UDIR)\t- gets u-boot source"
	@echo " $(KTARGET)\t- builds kernel"
	@echo " $(UTARGET)\t- builds U-Boot"
	@echo " $(KMOD_DIR)\t- builds kernel module template"

all: $(KTARGET) $(UTARGET)
	@$(MAKE) $(KMOD_DIR)

$(KTARGET): $(KDIR)/.config
	@$(MAKE) -C $(KDIR) ARCH=$(KARCH) CROSS_COMPILE=$(CROSS_COMPILE) all

$(KDIR)/.config: $(KDIR)
	@$(MAKE) -C $(KDIR) ARCH=$(KARCH) CROSS_COMPILE=$(CROSS_COMPILE) $(KDEFCONFIG)
	@$(MAKE) -C $(KDIR) ARCH=$(KARCH) CROSS_COMPILE=$(CROSS_COMPILE) silentoldconfig

$(KDIR):
	@git clone $(KGIT) -b master $(KDIR)

$(UTARGET): $(UDIR)/.config
	@$(MAKE) -C $(UDIR) ARCH=$(UARCH) CROSS_COMPILE=$(CROSS_COMPILE)

$(UDIR)/.config: $(UDIR)
	@$(MAKE) -C $(UDIR) ARCH=$(UARCH) CROSS_COMPILE=$(CROSS_COMPILE) $(UDEFCONFIG)
	@$(MAKE) -C $(UDIR) ARCH=$(UARCH) CROSS_COMPILE=$(CROSS_COMPILE) silentoldconfig
	
$(UDIR):
	@git clone $(UGIT) -b master $(UDIR)

$(KMOD_DIR): $(KTARGET)
	@$(MAKE) -C $(KMOD_DIR) ARCH=$(KARCH) CROSS_COMPILE=$(CROSS_COMPILE) KDIR=$(CURDIR)/$(KDIR) all

clean: $(KDIR) $(UDIR)
	@$(MAKE) -C $(KMOD_DIR) ARCH=$(KARCH) CROSS_COMPILE=$(CROSS_COMPILE) KDIR=$(CURDIR)/$(KDIR) clean
	@$(MAKE) -C $(KDIR) ARCH=$(KARCH) CROSS_COMPILE=$(CROSS_COMPILE) clean
	@$(MAKE) -C $(UDIR) ARCH=$(UARCH) CROSS_COMPILE=$(CROSS_COMPILE) clean
	
purge: $(KDIR) $(UDIR)
	@$(MAKE) -C $(KMOD_DIR) ARCH=$(KARCH) CROSS_COMPILE=$(CROSS_COMPILE) KDIR=$(CURDIR)/$(KDIR) clean
	@$(MAKE) -C $(KDIR) ARCH=$(KARCH) CROSS_COMPILE=$(CROSS_COMPILE) mrproper
	@$(MAKE) -C $(UDIR) ARCH=$(UARCH) CROSS_COMPILE=$(CROSS_COMPILE) distclean

remove:
	@echo "  [RM] Removing $(KDIR)..."
	@rm -rf $(CURDIR)/$(KDIR)
	@echo "  [RM] Removing $(UDIR)..."
	@rm -rf $(CURDIR)/$(UDIR)
