

ifneq (1,$(RULES))
EMF_VERSION := 2.13.0
EMF_URL := $(ECLIPSE_MIRROR_URL)/modeling/emf/emf/downloads/drops/$(EMF_VERSION)/R201706090928
EMF_ZIP := emf-xsd-Update-$(EMF_VERSION).zip
EMF_DIR := $(BUILD_TOOLS_DIR)/emf

EMFT_MWE_VERSION := 2.9.1
EMFT_MWE_URL := $(ECLIPSE_MIRROR_URL)/modeling/emft/mwe/downloads/drops/$(EMFT_MWE_VERSION)/R201705291010
EMFT_MWE_ZIP := emft-mwe-2-lang-Update-$(EMFT_MWE_VERSION).zip
EMFT_MWE_DIR := $(BUILD_TOOLS_DIR)/mwe

else

$(PACKAGES_DIR)/$(EMF_ZIP) :
	$(Q)if test ! -d `dirname $@`; then mkdir -p `dirname $@`; fi
	$(Q)wget -O $@ $(EMF_URL)/$(EMF_ZIP)

$(BUILD_TOOLS_DIR)/emf.unpack : $(PACKAGES_DIR)/$(EMF_ZIP)
	$(Q)if test ! -d `dirname $@`; then mkdir -p `dirname $@`; fi
	$(Q)rm -rf $(EMF_DIR)
	$(Q)mkdir -p $(EMF_DIR)
	$(Q)cd $(EMF_DIR) ; unzip $^
	$(Q)touch $@
	
$(PACKAGES_DIR)/$(EMFT_MWE_ZIP) :
	$(Q)if test ! -d `dirname $@`; then mkdir -p `dirname $@`; fi
	$(Q)wget -O $@ $(EMFT_MWE_URL)/$(EMFT_MWE_ZIP)

$(BUILD_TOOLS_DIR)/mwe.unpack : $(PACKAGES_DIR)/$(EMFT_MWE_ZIP)
	$(Q)if test ! -d `dirname $@`; then mkdir -p `dirname $@`; fi
	$(Q)rm -rf $(EMFT_MWE_DIR)
	$(Q)mkdir -p $(EMFT_MWE_DIR)
	$(Q)cd $(EMFT_MWE_DIR) ; unzip $^
	$(Q)touch $@

EMFT_MWE_FEATURES:=org.eclipse.emf.mwe.sdk.feature.group
EMF_FEATURES:=org.eclipse.emf.databinding.feature.group,org.eclipse.emf.edit.feature.group,org.eclipse.xsd.edit.feature.group,org.eclipse.emf.edit.ui.feature.group,org.eclipse.emf.ecore.edit.feature.group,org.eclipse.emf.codegen.feature.group,org.eclipse.emf.converter.feature.group,org.eclipse.emf.ecore.editor.feature.group
EMF_RT_FEATURES:=org.eclipse.emf.databinding.feature.group,org.eclipse.emf.edit.feature.group,org.eclipse.xsd.edit.feature.group,org.eclipse.emf.edit.ui.feature.group,org.eclipse.emf.ecore.edit.feature.group

emf_rt.install : $(BUILD_TOOLS_DIR)/emf.unpack 
	$(Q)$(call ECLIPSE_INSTALL_IU, $(EMF_RT_FEATURES), \
			$(call ECLIPSE_REPOSITORY_URL,$(EMF_DIR)), \
			EmfRt, $(PARENT_DIR_A))
	$(Q)touch $@

emf.install : \
		$(BUILD_TOOLS_DIR)/emf.unpack \
		$(BUILD_TOOLS_DIR)/mwe.unpack \
		google.inject.install apache.log4j.install
	$(Q)$(call ECLIPSE_INSTALL_IU, $(EMFT_MWE_FEATURES), \
			$(call ECLIPSE_REPOSITORY_URL,$(EMFT_MWE_DIR)), \
			EmftMWE_1, $(PARENT_DIR_A))
	$(Q)$(call ECLIPSE_INSTALL_IU, $(EMF_FEATURES), \
			$(call ECLIPSE_REPOSITORY_URL,$(EMF_DIR)), \
			Emf_1, $(PARENT_DIR_A))
	$(Q)touch $@

endif
