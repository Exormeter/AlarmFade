#include "AlarmRootListController.h"

@implementation AlarmRootListController

- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"AlarmPreferences" target:self] retain];
	}

	return _specifiers;
}

@end
