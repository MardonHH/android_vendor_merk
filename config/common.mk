PRODUCT_BRAND ?= merk

#Su Support
SUPERUSER_EMBEDDED := true
SUPERUSER_PACKAGE_PREFIX := com.android.settings.merk.superuser

PRODUCT_PACKAGES += \
    Superuser \
    su 

PRODUCT_COPY_FILES += \
    external/koush/Superuser/init.superuser.rc:root/init.superuser.rc

# bootanimation (Some devices needs half-res for a bootani)
ifneq ($(TARGET_SCREEN_WIDTH) $(TARGET_SCREEN_HEIGHT),$(space))
# determine the smaller dimension
TARGET_BOOTANIMATION_SIZE := $(shell \
  if [ $(TARGET_SCREEN_WIDTH) -lt $(TARGET_SCREEN_HEIGHT) ]; then \
    echo $(TARGET_SCREEN_WIDTH); \
  else \
    echo $(TARGET_SCREEN_HEIGHT); \
  fi )

# get a sorted list of the sizes
bootanimation_sizes := $(subst .zip,, $(shell ls vendor/merk/prebuilt/bootanimation))
bootanimation_sizes := $(shell echo -e $(subst $(space),'\n',$(bootanimation_sizes)) | sort -rn)

# find the appropriate size and set
define check_and_set_bootanimation
$(eval TARGET_BOOTANIMATION_NAME := $(shell \
  if [ -z "$(TARGET_BOOTANIMATION_NAME)" ]; then
    if [ $(1) -le $(TARGET_BOOTANIMATION_SIZE) ]; then \
      echo $(1); \
      exit 0; \
    fi;
  fi;
  echo $(TARGET_BOOTANIMATION_NAME); ))
endef
$(foreach size,$(bootanimation_sizes), $(call check_and_set_bootanimation,$(size)))

ifeq ($(TARGET_BOOTANIMATION_HALF_RES),true)
PRODUCT_BOOTANIMATION := vendor/merk/prebuilt/bootanimation/halfres/$(TARGET_BOOTANIMATION_NAME).zip
else
PRODUCT_BOOTANIMATION := vendor/merk/prebuilt/bootanimation/$(TARGET_BOOTANIMATION_NAME).zip
endif
endif 

ifeq ($(PRODUCT_GMS_CLIENTID_BASE),)
PRODUCT_PROPERTY_OVERRIDES += \
    ro.com.google.clientidbase=android-google
else
PRODUCT_PROPERTY_OVERRIDES += \
    ro.com.google.clientidbase=$(PRODUCT_GMS_CLIENTID_BASE)
endif

# general properties
PRODUCT_PROPERTY_OVERRIDES += \
    keyguard.no_require_sim=true \
    ro.url.legal=http://www.google.com/intl/%s/mobile/android/basic/phone-legal.html \
    ro.com.android.wifi-watchlist=GoogleGuest \
    ro.setupwizard.enterprise_mode=1 \
    ro.com.android.dateformat=MM-dd-yyyy \
    ro.com.android.dataroaming=false \
    persist.sys.root_access=3


PRODUCT_PROPERTY_OVERRIDES += \
    ro.build.selinux=1

# Thank you, please drive thru!
PRODUCT_PROPERTY_OVERRIDES += persist.sys.dun.override=0

# enable ADB authentication if not on eng build
ifneq ($(TARGET_BUILD_VARIANT),eng)
ADDITIONAL_DEFAULT_PROPERTIES += ro.adb.secure=1
endif

# Backup Tool
PRODUCT_COPY_FILES += \
    vendor/merk/prebuilt/bin/backuptool.sh:system/bin/backuptool.sh \
    vendor/merk/prebuilt/bin/backuptool.functions:system/bin/backuptool.functions \
    vendor/merk/prebuilt/bin/50-hosts.sh:system/addon.d/50-hosts.sh \
    vendor/merk/prebuilt/bin/blacklist:system/addon.d/blacklist 

# init.d support
PRODUCT_COPY_FILES += \
    vendor/merk/prebuilt/etc/init.d/00banner:system/etc/init.d/00banner \
    vendor/merk/prebuilt/bin/sysinit:system/bin/sysinit

# Bring in camera effects
PRODUCT_COPY_FILES +=  \
    vendor/merk/prebuilt/media/LMprec_508.emd:system/media/LMprec_508.emd \
    vendor/merk/prebuilt/media/PFFprec_600.emd:system/media/PFFprec_600.emd

# userinit support
PRODUCT_COPY_FILES += \
    vendor/merk/prebuilt/etc/init.d/90userinit:system/etc/init.d/90userinit

# Init script file with merkmod extras
PRODUCT_COPY_FILES += \
    vendor/merk/prebuilt/etc/init.local.rc:root/init.merk.rc

# Enable SIP and VoIP on all targets
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.software.sip.voip.xml:system/etc/permissions/android.software.sip.voip.xml

# Audio Packages
-include vendor/merk/config/merk_audio.mk

# Additional packages
-include vendor/merk/config/packages.mk

# Versioning
-include vendor/merk/config/version.mk

# Add our overlays
PRODUCT_PACKAGE_OVERLAYS += vendor/merk/overlay/common
