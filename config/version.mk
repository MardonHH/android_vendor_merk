# Versioning of the ROM

ifeq ($(BUILD_IS_JENKINS),1)

ifneq ($(BUILD_BUILDTYPE),)
    ROM_BUILDTYPE = $(BUILD_BUILDTYPE)
else
    ROM_BUILDTYPE := NIGHTLY
endif

endif # we are jenkins

ifdef BUILDTYPE_RELEASE
    ROM_BUILDTYPE := RELEASE
endif

ifndef ROM_BUILDTYPE
    ROM_BUILDTYPE := EXPERIMENTAL
endif

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

ROM_VERSION := $(PLATFORM_VERSION)-$(DATE)-$(TARGET_PRODUCT_SHORT)-$(ROM_BUILDTYPE)
endif

MERK_VERSION := $(ROM_VERSION)

# Apply it to build.prop
PRODUCT_PROPERTY_OVERRIDES += \
    ro.modversion=merk-$(ROM_VERSION) \
    ro.merk.version=$(ROM_VERSION) \
    ro.merk.date=$(shell date +"%Y%m%d") \
    ro.merk.releasetype=$(ROM_BUILDTYPE) \

# disable multithreaded dextop for everything but nightlies and homemade
ifeq ($(filter MERK EXPERIMENTAL,$(ROM_BUILDTYPE)),)
PRODUCT_PROPERTY_OVERRIDES += \
    persist.sys.dalvik.multithread=false
endif

