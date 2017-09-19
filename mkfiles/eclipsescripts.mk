#****************************************************************************
#* eclipsescripts.mk
#****************************************************************************
ifneq (true,$(VERBOSE))
Q=@
endif

ECLIPSESCRIPTS_DIR := $(dir $(lastword $(MAKEFILE_LIST)))
ECLIPSESCRIPTS_DIR := $(shell cd $(ECLIPSESCRIPTS_DIR)/.. ; pwd)

include $(ECLIPSESCRIPTS_DIR)/mkfiles/platformdefs.mk
include $(ECLIPSESCRIPTS_DIR)/mkfiles/eclipsetools.mk

# MK_INCLUDES += $(ECLIPSESCRIPTS_DIR)/mkfiles/packages.mk


include $(MK_INCLUDES)

RULES := 1

$(BUILD_DIR)/tools/eclipse_sdk.build : 
	$(Q)if test ! -d $(BUILD_DIR)/tools; then mkdir -p $(BUILD_DIR)/tools; fi
	$(Q)$(MAKE) -C $(BUILD_DIR)/tools -f $(ECLIPSESCRIPTS_DIR)/mkfiles/packages.mk \
		ECLIPSE_PKGS="$(ECLIPSE_SDK_PKGS)" VERBOSE=$(VERBOSE) \
		PACKAGES_DIR=$(PACKAGES_DIR) BUILD_DIR=$(BUILD_DIR) \
		BUILD_TOOLS_DIR=$(BUILD_TOOLS_DIR) \
		eclipse_sdk.build

all : $(BUILD_DIR)/eclipse_sdk.build
	$(Q)echo "Error: must build a product or feature"
	$(Q)echo "Products: $(ECLIPSE_PRODUCTS)"
	$(Q)echo "Features: $(ECLIPSE_FEATURES)"

include $(MK_INCLUDES)

	
clean :
	$(Q)echo "Removing build directory : $(BUILD_DIR)"
	$(Q)rm -rf $(BUILD_DIR)
	
	