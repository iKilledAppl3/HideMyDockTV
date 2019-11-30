ARCHS = arm64
TARGET = appletv:clang
SYSROOT = $(THEOS)/sdks/AppleTVOS12.4.sdk
FINALPACKAGE = 1
THEOS_DEVICE_IP = 192.168.1.211

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = HideMyDockTV
HideMyDockTV_FILES = Tweak.xm
HideMyDockTV_FRAMEWORKS = UIKit CoreGraphics
HideMyDockTV_LIBRARIES = substrate

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 backboardd"
SUBPROJECTS += hidemydocktv
include $(THEOS_MAKE_PATH)/aggregate.mk
