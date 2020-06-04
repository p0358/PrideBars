#include "PRIDEBARSRootListController.h"

@implementation PRIDEBARSRootListController

- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];
	}

	return _specifiers;
}

- (void)GitHub {
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://github.com/p0358"] options:@{} completionHandler:nil];
}

- (void)Reddit {
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://reddit.com/user/p0358"] options:@{} completionHandler:nil];
}

- (void)PayPal {
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://paypal.me/p0358donate"] options:@{} completionHandler:nil];
}

@end
