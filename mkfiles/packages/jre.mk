

ifneq (1,$(RULES))
JRE_FETCHED := $(PACKAGES_DIR)/jre.fetched
JRE_VERSION := 1.8.0_171
JRE_PKG_VERSION := 8u171
JRE_DIRNAME := jre$(JRE_VERSION)
JRE_LINUX_X86_64 := jre-$(JRE_PKG_VERSION)-linux-x64
JRE_WIN32_X86_64 := jre-$(JRE_PKG_VERSION)-windows-x64
JRE_OSX_X86_64 := jre-$(JRE_PKG_VERSION)-macosx-x64
JRE_URL := http://download.oracle.com/otn-pub/java/jdk/$(JRE_PKG_VERSION)-b11/512cd62ec5174c3487ac17c61aaa89e8

define JRE_WGET
wget -O $@ --no-cookies --no-check-certificate \
	--header "Cookie: oraclelicense=accept-securebackup-cookie" $1
endef
else

$(JRE_FETCHED) : \
	$(PACKAGES_DIR)/$(JRE_LINUX_X86_64).tar.gz \
	$(PACKAGES_DIR)/$(JRE_WIN32_X86_64).tar.gz \
	$(PACKAGES_DIR)/$(JRE_OSX_X86_64).tar.gz
	$(Q)touch $@

# jre1.8.0_144
# jre1.8.0_144.jre
jre.install : $(JRE_FETCHED)
	echo "NOTE: jre.install with PLATFORM=$(PLATFORM) and ARCH=$(ARCH)"
	$(Q)if test "$(PLATFORM)" = "linux"; then \
              JRE_PKG=$(PACKAGES_DIR)/$(JRE_LINUX_X86_64).tar.gz; \
	    elif test "$(PLATFORM)" = "win32"; then \
              JRE_PKG=$(PACKAGES_DIR)/$(JRE_WIN32_X86_64).tar.gz; \
	    elif test "$(PLATFORM)" = "macosx"; then \
              JRE_PKG=$(PACKAGES_DIR)/$(JRE_OSX_X86_64).tar.gz; \
	    else \
         echo "Error: unknown platform $(PLATFORM)"; \
       fi ; \
       if test "$(PLATFORM)" = "macosx"; then \
         target_dir=../..; \
	 src_dir=$(JRE_DIRNAME).jre; \
       else \
         target_dir=..; \
	 src_dir=$(JRE_DIRNAME); \
       fi ; \
       cd $$target_dir ; \
       rm -rf jre; \
       $(UNTAR_GZ) $$JRE_PKG; \
       mv $$src_dir jre;


$(PACKAGES_DIR)/$(JRE_LINUX_X86_64).tar.gz :
	$(Q)rm -f $@
	$(Q)$(call JRE_WGET, $(JRE_URL)/$(shell basename $@))

$(PACKAGES_DIR)/$(JRE_WIN32_X86_64).tar.gz :
	$(Q)rm -f $@
	$(Q)$(call JRE_WGET, $(JRE_URL)/$(shell basename $@))

$(PACKAGES_DIR)/$(JRE_OSX_X86_64).tar.gz :
	$(Q)rm -f $@
	$(Q)$(call JRE_WGET, $(JRE_URL)/$(shell basename $@))

endif
