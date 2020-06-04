@interface _UIStatusBarSignalView : UIView
@property (assign,nonatomic) NSInteger numberOfBars;
@property (assign,nonatomic) NSInteger numberOfActiveBars;
- (void)pridebars_setPrideColors;
@end

@interface _UIStatusBarCellularSignalView : _UIStatusBarSignalView
// Sublayers are CALayers
// Set the color by modifying the sublayer's backgroundColor
-(void)_updateBars;
@end

@interface _UIStatusBarWifiSignalView : _UIStatusBarSignalView
-(void)_updateBars;
@end

@interface CALayer (seconds)
@property struct CGColor* contentsMultiplyColor;
-(void)setContentsMultiplyColor:(CGColorRef)arg1;
@end

static inline CGColor* getCGColorForID(int colorID) {
    switch (colorID) {
        case 1: return [UIColor redColor].CGColor; break;
        case 2: return [UIColor orangeColor].CGColor; break;
        case 3: return [UIColor yellowColor].CGColor; break;
        case 4: return [UIColor greenColor].CGColor; break;
        case 5: return [UIColor blueColor].CGColor; break;
        case 6: return [UIColor purpleColor].CGColor; break;
        case 7: return [UIColor blackColor].CGColor; break;
        case 8: return [UIColor brownColor].CGColor; break;
        case 9: return [UIColor cyanColor].CGColor; break;
        case 10: return [UIColor darkGrayColor].CGColor; break;
        case 11: return [UIColor grayColor].CGColor; break;
        case 12: return [UIColor lightGrayColor].CGColor; break;
        case 13: return [UIColor magentaColor].CGColor; break;
        case 14: return [UIColor whiteColor].CGColor; break;
        default: return [UIColor whiteColor].CGColor; break;
    }
}

static BOOL enabledCarrier = YES;
static BOOL enabledWifi = YES;
static int carrierbar0color = 1;
static int carrierbar1color = 2;
static int carrierbar2color = 3;
static int carrierbar3color = 4;
static int wifibar2color = 4;
static int wifibar1color = 3;
static int wifibar0color = 1;

// there are more than 1 of each, perhaps I should do something about that in the future
static _UIStatusBarCellularSignalView* lastCarrierSignalView;
static _UIStatusBarWifiSignalView* lastWifiSignalView;

static void refreshPrefs() {
	NSDictionary *settings = [[NSUserDefaults standardUserDefaults]persistentDomainForName:@"net.p0358.pridebars"];
	enabledCarrier = [([settings objectForKey:@"enabledCarrier"] ?: @(YES)) boolValue];
	enabledWifi = [([settings objectForKey:@"enabledWifi"] ?: @(YES)) boolValue];
	carrierbar0color = [([settings objectForKey:@"carrierbar0color"] ?: @(1)) intValue];
	carrierbar1color = [([settings objectForKey:@"carrierbar1color"] ?: @(2)) intValue];
	carrierbar2color = [([settings objectForKey:@"carrierbar2color"] ?: @(3)) intValue];
	carrierbar3color = [([settings objectForKey:@"carrierbar3color"] ?: @(4)) intValue];
	wifibar2color = [([settings objectForKey:@"wifibar2color"] ?: @(4)) intValue];
	wifibar1color = [([settings objectForKey:@"wifibar1color"] ?: @(3)) intValue];
	wifibar0color = [([settings objectForKey:@"wifibar0color"] ?: @(1)) intValue];
	if (lastCarrierSignalView) {
		[lastCarrierSignalView _updateBars];
		[lastCarrierSignalView pridebars_setPrideColors];
	}
	if (lastWifiSignalView) {
		[lastWifiSignalView _updateBars];
		[lastWifiSignalView pridebars_setPrideColors];
	}
}

%hook _UIStatusBarCellularSignalView
- (void)_updateActiveBars {
	%orig;
	if (enabledCarrier) [self pridebars_setPrideColors];
	lastCarrierSignalView = self;
}

- (void)_colorsDidChange {
	%orig;
	if (enabledCarrier) [self pridebars_setPrideColors];
	lastCarrierSignalView = self;
}

%new
- (void)pridebars_setPrideColors {
	if (!enabledCarrier) return;
	if (self.numberOfActiveBars >= 1) self.layer.sublayers[0].backgroundColor = getCGColorForID(carrierbar0color);
	if (self.numberOfActiveBars >= 2) self.layer.sublayers[1].backgroundColor = getCGColorForID(carrierbar1color);
	if (self.numberOfActiveBars >= 3) self.layer.sublayers[2].backgroundColor = getCGColorForID(carrierbar2color);
	if (self.numberOfActiveBars >= 4) self.layer.sublayers[3].backgroundColor = getCGColorForID(carrierbar3color);
}
%end

%hook _UIStatusBarWifiSignalView
- (void)_updateActiveBars {
	%orig;
	if (enabledWifi) [self pridebars_setPrideColors];
	lastWifiSignalView = self;
}

- (void)_colorsDidChange {
	%orig;
	if (enabledWifi) [self pridebars_setPrideColors];
	lastWifiSignalView = self;
}

%new
- (void)pridebars_setPrideColors {
	if (!enabledWifi) return;
	if (self.numberOfActiveBars >= 1) self.layer.sublayers[0].contentsMultiplyColor = getCGColorForID(wifibar0color); // first, bottom bar
	if (self.numberOfActiveBars >= 2) self.layer.sublayers[1].contentsMultiplyColor = getCGColorForID(wifibar1color);
	if (self.numberOfActiveBars >= 3) self.layer.sublayers[2].contentsMultiplyColor = getCGColorForID(wifibar2color); // top bar
}
%end

static void PreferencesChangedCallback(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
    refreshPrefs();
}

%ctor {
	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback) PreferencesChangedCallback, CFSTR("net.p0358.pridebars.prefschanged"), NULL, CFNotificationSuspensionBehaviorCoalesce);
	refreshPrefs();
	%init;
}
