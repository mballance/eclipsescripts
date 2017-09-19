

ifneq (1,$(RULES))
ECLIPSE_LAUNCHBAR_URL:=http://download.eclipse.org/releases/neon
LAUNCHBAR_URL=https://hudson.eclipse.org/cdt/job/launchbar-master/lastSuccessfulBuild/artifact/repo/target/repository/*zip*/repository.zip

LAUNCHBAR_DIR=$(BUILD_TOOLS_DIR)/launchbar
LAUNCHBAR_ZIP=org.eclipse.launchbar.zip
LAUNCHBAR_FEATURES:=org.eclipse.launchbar.feature.group
LAUNCHBAR_REPOS=$(call ECLIPSE_REPOSITORY_URL,$(LAUNCHBAR_DIR)/repository),$(call ECLIPSE_REPOSITORY_URL,$(ECLIPSE_PLATFORM_DIR))

else

#********************************************************************
#* eclipse_sdk.build
#*
#* Creates an eclipse installation in the current directory
#********************************************************************
	
$(BUILD_TOOLS_DIR)/launchbar.unpack : $(PACKAGES_DIR)/$(LAUNCHBAR_ZIP)
	$(Q)rm -rf $(LAUNCHBAR_DIR)
	$(Q)mkdir -p $(LAUNCHBAR_DIR)
	$(Q)cd $(LAUNCHBAR_DIR) ; unzip $^
	$(Q)touch $@

$(PACKAGES_DIR)/$(LAUNCHBAR_ZIP) :
	$(Q)if test ! -d `dirname $@`; then mkdir -p `dirname $@`; fi
	$(Q)wget -O $@ '$(LAUNCHBAR_URL)'
	
launchbar.install : \
	$(BUILD_TOOLS_DIR)/launchbar.unpack \
	$(BUILD_TOOLS_DIR)/eclipse_platform.unpack 
	$(Q)$(call ECLIPSE_INSTALL_IU, $(LAUNCHBAR_FEATURES), $(LAUNCHBAR_REPOS), \
		Launchbar, $(PARENT_DIR_A))
	$(Q)touch $@

	
endif
