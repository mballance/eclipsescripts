
ifneq (1,$(RULES))

ORBIT_VERSION := R20160520211859
ORBIT_URL := $(ECLIPSE_MIRROR_URL)/tools/orbit/downloads/drops/$(ORBIT_VERSION)
ORBIT_ZIP := orbit-buildrepo-$(ORBIT_VERSION).zip
ORBIT_DIR := $(BUILD_TOOLS_DIR)/orbit

else

$(PACKAGES_DIR)/$(ORBIT_ZIP) :
	$(Q)if test ! -d `dirname $@`; then mkdir -p `dirname $@`; fi
	$(Q)wget -O $@ $(ORBIT_URL)/$(ORBIT_ZIP)

$(BUILD_TOOLS_DIR)/orbit.unpack : $(PACKAGES_DIR)/$(ORBIT_ZIP)
	$(Q)if test ! -d `dirname $@`; then mkdir -p `dirname $@`; fi
	$(Q)rm -rf $(ORBIT_DIR)
	$(Q)mkdir -p $(ORBIT_DIR)
	$(Q)cd $(ORBIT_DIR) ; unzip $^
	$(Q)touch $@
	
APACHE_COMMONS_FEATURES:=org.apache.commons.lang,org.apache.commons.lang.source
	
apache.commons.install : $(BUILD_TOOLS_DIR)/orbit.unpack
	$(Q)$(call ECLIPSE_INSTALL_IU,  $(APACHE_COMMONS_FEATURES), \
			$(call ECLIPSE_REPOSITORY_URL,$(ORBIT_DIR)), \
			ApacheCommons, $(PARENT_DIR_A))
	$(Q)touch $@
	
APACHE_LOG4J_FEATURES:=org.apache.log4j

apache.log4j.install : $(BUILD_TOOLS_DIR)/orbit.unpack
	$(Q)$(call ECLIPSE_INSTALL_IU,  $(APACHE_LOG4J_FEATURES), \
			$(call ECLIPSE_REPOSITORY_URL,$(ORBIT_DIR)), \
			ApacheLog4j, $(PARENT_DIR_A))
	$(Q)touch $@

GOOGLE_INJECT_FEATURES:=com.google.inject,com.google.inject.assistedinject,com.google.inject.multibindings,com.google.guava
google.inject.install : $(BUILD_TOOLS_DIR)/orbit.unpack
	$(Q)$(call ECLIPSE_INSTALL_IU, $(GOOGLE_INJECT_FEATURES), \
			$(call ECLIPSE_REPOSITORY_URL,$(ORBIT_DIR)), \
			GoogleInject, $(PARENT_DIR_A))
	$(Q)touch $@
	
endif
