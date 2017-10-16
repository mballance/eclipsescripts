

ifneq (1,$(RULES))
#ECLIPSE_VERSION:=4.7
#ECLIPSE_DROP:=R-$(ECLIPSE_VERSION)-201706120950
ECLIPSE_VERSION:=4.6.3
ECLIPSE_DROP:=R-$(ECLIPSE_VERSION)-201703010400
ECLIPSE_URL:=$(ECLIPSE_MIRROR_URL)/eclipse/downloads/drops4/$(ECLIPSE_DROP)
ECLIPSE_LINUX_TGZ:=eclipse-SDK-$(ECLIPSE_VERSION)-linux-gtk.tar.gz
ECLIPSE_LINUX_X86_64_TGZ:=eclipse-SDK-$(ECLIPSE_VERSION)-linux-gtk-x86_64.tar.gz
ECLIPSE_WIN32_ZIP:=eclipse-SDK-$(ECLIPSE_VERSION)-win32.zip
ECLIPSE_WIN32_X86_64_ZIP:=eclipse-SDK-$(ECLIPSE_VERSION)-win32-x86_64.zip

ECLIPSE_PLATFORM_ZIP := org.eclipse.platform-$(ECLIPSE_VERSION).zip
ECLIPSE_PLATFORM_URL := $(ECLIPSE_URL)/$(ECLIPSE_PLATFORM_ZIP)
ECLIPSE_PLATFORM_DIR := $(BUILD_TOOLS_DIR)/eclipse_platform

ifeq (true,$(IS_WIN))
ifeq (x86_64,$(uname_m))
ECLIPSE_SDK_ZIP := $(ECLIPSE_WIN32_X86_64_ZIP)
else
ECLIPSE_SDK_ZIP := $(ECLIPSE_WIN32_ZIP)
endif
else
ifeq (x86_64,$(uname_m))
ECLIPSE_SDK_TGZ := $(ECLIPSE_LINUX_X86_64_TGZ)
else
ECLIPSE_SDK_TGZ := $(ECLIPSE_LINUX_TGZ)
endif
# TODO
endif

ECLIPSE_SDK_DIR := $(BUILD_TOOLS_DIR)/eclipse

ifeq (Cygwin,$(uname_o))
ECLIPSE_SDK_DIR_A = $(shell cygpath -w $(ECLIPSE_SDK_DIR) | sed -e 's%\\\\%/%g')
else
  ifeq (Msys,$(uname_o))
    ECLIPSE_SDK_DIR_A = $(shell echo $(ECLIPSE_SDK_DIR) | sed -e 's%^\([a-zA-Z]\)%\1:%g')
  else
    ECLIPSE_SDK_DIR_A = $(ECLIPSE_SDK_DIR)
  endif
endif

else # Rules

#********************************************************************
#* eclipse_sdk.build
#*
#* Creates an eclipse installation in the current directory
#********************************************************************
eclipse_sdk.build : eclipse_sdk.unpack eclipse_platform.install
	$(Q)if test ! -d eclipse/packages; then mkdir -p eclipse/packages; fi
	$(Q)$(MAKE) -C eclipse/packages -f $(ECLIPSESCRIPTS_MKFILES_DIR)/packages.mk install_pkgs
	$(Q)touch $@
	
ifeq (true,$(IS_WIN))	
eclipse_sdk.unpack : $(PACKAGES_DIR)/$(ECLIPSE_SDK_ZIP)
	$(Q)unzip $^
	$(Q)touch $@
else
eclipse_sdk.unpack : $(PACKAGES_DIR)/$(ECLIPSE_SDK_TGZ)
	$(Q)tar xvzf $^
	$(Q)touch $@
endif
	
eclipse_platform.install : eclipse_platform.unpack
	$(Q)cp eclipse_platform/plugins/*.jar eclipse/plugins
	$(Q)touch $@

eclipse_platform.unpack : $(PACKAGES_DIR)/$(ECLIPSE_PLATFORM_ZIP)
	$(Q)mkdir -p eclipse_platform
	$(Q)cd eclipse_platform ; unzip $^
	$(Q)touch $@
	
$(PACKAGES_DIR)/$(ECLIPSE_PLATFORM_ZIP) :
	$(Q)if test ! -d `dirname $@`; then mkdir -p `dirname $@`; fi
	$(Q)wget -O $@ $(ECLIPSE_PLATFORM_URL)
	
$(PACKAGES_DIR)/$(ECLIPSE_WIN32_ZIP) : 
	$(Q)if test ! -d `dirname $@`; then mkdir -p `dirname $@`; fi
	$(Q)wget -O $@ $(ECLIPSE_URL)/$(ECLIPSE_WIN32_ZIP)
	
$(PACKAGES_DIR)/$(ECLIPSE_WIN32_X86_64_ZIP) : 
	$(Q)if test ! -d `dirname $@`; then mkdir -p `dirname $@`; fi
	$(Q)wget -O $@ $(ECLIPSE_URL)/$(ECLIPSE_WIN32_X86_64_ZIP)

$(PACKAGES_DIR)/$(ECLIPSE_LINUX_TGZ) : 
	$(Q)if test ! -d `dirname $@`; then mkdir -p `dirname $@`; fi
	$(Q)wget -O $@ $(ECLIPSE_URL)/$(ECLIPSE_LINUX_TGZ)
	
$(PACKAGES_DIR)/$(ECLIPSE_LINUX_X86_64_TGZ) : 
	$(Q)if test ! -d `dirname $@`; then mkdir -p `dirname $@`; fi
	$(Q)wget -O $@ $(ECLIPSE_URL)/$(ECLIPSE_LINUX_X86_64_TGZ)

endif
