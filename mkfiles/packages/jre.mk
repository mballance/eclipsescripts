

ifneq (1,$(RULES))
JRE_FETCHED := $(PACKAGES_DIR)/jre.fetched
JRE_VERSION := 1.8.0_144
JRE_PKG_VERSION := 8u144
JRE_DIRNAME := jre$(JRE_VERSION)
JRE_LINUX_X86 := jre-$(JRE_PKG_VERSION)-linux-i586
JRE_LINUX_X86_64 := jre-$(JRE_PKG_VERSION)-linux-x64
JRE_WIN32_X86 := jre-$(JRE_PKG_VERSION)-windows-i586
JRE_WIN32_X86_64 := jre-$(JRE_PKG_VERSION)-windows-x64
JRE_OSX_X86_64 := jre-$(JRE_PKG_VERSION)-macosx-x64
JRE_URL := http://download.oracle.com/otn-pub/java/jdk/$(JRE_PKG_VERSION)-b01/090f390dda5b47b9b721c7dfaa008135
http://download.oracle.com/otn-pub/java/jdk/8u144-b01/090f390dda5b47b9b721c7dfaa008135/jre-8u144-windows-x64.tar.gz

define JRE_WGET
wget -O $@ --no-cookies --no-check-certificate \
	--header "Cookie: oraclelicense=accept-securebackup-cookie" $1
endef
else

$(JRE_FETCHED) : \
	$(PACKAGES_DIR)/$(JRE_LINUX_X86).tar.gz \
	$(PACKAGES_DIR)/$(JRE_LINUX_X86_64).tar.gz \
	$(PACKAGES_DIR)/$(JRE_WIN32_X86).tar.gz \
	$(PACKAGES_DIR)/$(JRE_WIN32_X86_64).tar.gz \
	$(PACKAGES_DIR)/$(JRE_OSX_X86_64).tar.gz
	$(Q)touch $@

# jre1.8.0_144
# jre1.8.0_144.jre
jre.install : $(JRE_FETCHED)
	echo "NOTE: jre.install with PLATFORM=$(PLATFORM) and ARCH=$(ARCH)"
	$(Q)if test "$(PLATFORM)" = "linux"; then \
	      if test "$(ARCH)" = "x86"; then \
           JRE_PKG=$(PACKAGES_DIR)/$(JRE_LINUX_X86).tar.gz; \
	      else \
           JRE_PKG=$(PACKAGES_DIR)/$(JRE_LINUX_X86_64).tar.gz; \
	      fi \
	    elif test "$(PLATFORM)" = "win32"; then \
	      if test "$(ARCH)" = "x86"; then \
           JRE_PKG=$(PACKAGES_DIR)/$(JRE_WIN32_X86).tar.gz; \
	      else \
           JRE_PKG=$(PACKAGES_DIR)/$(JRE_WIN32_X86_64).tar.gz; \
	      fi \
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
       tar xvzf $$JRE_PKG; \
       mv $$src_dir jre;


$(PACKAGES_DIR)/$(JRE_LINUX_X86).tar.gz :
	$(Q)rm -f $@
	$(Q)$(call JRE_WGET, $(JRE_URL)/$(shell basename $@))

$(PACKAGES_DIR)/$(JRE_LINUX_X86_64).tar.gz :
	$(Q)rm -f $@
	$(Q)$(call JRE_WGET, $(JRE_URL)/$(shell basename $@))

$(PACKAGES_DIR)/$(JRE_WIN32_X86).tar.gz :
	$(Q)rm -f $@
	$(Q)$(call JRE_WGET, $(JRE_URL)/$(shell basename $@))

$(PACKAGES_DIR)/$(JRE_WIN32_X86_64).tar.gz :
	$(Q)rm -f $@
	$(Q)$(call JRE_WGET, $(JRE_URL)/$(shell basename $@))

$(PACKAGES_DIR)/$(JRE_OSX_X86_64).tar.gz :
	$(Q)rm -f $@
	$(Q)$(call JRE_WGET, $(JRE_URL)/$(shell basename $@))

endif
