#
# MerkMod Audio Files
#

RINGTONE_PATH := vendor/merk/prebuilt/media/audio/ringtones
UI_PATH := vendor/merk/prebuilt/media/audio/ui
BOOT_PATH := vendor/merk/prebuilt/media/audio/bootanimation

# Ringtones
PRODUCT_COPY_FILES += \
	$(RINGTONE_PATH)/Announcement.mp3:system/media/audio/ringtones/Announcement.mp3 \
	$(RINGTONE_PATH)/NokiaRinger.mp3:system/media/audio/ringtones/NokiaRinger.mp3 \
	$(RINGTONE_PATH)/Party.mp3:system/media/audio/ringtones/Party.mp3 \
	$(RINGTONE_PATH)/RiseUp.mp3:system/media/audio/ringtones/RiseUp.mp3 \
	$(RINGTONE_PATH)/SevenOceans.mp3:system/media/audio/ringtones/SevenOceans.mp3

# bootsound
PRODUCT_COPY_FILES += \
	$(BOOT_PATH)/audio.mp3:system/media/audio.mp3
