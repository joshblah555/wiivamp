ARCHS = arm64
TARGET = appletv

include /var/theos/makefiles/common.mk

TWEAK_NAME = ZeldaTV
ZeldaTV_FILES = ZeldaTV.xm

include /var/theos/makefiles/tweak.mk


after-install::
	install.exec "killall -9 PineBoard"

include /var/theos/makefiles/aggregate.mk
