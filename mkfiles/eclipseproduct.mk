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

ifeq (true,$(VERBOSE))
VERBOSE_FLAG := -v
endif

${PRODUCT}_ANT_DEFINES := \
		-Dproduct=$(strip ${PRODUCT_FILE}) \
		-DarchivePrefix=$(strip ${PRODUCT}-${PRODUCT_VERSION}.app) \
		-DbuildId=$(strip ${PRODUCT}) \
		-Dfeature.version=$(strip ${PRODUCT_VERSION}) \
		-Dbuild=$(strip $(call NATIVE_PATH,${${PRODUCT}_BUILDDIR})) \
		-Declipsescripts.dir=$(strip $(call NATIVE_PATH,$(ECLIPSESCRIPTS_DIR))) \
		-Dsrcdir=$(strip $(call NATIVE_PATH,${PRODUCT_SRCDIR}) $(VERBOSE_FLAG))
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

$(BUILD_DIR)/$($(PRODUCT)_TARGET)/$($(PRODUCT)_TARGET).product.build : \
		$($(PRODUCT)_PRE_BUILD_TARGETS) \
		$(BUILD_DIR)/${${PRODUCT}_TARGET}/$($(PRODUCT)_TARGET).product.init
	$(Q)$(ECLIPSE_ANT) \
		-buildfile $(call NATIVE_PATH,$(ECLIPSESCRIPTS_DIR)/antfiles/mk_product.xml) \
		$($(PRODUCT)_ANT_DEFINES) mk_product 
	$(Q)touch $@
	
PLATFORMS := win32 linux macosx
# ARCHS := x86 x86_64
ifeq (,$(ARCHS))
  ARCHS := x86_64
endif
#PLATFORMS := win32
#ARCHS := x86_64

$(BUILD_DIR)/$($(PRODUCT)_TARGET)/$($(PRODUCT)_TARGET).product : \
	$(BUILD_DIR)/$($(PRODUCT)_TARGET)/$($(PRODUCT)_TARGET).product.build  \
	$(JRE_FETCHED)
	$(Q)if test "x$($(PRODUCT)_PKGS)" != "x"; then \
		for plat in $(PLATFORMS); do \
			for arch in $(ARCHS); do \
                if test "$$plat" = "macosx"; then \
                  dir=$(BUILD_DIR)/$($(PRODUCT)_TARGET)/result/$${plat}.$${arch}/$($(PRODUCT)_TARGET)-$($(PRODUCT)_VERSION).app; \
                  plat_dir=$$dir/Contents/Eclipse; \
                else \
                  dir=$(BUILD_DIR)/$($(PRODUCT)_TARGET)/result/$${plat}.$${arch}/$($(PRODUCT)_TARGET)-$($(PRODUCT)_VERSION); \
                  plat_dir=$$dir; \
                fi ; \
				if test -d $$dir; then \
					mkdir -p $$plat_dir/packages; \
					echo "MAKE in $$plat_dir/packages"; \
					$(MAKE) -C $$plat_dir/packages -f $(ECLIPSESCRIPTS_DIR)/mkfiles/packages.mk \
						ECLIPSE_PKGS="$($(PRODUCT)_PKGS)" VERBOSE=$(VERBOSE) \
						PACKAGES_DIR=$(PACKAGES_DIR) BUILD_DIR=$(BUILD_DIR) \
						BUILD_TOOLS_DIR=$(BUILD_TOOLS_DIR) \
						ECLIPSESCRIPTS_PKGS_DIRS="$(ECLIPSESCRIPTS_PKGS_DIRS)" \
						PLATFORM=$$plat \
						ARCH=$$arch \
						install_pkgs; \
					if test $$? -ne 0; then exit 1; fi \
				fi \
			done \
		done \
	fi
	$(Q)$(ECLIPSE_ANT) \
		-buildfile $(call NATIVE_PATH,$(ECLIPSESCRIPTS_DIR)/antfiles/mk_product.xml) \
		$($(PRODUCT)_ANT_DEFINES) package 
	$(Q)touch $@

endif
