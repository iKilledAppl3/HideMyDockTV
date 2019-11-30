// Created by J.K. Hayslip (iKilledAppl3) on November 18,2019
// Pretty simple code :P
// Anyways here have fun!

#import <UIKit/UIKit.h>


// Settings toggles
BOOL kEnabled;

// plist where user settings are stored.
#define PLIST_PATH @"/var/mobile/Library/Preferences/com.ikilledappl3.hidemydocktv.plist"


// Private headers we need.
@interface TVSUIOuterShadowView : UIImageView
@end

@interface HBUIMainAppGridDockView : UICollectionReusableView {
	TVSUIOuterShadowView *_shadowView;
}
@end