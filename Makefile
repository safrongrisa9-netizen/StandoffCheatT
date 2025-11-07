ARCHS = arm64 arm64e
TARGET = iphone:clang:latest:13.0
DEBUG = 0
PACKAGE_VERSION = 1.0.0

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = StandoffCheat
StandoffCheat_FILES = Tweak.xm
StandoffCheat_CFLAGS = -fobjc-arc -Wno-unused-value -Wno-format
StandoffCheat_EXTRA_FRAMEWORKS = UIKit
StandoffCheat_ARCHS = arm64 arm64e

include $(THEOS)/makefiles/tweak.mk

after-install::
	install.exec "killall -9 Standoff2 || :"
