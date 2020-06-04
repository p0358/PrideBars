INSTALL_TARGET_PROCESSES = SpringBoard
ARCHS = arm64 arm64e

TARGET = iphone:11.2

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = PrideBars
$(TWEAK_NAME)_FILES = Tweak.xm
$(TWEAK_NAME)_CFLAGS = -fobjc-arc

SUBPROJECTS += prefs

include $(THEOS_MAKE_PATH)/tweak.mk

include $(THEOS_MAKE_PATH)/aggregate.mk
