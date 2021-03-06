
ifneq (1,$(RULES))

GEF4_VERSION := 5.0.100
GEF4_URL := $(ECLIPSE_MIRROR_URL)/tools/gef/downloads/drops/$(GEF4_VERSION)/R201805280201
GEF4_ZIP := GEF4-Update-5.0.100.zip
GEF4_DIR := $(BUILD_TOOLS_DIR)/gef4

GEF_VERSION := 4.0.0
GEF_URL := $(ECLIPSE_MIRROR_URL)/tools/gef/downloads/drops/legacy/$(GEF_VERSION)/R201606061308
GEF_ZIP := GEF3-Update-$(GEF_VERSION).zip
GEF_DIR := $(BUILD_TOOLS_DIR)/gef

else

$(PACKAGES_DIR)/$(GEF4_ZIP) :
	$(Q)if test ! -d `dirname $@`; then mkdir -p `dirname $@`; fi
	$(Q)wget -O $@ $(GEF4_URL)/$(GEF4_ZIP)

$(BUILD_TOOLS_DIR)/gef4.unpack : $(PACKAGES_DIR)/$(GEF4_ZIP)
	$(Q)if test ! -d `dirname $@`; then mkdir -p `dirname $@`; fi
	$(Q)rm -rf $(GEF4_DIR)
	$(Q)mkdir -p $(GEF4_DIR)
	$(Q)cd $(GEF4_DIR) ; $(UNZIP) $^
	$(Q)touch $@
	
GEF4_FEATURES:=org.eclipse.gef4.mvc.sdk.feature.group
	
gef4.install : $(BUILD_TOOLS_DIR)/gef4.unpack
	$(Q)$(call ECLIPSE_INSTALL_IU,  $(GEF4_FEATURES), \
			$(call ECLIPSE_REPOSITORY_URL,$(GEF4_DIR)), \
			Gef4, $(PARENT_DIR_A))
	$(Q)touch $@

$(PACKAGES_DIR)/$(GEF_ZIP) :
	$(Q)if test ! -d `dirname $@`; then mkdir -p `dirname $@`; fi
	$(Q)wget -O $@ $(GEF_URL)/$(GEF_ZIP)

$(BUILD_TOOLS_DIR)/gef.unpack : $(PACKAGES_DIR)/$(GEF_ZIP)
	$(Q)if test ! -d `dirname $@`; then mkdir -p `dirname $@`; fi
	$(Q)rm -rf $(GEF_DIR)
	$(Q)mkdir -p $(GEF_DIR)
	$(Q)cd $(GEF_DIR) ; $(UNZIP) $^
	$(Q)touch $@
	
GEF_FEATURES:=org.eclipse.gef.feature.group,org.eclipse.draw2d.feature.group,org.eclipse.zest.feature.group
GEF_REPOS=$(call ECLIPSE_REPOSITORY_URL,$(GEF_DIR)),$(call ECLIPSE_REPOSITORY_URL,$(ECLIPSE_PLATFORM_DIR))
	
gef.install : $(BUILD_TOOLS_DIR)/gef.unpack
	$(Q)$(call ECLIPSE_INSTALL_IU,  $(GEF_FEATURES), $(GEF_REPOS), \
			GEF, $(PARENT_DIR_A))
	$(Q)touch $@	
	
endif
