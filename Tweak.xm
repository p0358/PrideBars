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

static inline UIColor* getUIColorForID(int colorID) {
    switch (colorID) {
        case 1: return [UIColor redColor]; break;
        case 2: return [UIColor orangeColor]; break;
        case 3: return [UIColor yellowColor]; break;
        case 4: return [UIColor greenColor]; break;
        case 5: return [UIColor blueColor]; break;
        case 6: return [UIColor purpleColor]; break;
        case 7: return [UIColor blackColor]; break;
        case 8: return [UIColor brownColor]; break;
        case 9: return [UIColor cyanColor]; break;
        case 10: return [UIColor darkGrayColor]; break;
        case 11: return [UIColor grayColor]; break;
        case 12: return [UIColor lightGrayColor]; break;
        case 13: return [UIColor magentaColor]; break;
        case 14: return [UIColor whiteColor]; break;
        default: return [UIColor whiteColor]; break;
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
static BOOL tintInactiveCarrier = NO;
static BOOL tintInactiveWifi = NO;

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
	tintInactiveCarrier = [([settings objectForKey:@"tintInactiveCarrier"] ?: @(NO)) boolValue];
	tintInactiveWifi = [([settings objectForKey:@"tintInactiveWifi"] ?: @(NO)) boolValue];
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
	if (self.numberOfActiveBars >= 1) self.layer.sublayers[0].backgroundColor = getUIColorForID(carrierbar0color).CGColor;
	else if (tintInactiveCarrier) self.layer.sublayers[0].backgroundColor = [getUIColorForID(carrierbar0color) colorWithAlphaComponent:0.15].CGColor;
	if (self.numberOfActiveBars >= 2) self.layer.sublayers[1].backgroundColor = getUIColorForID(carrierbar1color).CGColor;
	else if (tintInactiveCarrier) self.layer.sublayers[1].backgroundColor = [getUIColorForID(carrierbar1color) colorWithAlphaComponent:0.15].CGColor;
	if (self.numberOfActiveBars >= 3) self.layer.sublayers[2].backgroundColor = getUIColorForID(carrierbar2color).CGColor;
	else if (tintInactiveCarrier) self.layer.sublayers[2].backgroundColor = [getUIColorForID(carrierbar2color) colorWithAlphaComponent:0.15].CGColor;
	if (self.numberOfActiveBars >= 4) self.layer.sublayers[3].backgroundColor = getUIColorForID(carrierbar3color).CGColor;
	else if (tintInactiveCarrier) self.layer.sublayers[3].backgroundColor = [getUIColorForID(carrierbar3color) colorWithAlphaComponent:0.15].CGColor;
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
	if (self.numberOfActiveBars >= 1) self.layer.sublayers[0].contentsMultiplyColor = getUIColorForID(wifibar0color).CGColor; // first, bottom bar
	else if (tintInactiveWifi) self.layer.sublayers[0].contentsMultiplyColor = [getUIColorForID(wifibar0color) colorWithAlphaComponent:0.15].CGColor;
	if (self.numberOfActiveBars >= 2) self.layer.sublayers[1].contentsMultiplyColor = getUIColorForID(wifibar1color).CGColor;
	else if (tintInactiveWifi) self.layer.sublayers[1].contentsMultiplyColor = [getUIColorForID(wifibar1color) colorWithAlphaComponent:0.15].CGColor;
	if (self.numberOfActiveBars >= 3) self.layer.sublayers[2].contentsMultiplyColor = getUIColorForID(wifibar2color).CGColor; // top bar
	else if (tintInactiveWifi) self.layer.sublayers[2].contentsMultiplyColor = [getUIColorForID(wifibar2color) colorWithAlphaComponent:0.15].CGColor;
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
