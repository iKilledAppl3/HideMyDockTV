#include "iKARootListController.h"

// statically call the item
TSKSettingItem *kEnabled;
// Respring Button
TSKSettingItem *kRespringButton;

// Make sure our path is specified so our tweak knows where to store all of the settings :)
#define PLIST_PATH @"/var/mobile/Library/Preferences/com.ikilledappl3.hidemydocktv.plist"
inline NSString *GetPrefVal(NSString *key){
    return [[NSDictionary dictionaryWithContentsOfFile:PLIST_PATH] valueForKey:key];
}


@implementation iKARootListController
// This has no purpose.
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath  {
    
}

// Lets load our prefs!
- (id)loadSettingGroups {
    
    id facade = [[NSClassFromString(@"TVSettingsPreferenceFacade") alloc] initWithDomain:@"com.ikilledappl3.hidemydocktv" notifyChanges:TRUE];
    
    NSMutableArray *_backingArray = [NSMutableArray new];
    
kEnabled = [TSKSettingItem toggleItemWithTitle:@"Enable Tweak" description:@"Enable to hide the dock." representedObject:facade keyPath:@"kEnabled" onTitle:@"Enabled" offTitle:@"Disabled"];
    
    // Respring Button here baby! No documenation found so I had to figure this one out myself :P
    kRespringButton = [TSKSettingItem actionItemWithTitle:@"Respring" description:@"Apply Changes" representedObject:facade keyPath:PLIST_PATH target:self action:@selector(doAFancyRespring)];
    
    
    TSKSettingGroup *group = [TSKSettingGroup groupWithTitle:@"Hide Dock" settingItems:@[kEnabled, kRespringButton]];
    [_backingArray addObject:group];
    
    [self setValue:_backingArray forKey:@"_settingGroups"];
    
    return _backingArray;
    
}

// Let's blur the screen before we kill PineBoard >:)
-(void)doAFancyRespring {
    self.mainAppRootWindow = [UIApplication sharedApplication].keyWindow;
    self.respringBlur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    self.respringEffectView = [[UIVisualEffectView alloc] initWithEffect:self.respringBlur];
    self.respringEffectView.frame = [[UIScreen mainScreen] bounds];
    [self.mainAppRootWindow addSubview:self.respringEffectView];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:5.0];
    [self.respringEffectView setAlpha:0];
    [UIView commitAnimations];
    [self performSelector:@selector(respring) withObject:nil afterDelay:3.0];
    
}

// this is here "resprings" the Apple TV
-(void)respring {
    NSTask *task = [[[NSTask alloc] init] autorelease];
    [task setLaunchPath:@"/usr/bin/killall"];
    [task setArguments:[NSArray arrayWithObjects:@"PineBoard", nil]];
    [task launch];
    
}

// this is to make sure our preferences our loaded
- (TVSPreferences *)ourPreferences {
    return [TVSPreferences preferencesWithDomain:@"com.ikilledappl3.hidemydocktv"];
}


// This is to show our preferences in the tweaks section of tvOS.
- (void)showViewController:(TSKSettingItem *)item {
    TSKTextInputViewController *testObject = [[TSKTextInputViewController alloc] init];
    TVSPreferences *prefs = [TVSPreferences preferencesWithDomain:@"com.ikilledappl3.hidemydocktv"];
    
    testObject.headerText = @"HideMyDockTV";
    testObject.initialText = [[self ourPreferences] stringForKey:item.keyPath];
    
    if ([testObject respondsToSelector:@selector(setEditingDelegate:)]){
        [testObject setEditingDelegate:self];
    }
    [testObject setEditingItem:item];
    [self.navigationController pushViewController:testObject animated:TRUE];
}

- (void)editingController:(id)arg1 didCancelForSettingItem:(TSKSettingItem *)arg2 {
    [super editingController:arg1 didCancelForSettingItem:arg2];
}
- (void)editingController:(id)arg1 didProvideValue:(id)arg2 forSettingItem:(TSKSettingItem *)arg3 {
    [super editingController:arg1 didProvideValue:arg2 forSettingItem:arg3];
    
    TVSPreferences *prefs = [TVSPreferences preferencesWithDomain:@"com.ikilledappl3.hidemydocktv"];
    
    [prefs setObject:arg2 forKey:arg3.keyPath];
    [prefs synchronize];
    
}


// This is to show our tweak's icon instead of the boring Apple TV logo :)
-(id)previewForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    TSKPreviewViewController *item = [super previewForItemAtIndexPath:indexPath];
    TSKSettingGroup *currentGroup = self.settingGroups[indexPath.section];
    TSKSettingItem *currentItem = currentGroup.settingItems[indexPath.row];
    
    NSString *imagePath = [[NSBundle bundleForClass:self.class] pathForResource:@"HideMyDockTV" ofType:@"png"];
    UIImage *icon = [UIImage imageWithContentsOfFile:imagePath];
    if (icon != nil) {
        TSKVibrantImageView *imageView = [[TSKVibrantImageView alloc] initWithImage:icon];
        [item setContentView:imageView];
        
    }
    
    return item;
    
}


@end
