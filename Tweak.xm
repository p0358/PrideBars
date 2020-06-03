#define kOriginalBarCount 4

static NSArray<UIColor *> *colours;

@interface _UIStatusBarSignalView : UIView
@property (nonatomic, assign) NSInteger pridebars_maxBarStrength;
@property (assign,nonatomic) NSInteger numberOfBars;
@property (assign,nonatomic) NSInteger numberOfActiveBars;
- (void)pridebars_setPrideColors;
@end

@interface _UIStatusBarCellularSignalView : _UIStatusBarSignalView
// Sublayers are CALayers
// Set the color by modifying the sublayer's backgroundColor
@end

%hook _UIStatusBarCellularSignalView

- (void)_updateActiveBars {
	%orig;
	[self pridebars_setPrideColors];
}

- (void)_colorsDidChange {
	%orig;
	[self pridebars_setPrideColors];
}

%new
- (void)pridebars_setPrideColors {
	for (int i = 0; i < self.numberOfBars; i++) {
		if (i <= self.numberOfActiveBars) // let inactive bars stay gray
			self.layer.sublayers[i].backgroundColor = [colours[i] colorWithAlphaComponent: 1].CGColor;
	}
}

%end

%ctor {
	colours = @[[UIColor redColor], [UIColor orangeColor], [UIColor yellowColor], [UIColor greenColor]]; // [UIColor blueColor] // [UIColor purpleColor]
	%init;
}
