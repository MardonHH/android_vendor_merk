# Versioning of the ROM

 MERK_MAJOR := 1
 MERK_MINOR := 0
 MERK_VERSION_MAINTENANCE := 1
 MERK_VERSION_TAG := BETA
 MERK_BUILDTYPE :=

TARGET_PRODUCT_SHORT := $(TARGET_PRODUCT)
TARGET_PRODUCT_SHORT := $(subst merk_,,$(TARGET_PRODUCT_SHORT))

# Build the final version string
ifdef BUILDTYPE_RELEASE
ROM_VERSION := $(PLATFORM_VERSION)-$(TARGET_PRODUCT_SHORT)
else
ifneq ($(ROM_BUILDTIME_CUSTOM),)
DATE := $(ROM_BUILDTIME_CUSTOM)
else
ifeq ($(ROM_BUILDTIME_LOCAL),y)
DATE := $(shell date +%Y%m%d-%H%M%z)
else
DATE := $(shell date -u +%Y%m%d)
endif
endif # BUILDTYPE_RELEASE

ROM_VERSION := $(MERK_MAJOR).$(MERK_MINOR)-$(TARGET_PRODUCT_SHORT)-$(MERK_VERSION_TAG)-$(MERK_VERSION_MAINTENANCE)
endif

MERK_VERSION := $(ROM_VERSION)-$(shell date -u +%Y%m%d)

# Apply it to build.prop
PRODUCT_PROPERTY_OVERRIDES += \
ro.modversion=MerkMod-$(ROM_VERSION) \
ro.merk.version=$(MERK_VERSION) \
ro.merk.date=$(shell date +"%Y%m%d")
