#****************************************************************************
#* eclipseproduct.mk
#*
#* PRODUCT: name of the product
#* PRODUCT_FILE: path
#* PRODUCT_SRCDIR: path to the directory contains features/plugins
#* PRODUCT_VERSION: version of the product
#****************************************************************************
$(PRODUCT)_TARGET := ${PRODUCT}
	
$(PRODUCT)_SRC_FILES := $(shell find $(PRODUCT_SRCDIR) -type f)
$(PRODUCT)_VERSION := $(PRODUCT_VERSION)
$(PRODUCT)_BUILDDIR := $(BUILD_DIR)/$(PRODUCT)
$(PRODUCT)_PRE_BUILD_TARGETS := $(PRODUCT_PRE_BUILD_TARGETS)
$(PRODUCT)_PKGS := $(PRODUCT_PKGS)

${PRODUCT}_ANT_DEFINES := \
		-Dproduct=${PRODUCT_FILE} \
		-DarchivePrefix=${PRODUCT}-${PRODUCT_VERSION}.app \
		-DbuildId=${PRODUCT} \
		-Dfeature.version=${PRODUCT_VERSION} \
		-Dbuild=$(call NATIVE_PATH,${${PRODUCT}_BUILDDIR}) \
		-Declipsescripts.dir=$(call NATIVE_PATH,$(ECLIPSESCRIPTS_DIR)) \
		-Dsrcdir=$(call NATIVE_PATH,${PRODUCT_SRCDIR}) 
#		-Dos=$(osgi_os) -Dws=$(osgi_ws) -Darch=$(osgi_arch) 

ifneq (1,$(RULES))
ECLIPSE_PRODUCTS += ${PRODUCT}
else

ECLIPSE_SDK_PKGS += equinox

${${PRODUCT}_TARGET} : $(BUILD_DIR)/${PRODUCT}/${PRODUCT}.product

$(BUILD_DIR)/${${PRODUCT}_TARGET}/${${PRODUCT}_TARGET}.product.init : \
	$(BUILD_TOOLS_DIR)/eclipse_sdk.build \
	$(${PRODUCT}_SOURCE_FILES)
	echo "PRODUCT_TARGET=$(${PRODUCT}_TARGET)"
	$(Q)$(ECLIPSE_ANT) \
		-buildfile $(call NATIVE_PATH,$(ECLIPSESCRIPTS_DIR)/antfiles/mk_product.xml) \
		${${PRODUCT}_ANT_DEFINES} init 
	$(Q)touch $@
		
${${PRODUCT}_PRE_BUILD_TARGETS} : $(BUILD_DIR)/${${PRODUCT}_TARGET}/$($(PRODUCT)_TARGET).product.init

$(BUILD_DIR)/$($(PRODUCT)_TARGET)/$($(PRODUCT)_TARGET).product.build : $($(PRODUCT)_PRE_BUILD_TARGETS)
	$(Q)$(ECLIPSE_ANT) \
		-buildfile $(call NATIVE_PATH,$(ECLIPSESCRIPTS_DIR)/antfiles/mk_product.xml) \
		$($(PRODUCT)_ANT_DEFINES) mk_product 
	$(Q)touch $@

$(BUILD_DIR)/$($(PRODUCT)_TARGET)/$($(PRODUCT)_TARGET).product : $(BUILD_DIR)/$($(PRODUCT)_TARGET)/$($(PRODUCT)_TARGET).product.build 
	$(Q)if test "x$($(PRODUCT)_PKGS)" != "x"; then \
		echo "TODO: install packages"; \
	fi
	$(Q)$(ECLIPSE_ANT) \
		-buildfile $(call NATIVE_PATH,$(ECLIPSESCRIPTS_DIR)/antfiles/mk_product.xml) \
		$($(PRODUCT)_ANT_DEFINES) package 
	$(Q)touch $@

endif