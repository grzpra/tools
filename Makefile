CROSS_COMPILE?=
ARCH?=x86

KDIR=kernel
KDEFCONFIG=allyesconfig
KARCH=$(ARCH)

UDIR=u-boot
UDEFCONFIG=sandbox_defconfig
UARCH=sandbox

KMOD_DIR=kmod

.DEFAULT: help
.PHONY: help all clean purge $(KDIR) $(UDIR) $(KMOD_DIR)

help:
	@echo "Supported targets:"
	@echo " all\t- builds everything"
	@echo " clean\t- cleans everything"
	@echo " purge\t- cleans everything (completly)"
	@echo " $(KDIR)\t- builds kernel"
	@echo " $(UDIR)\t- builds u-boot"
	@echo " $(KMOD_DIR)\t- builds kernel module template"

all: $(KDIR) $(UDIR)
	@$(MAKE) $(KMOD_DIR)

$(KDIR)/.config:
	@$(MAKE) -C $(KDIR) ARCH=$(KARCH) CROSS_COMPILE=$(CROSS_COMPILE) $(KDEFCONFIG)
	@$(MAKE) -C $(KDIR) ARCH=$(KARCH) CROSS_COMPILE=$(CROSS_COMPILE) silentoldconfig

$(KDIR): $(KDIR)/.config
	@$(MAKE) -C $(KDIR) ARCH=$(KARCH) CROSS_COMPILE=$(CROSS_COMPILE) all

$(UDIR)/.config:
	@$(MAKE) -C $(UDIR) ARCH=$(UARCH) CROSS_COMPILE=$(CROSS_COMPILE) $(UDEFCONFIG)
	@$(MAKE) -C $(UDIR) ARCH=$(UARCH) CROSS_COMPILE=$(CROSS_COMPILE) silentoldconfig
	
$(UDIR): $(UDIR)/.config
	@$(MAKE) -C $(UDIR) ARCH=$(UARCH) CROSS_COMPILE=$(CROSS_COMPILE)

$(KMOD_DIR):
	@$(MAKE) -C $(KMOD_DIR) ARCH=$(KARCH) CROSS_COMPILE=$(CROSS_COMPILE) KDIR=$(CURDIR)/$(KDIR) all

clean:
	@$(MAKE) -C $(KMOD_DIR) ARCH=$(KARCH) CROSS_COMPILE=$(CROSS_COMPILE) KDIR=$(CURDIR)/$(KDIR) clean
	@$(MAKE) -C $(KDIR) ARCH=$(KARCH) CROSS_COMPILE=$(CROSS_COMPILE) clean
	@$(MAKE) -C $(UDIR) ARCH=$(UARCH) CROSS_COMPILE=$(CROSS_COMPILE) clean
	
purge:
	@$(MAKE) -C $(KMOD_DIR) ARCH=$(KARCH) CROSS_COMPILE=$(CROSS_COMPILE) KDIR=$(CURDIR)/$(KDIR) clean
	@$(MAKE) -C $(KDIR) ARCH=$(KARCH) CROSS_COMPILE=$(CROSS_COMPILE) mrproper
	@$(MAKE) -C $(UDIR) ARCH=$(UARCH) CROSS_COMPILE=$(CROSS_COMPILE) distclean
