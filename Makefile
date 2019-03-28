include $(THEOS)/makefiles/common.mk


TWEAK_NAME = AlarmFade
AlarmFade_FILES = Tweak.xm
include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 mobiletimerd"
SUBPROJECTS += alarmfade
include $(THEOS_MAKE_PATH)/aggregate.mk
