include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = AlarmFade
AlarmFade_FILES = AFRootListController.m
AlarmFade_INSTALL_PATH = /Library/PreferenceBundles
AlarmFade_FRAMEWORKS = UIKit
AlarmFade_PRIVATE_FRAMEWORKS = Preferences

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/AlarmFade.plist$(ECHO_END)
