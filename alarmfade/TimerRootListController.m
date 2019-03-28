#include "TimerRootListController.h"

@implementation TimerRootListController

- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"TimerPreferences" target:self] retain];
	}

	return _specifiers;
}

@end