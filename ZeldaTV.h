#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

#define SETTINGS_PLIST_PATH @"/var/mobile/Library/Preferences/com.JoshTV.ZeldaTV.plist"

@interface UIViewController (ZeldaTV)
- (void)playSong:(NSString *)songName restartTime:(CMTime)time;
- (void)viewDidAppear:(BOOL)arg1;
@end
