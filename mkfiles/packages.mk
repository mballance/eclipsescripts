#****************************************************************************
#* packages.mk
#****************************************************************************

ifeq (,$(ECLIPSE_MIRROR_URL))
ECLIPSE_MIRROR_URL:=ftp://ftp.osuosl.org/pub/eclipse
endif

ECLIPSESCRIPTS_MKFILES_DIR := $(dir $(lastword $(MAKEFILE_LIST)))
include $(ECLIPSESCRIPTS_MKFILES_DIR)/eclipsetools.mk

ECLIPSESCRIPTS_PKGS_DIRS += $(ECLIPSESCRIPTS_MKFILES_DIR)/packages


ECLIPSESCRIPTS_PKGS_FILES := $(foreach dir,$(ECLIPSESCRIPTS_PKGS_DIRS),$(wildcard $(dir)/*.mk))
include $(ECLIPSESCRIPTS_PKGS_FILES)

RULES := 1

# 
install_pkgs : install-pre $(foreach pkg,$(ECLIPSE_PKGS),$(pkg).install)
	$(Q)touch $@

$(foreach pkg,$(ECLIPSE_PKGS),$(pkg).install) : install-pre

install-pre : 
	echo "ECLIPSESCRIPTS_PKGS_DIRS: $(ECLIPSESCRIPTS_PKGS_DIRS)"
	echo "ECLIPSESCRIPTS_PKGS_FILES: $(ECLIPSESCRIPTS_PKGS_FILES)"

	
include $(ECLIPSESCRIPTS_PKGS_FILES)

	