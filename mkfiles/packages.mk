#****************************************************************************
#* packages.mk
#****************************************************************************

ifeq (,$(ECLIPSE_MIRROR_URL))
ECLIPSE_MIRROR_URL:=ftp://ftp.osuosl.org/pub/eclipse
endif

ECLIPSESCRIPTS_MKFILES_DIR := $(dir $(lastword $(MAKEFILE_LIST)))
include $(ECLIPSESCRIPTS_MKFILES_DIR)/eclipsetools.mk

ECLIPSE_VERSION:=4.6.3
ECLIPSE_DROP:=R-$(ECLIPSE_VERSION)-201703010400
ECLIPSE_URL:=$(ECLIPSE_MIRROR_URL)/eclipse/downloads/drops4/$(ECLIPSE_DROP)
ECLIPSE_LINUX_TGZ:=eclipse-SDK-$(ECLIPSE_VERSION)-linux-gtk.tar.gz
ECLIPSE_LINUX_X86_64_TGZ:=eclipse-SDK-$(ECLIPSE_VERSION)-linux-gtk-x86_64.tar.gz
ECLIPSE_WIN32_ZIP:=eclipse-SDK-$(ECLIPSE_VERSION)-win32.zip
ECLIPSE_WIN32_X86_64_ZIP:=eclipse-SDK-$(ECLIPSE_VERSION)-win32-x86_64.zip


ifeq (true,$(IS_WIN))
ifeq (x86_64,$(uname_m))
ECLIPSE_SDK_ZIP := $(ECLIPSE_WIN32_X86_64_ZIP)
else
ECLIPSE_SDK_ZIP := $(ECLIPSE_WIN32_ZIP)
endif
else
# TODO
endif

ECLIPSESCRIPTS_PKGS_DIRS += $(ECLIPSESCRIPTS_MKFILES_DIR)/packages
include $(foreach dir,$(ECLIPSESCRIPTS_PKGS_DIRS),$(wildcard $(dir)/*.mk))

ECLIPSE_SDK_DIR := $(BUILD_TOOLS_DIR)/eclipse

ifeq (Cygwin,$(uname_o))
ECLIPSE_SDK_DIR_A = $(shell cygpath -w $(ECLIPSE_SDK_DIR) | sed -e 's%\\\\%/%g')
else
ECLIPSE_SDK_DIR_A = $(ECLIPSE_SDK_DIR)
endif

RULES := 1

#********************************************************************
#* eclipse_sdk.build
#*
#* Creates an eclipse installation in the current directory
#********************************************************************
eclipse_sdk.build : eclipse_sdk.unpack
	$(Q)if test ! -d eclipse/packages; then mkdir -p eclipse/packages; fi
	$(Q)$(MAKE) -C eclipse/packages -f $(ECLIPSESCRIPTS_MKFILES_DIR)/packages.mk install_pkgs
	$(Q)touch $@

install_pkgs : $(foreach pkg,$(ECLIPSE_PKGS),$(pkg).install)
#	$(Q)echo "build: $(ECLIPSE_SDK_PKGS)"
#	$(Q)touch $@

ifeq (true,$(IS_WIN))	
eclipse_sdk.unpack : $(PACKAGES_DIR)/$(ECLIPSE_SDK_ZIP)
	$(Q)unzip $^
	$(Q)touch $@
else
endif

$(PACKAGES_DIR)/$(ECLIPSE_WIN32_ZIP) : 
	$(Q)if test ! -d `dirname $@`; then mkdir -p `dirname $@`; fi
	$(Q)wget -O $@ $(ECLIPSE_URL)/$(ECLIPSE_WIN32_ZIP)
	
$(PACKAGES_DIR)/$(ECLIPSE_WIN32_X86_64_ZIP) : 
	$(Q)if test ! -d `dirname $@`; then mkdir -p `dirname $@`; fi
	$(Q)wget -O $@ $(ECLIPSE_URL)/$(ECLIPSE_WIN32_X86_64_ZIP)
	
include $(foreach dir,$(ECLIPSESCRIPTS_PKGS_DIRS),$(wildcard $(dir)/*.mk))

	