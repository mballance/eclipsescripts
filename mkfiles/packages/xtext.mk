
ifneq (1,$(RULES))

# TMF_XTEXT_VERSION := 2.12.0
TMF_XTEXT_VERSION := 2.10.0
# TMF_XTEXT_URL := $(ECLIPSE_MIRROR_URL)/modeling/tmf/xtext/downloads/drops/$(TMF_XTEXT_VERSION)/R201705191412
TMF_XTEXT_URL := $(ECLIPSE_MIRROR_URL)/modeling/tmf/xtext/downloads/drops/$(TMF_XTEXT_VERSION)/R201605250459
TMF_XTEXT_SDK_UPDATE_ZIP := tmf-xtext-Update-$(TMF_XTEXT_VERSION).zip
TMF_XTEXT_SDK_DIR := $(BUILD_TOOLS_DIR)/xtext_sdk

M2T_XPAND_VERSION := 2.2.0
M2T_XPAND_URL := $(ECLIPSE_MIRROR_URL)/modeling/m2t/xpand/downloads/drops/$(M2T_XPAND_VERSION)/R201605260315
M2T_XPAND_UPDATE_ZIP := m2t-xpand-Update-$(M2T_XPAND_VERSION).zip
M2T_XPAND_DIR := $(BUILD_TOOLS_DIR)/xpand

else

$(PACKAGES_DIR)/$(TMF_XTEXT_SDK_UPDATE_ZIP) :
	$(Q)if test ! -d `dirname $@`; then mkdir -p `dirname $@`; fi
	$(Q)wget -O $@ $(TMF_XTEXT_URL)/$(TMF_XTEXT_SDK_UPDATE_ZIP)
	
$(BUILD_TOOLS_DIR)/xtext.unpack : $(PACKAGES_DIR)/$(TMF_XTEXT_SDK_UPDATE_ZIP)
	$(Q)if test ! -d `dirname $@`; then mkdir -p `dirname $@`; fi
	$(Q)rm -rf $(TMF_XTEXT_SDK_DIR)
	$(Q)mkdir -p $(TMF_XTEXT_SDK_DIR)
	$(Q)cd $(TMF_XTEXT_SDK_DIR) ; unzip $^
	$(Q)touch $@
	
$(PACKAGES_DIR)/$(M2T_XPAND_UPDATE_ZIP) :
	$(Q)if test ! -d `dirname $@`; then mkdir -p `dirname $@`; fi
	$(Q)wget -O $@ $(M2T_XPAND_URL)/$(M2T_XPAND_UPDATE_ZIP)
	
$(BUILD_TOOLS_DIR)/xpand.unpack : $(PACKAGES_DIR)/$(M2T_XPAND_UPDATE_ZIP)
	$(Q)if test ! -d `dirname $@`; then mkdir -p `dirname $@`; fi
	$(Q)rm -rf $(M2T_XPAND_DIR)
	$(Q)mkdir -p $(M2T_XPAND_DIR)
	$(Q)cd $(M2T_XPAND_DIR) ; unzip $^
	$(Q)touch $@

XTEXT_REPOSITORIES:=$(call ECLIPSE_REPOSITORY_URL,$(M2T_XPAND_DIR)),$(call ECLIPSE_REPOSITORY_URL,$(TMF_XTEXT_SDK_DIR)),$(call ECLIPSE_REPOSITORY_URL,$(EMFT_MWE_DIR))
XTEXT_FEATURES:=org.eclipse.xtend.feature.group,org.eclipse.xpand.feature.group,org.eclipse.xtend.sdk.feature.group,org.eclipse.xtext.sdk.feature.group
XTEXT_RT_FEATURES:=org.eclipse.xtend.feature.group,org.eclipse.xpand.feature.group,org.eclipse.xtend.feature.group,org.eclipse.xtext.runtime.feature.group,org.eclipse.xtext.ui.feature.group

xtext.runtime.install : \
		$(BUILD_TOOLS_DIR)/xtext.unpack \
		$(BUILD_TOOLS_DIR)/xpand.unpack \
		$(BUILD_TOOLS_DIR)/mwe.unpack \
		apache.commons.install google.inject.install \
		emf.install gef.install
	$(Q)$(call ECLIPSE_INSTALL_IU, $(XTEXT_RT_FEATURES), \
			$(XTEXT_REPOSITORIES), \
			XtextRT, $(PARENT_DIR_A))

xtext.install : \
		$(BUILD_TOOLS_DIR)/xtext.unpack \
		$(BUILD_TOOLS_DIR)/xpand.unpack \
		$(BUILD_TOOLS_DIR)/mwe.unpack \
		apache.commons.install google.inject.install \
		emf.install gef.install
	$(Q)$(call ECLIPSE_INSTALL_IU, $(XTEXT_FEATURES), \
			$(XTEXT_REPOSITORIES), \
			XtextSDK, $(PARENT_DIR_A))
	$(Q)touch $@

endif
