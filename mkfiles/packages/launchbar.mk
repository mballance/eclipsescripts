

ifneq (1,$(RULES))
LAUNCHBAR_DIR_LEAF=tools/cdt/launchbar/oxygen.2/launchbar-2.2.0
LAUNCHBAR_URL=$(ECLIPSE_MIRROR_URL)/$(LAUNCHBAR_DIR_LEAF)

LAUNCHBAR_DIR=$(BUILD_TOOLS_DIR)/launchbar
LAUNCHBAR_ZIP=org.eclipse.launchbar.zip
LAUNCHBAR_FEATURES:=org.eclipse.launchbar.feature.group
LAUNCHBAR_REPOS=$(call ECLIPSE_REPOSITORY_URL,$(LAUNCHBAR_DIR)),$(call ECLIPSE_REPOSITORY_URL,$(ECLIPSE_PLATFORM_DIR))

else

#********************************************************************
#* eclipse_sdk.build
#*
#* Creates an eclipse installation in the current directory
#********************************************************************
	
$(BUILD_TOOLS_DIR)/launchbar.unpack : $(PACKAGES_DIR)/$(LAUNCHBAR_ZIP)
	$(Q)rm -rf $(LAUNCHBAR_DIR)
	$(Q)mkdir -p $(LAUNCHBAR_DIR)
	$(Q)cd $(LAUNCHBAR_DIR) ; $(UNZIP) $^
	$(Q)touch $@

$(PACKAGES_DIR)/$(LAUNCHBAR_ZIP) :
	$(Q)if test ! -d `dirname $@`; then mkdir -p `dirname $@`; fi
	$(Q)rm -rf $(LAUNCHBAR_DIR)
	$(Q)mkdir -p $(LAUNCHBAR_DIR)
	$(Q)cd $(LAUNCHBAR_DIR) ; \
		wget -nH -r --no-parent $(LAUNCHBAR_URL)
	$(Q)cd $(LAUNCHBAR_DIR)/pub/eclipse/$(LAUNCHBAR_DIR_LEAF) ; \
		zip -r $@ *
	$(Q)rm -rf $(LAUNCHBAR_DIR)
	
launchbar.install : \
	$(BUILD_TOOLS_DIR)/launchbar.unpack \
	$(BUILD_TOOLS_DIR)/eclipse_platform.unpack 
	$(Q)$(call ECLIPSE_INSTALL_IU, $(LAUNCHBAR_FEATURES), $(LAUNCHBAR_REPOS), \
		Launchbar, $(PARENT_DIR_A))
	$(Q)touch $@

	
endif
