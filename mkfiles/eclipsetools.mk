
ECLIPSETOOLS_MKFILES_DIR := $(dir $(lastword $(MAKEFILE_LIST)))
include $(ECLIPSETOOLS_MKFILES_DIR)/platformdefs.mk

ECLIPSE_SDK_DIR := $(BUILD_TOOLS_DIR)/eclipse

LAUNCHER_JAR = $(call NATIVE_PATH,$(wildcard $(ECLIPSE_SDK_DIR)/plugins/org.eclipse.equinox.launcher_*.jar))

JAVA = java

define ECLIPSE_SDK
	$(JAVA) -jar $(LAUNCHER_JAR)
endef

define ECLIPSE_ANT
	$(ECLIPSE_SDK) -application org.eclipse.ant.core.antRunner 
endef

# IU, Repository, Tag, Destination 
define ECLIPSE_INSTALL_IU
	$(ECLIPSE_SDK) -application org.eclipse.equinox.p2.director -installIU $1 -repository $2 -tag $3 -destination $4
endef

ifeq (Cygwin,$(uname_o))
define ECLIPSE_REPOSITORY_URL
file://$(shell cygpath -w $(1))
endef
else
define ECLIPSE_REPOSITORY_URL
file://$(1)
endef
endif
