
ifneq (1,$(RULES))

EQUINOX_VERSION := Neon.3
EQUINOX_URL := $(ECLIPSE_MIRROR_URL)/equinox/drops/R-$(EQUINOX_VERSION)-201703010400/
EQUINOX_ZIP := equinox-SDK-$(EQUINOX_VERSION).zip
EQUINOX_DIR := $(BUILD_TOOLS_DIR)/equinox

else

$(PACKAGES_DIR)/$(EQUINOX_ZIP) :
	$(Q)if test ! -d `dirname $@`; then mkdir -p `dirname $@`; fi
	$(Q)wget -O $@ $(EQUINOX_URL)/$(EQUINOX_ZIP)

$(BUILD_TOOLS_DIR)/equinox.unpack : $(PACKAGES_DIR)/$(EQUINOX_ZIP)
	$(Q)if test ! -d `dirname $@`; then mkdir -p `dirname $@`; fi
	$(Q)rm -rf $(EQUINOX_DIR)
	$(Q)mkdir -p $(EQUINOX_DIR)
	$(Q)cd $(EQUINOX_DIR) ; unzip $^
	$(Q)touch $@
	
EQUINOX_FEATURES:=org.eclipse.equinox.executable.feature.group
	
equinox.install : $(BUILD_TOOLS_DIR)/equinox.unpack
	$(Q)$(call ECLIPSE_INSTALL_IU,  $(EQUINOX_FEATURES), \
			$(call ECLIPSE_REPOSITORY_URL,$(EQUINOX_DIR)), \
			Equinox, $(PARENT_DIR_A))
	$(Q)cd ../plugins ; \
		for jar in $(EQUINOX_DIR)/plugins/org.eclipse.equinox.launcher*.jar; do \
			dir=`basename $$jar | sed -e 's/.jar//g'`; \
			mkdir $$dir; cd $$dir ; \
			unzip -o $$jar ; \
			cd .. ; \
		done
	$(Q)touch $@

endif
