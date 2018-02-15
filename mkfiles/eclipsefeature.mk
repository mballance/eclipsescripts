

ifneq (1,$(RULES))
ECLIPSE_FEATURES := $(ECLIPSE_FEATURES) $(FEATURE)

$(FEATURE)_SRCDIR := $(FEATURE_SRCDIR)
$(FEATURE)_SRC_FILES := $(shell find $($(FEATURE)_SRCDIR) -type f)
$(FEATURE)_VERSION := $(FEATURE_VERSION)
$(FEATURE)_PRE_BUILD_TARGETS := $(FEATURE_PRE_BUILD_TARGETS)
$(FEATURE)_BUILDDIR := $(BUILD_DIR)/$(FEATURE)

else

$(FEATURE) : $($(FEATURE)_BUILDDIR)/$(FEATURE).build
	echo "$(FEATURE)"


$($(FEATURE)_BUILDDIR)/$(FEATURE).build : $(FEATURE)_pre_build_targets
	echo ".build"

$(FEATURE)_pre_build_targets : $(BUILD_DIR)/tools/eclipse_sdk.build $($(FEATURE)_PRE_BUILD_TARGETS)

$($(FEATURE)_PRE_BUILD_TARGETS) : $($(FEATURE)_BUILDDIR)/$(FEATURE).copy

$($(FEATURE)_BUILDDIR)/$(FEATURE).copy : $($(FEATURE)_SRC_FILES)
	$(Q)if test ! -d `dirname $@`/build; then mkdir -p `dirname $@`/build; fi
	$(Q)$(ECLIPSE_ANT) -buildfile $(call NATIVE_PATH,$(ECLIPSESCRIPTS_DIR)/antfiles/copy_with_version.xml) \
		-Dsrc_dir=$(call NATIVE_PATH,$($(FEATURE)_SRCDIR)) \
		-Ddst_dir=$(call NATIVE_PATH,$($(FEATURE)_BUILDDIR)/build) \
		-Dversion=$($(FEATURE)_VERSION)
	$(Q)touch $@


endif
