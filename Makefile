ARCHS = arm64 arm64e
TARGET = iphone:clang:latest:13.0
DEBUG = 0
PACKAGE_VERSION = 1.0.0

THEOS_DEVICE_IP = localhost
THEOS_DEVICE_PORT = 2222

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = StandoffCheat
StandoffCheat_FILES = Tweak.xm
StandoffCheat_CFLAGS = -fobjc-arc
StandoffCheat_EXTRA_FRAMEWORKS = UIKit

include $(THEOS)/makefiles/tweak.mk

after-install::
	install.exec "killall -9 Standoff2 || :"
