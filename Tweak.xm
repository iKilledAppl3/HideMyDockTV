// Created by J.K. Hayslip (iKilledAppl3) on November 18,2019
// Pretty simple code :P
// Anyways here have fun!

@interface TVSUIOuterShadowView : UIImageView
@end

@interface HBUIMainAppGridDockView : UICollectionReusableView {
	TVSUIOuterShadowView *_shadowView;
}
@end

// This is the dock view :P 
%hook HBUIMainAppGridDockView
-(void)layoutSubviews {
	%orig;
	[self removeFromSuperview];

}
%end