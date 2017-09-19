
ifneq (1,$(RULES))
	ECLIPSE_FEATURES += $(FEATURE)
else

$(FEATURE) : $(BUILD_DIR)/$(FEATURE).feature

endif