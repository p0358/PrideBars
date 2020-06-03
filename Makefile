#TARGET = simulator:clang::11.0
#ARCHS = x86_64

#TARGET = iphone:13.0
#TARGET = iphone::13.0:latest
#ARCHS = arm64 arm64e
#TARGET = iphone::11.2:latest
TARGET = iphone:11.2
ARCHS = arm64 arm64e
PACKAGE_VERSION = 1.0.3

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = PrideBars
$(TWEAK_NAME)_FILES = Tweak.xm
$(TWEAK_NAME)_CFLAGS = -fobjc-arc
#$(TWEAK_NAME)_FRAMEWORKS = UIKit Foundation

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
