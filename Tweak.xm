// Created by J.K. Hayslip (iKilledAppl3) on November 18,2019
// Pretty simple code :P
// Anyways here have fun!

@interface TVSUIOuterShadowView : UIImageView
@end

@interface HBUIMainAppGridDockView : UICollectionReusableView {
	TVSUIOuterShadowView *_shadowView;
}
@end

BOOL kEnabled;

#define PLIST_PATH @"/var/mobile/Library/Preferences/com.ikilledappl3.hidemydocktv.plist"

// This is the dock view :P 
%hook HBUIMainAppGridDockView
-(void)layoutSubviews {
	if (kEnabled) {
		%orig;
	[self removeFromSuperview];
	}

	else {
		%orig;
	}

}
%end

// Load preferences to make sure changes are written to the plist
static void loadPrefs() {

	NSMutableDictionary *prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:PLIST_PATH];
  
	  //our preference values that write to a plist file when a user selects somethings
	kEnabled = [([prefs objectForKey:@"kEnabled"] ?: @(YES)) boolValue];
}

%ctor {
	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback) loadPrefs, CFSTR("com.ikilledappl3.hidemydocktv.prefschanged"), NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
	loadPrefs();
}