#import "ZeldaTV.h"

NSDictionary *WiivampTVPrefs = [[[NSDictionary alloc] initWithContentsOfFile:SETTINGS_PLIST_PATH]?:[NSDictionary dictionary] copy];
NSBundle *audioPath = [NSBundle bundleWithPath:@"/Library/Application Support/ZeldaTV/"];

static BOOL TVAppStoreEnabled = (BOOL)[[WiivampTVPrefs objectForKey:@"TVAppStoreEnabled"]?:@YES boolValue];
static BOOL JailbreakEnabled = (BOOL)[[WiivampTVPrefs objectForKey:@"JailbreakEnabled"]?:@YES boolValue];
static BOOL SettingsEnabled = (BOOL)[[WiivampTVPrefs objectForKey:@"SettingsEnabled"]?:@YES boolValue];
static BOOL SearchEnabled = (BOOL)[[WiivampTVPrefs objectForKey:@"SearchEnabled"]?:@YES boolValue];
static BOOL ScreenSaverEnabled = (BOOL)[[WiivampTVPrefs objectForKey:@"ScreenSaverEnabled"]?:@YES boolValue];
static BOOL nitoTVEnabled = (BOOL)[[WiivampTVPrefs objectForKey:@"nitoTVEnabled"]?:@YES boolValue];
static BOOL TVPhotosEnabled = (BOOL)[[WiivampTVPrefs objectForKey:@"TVPhotosEnabled"]?:@YES boolValue];
static BOOL HeadBoardEnabled = (BOOL)[[WiivampTVPrefs objectForKey:@"HeadBoardEnabled"]?:@YES boolValue];
static BOOL ReprovisionEnabled = (BOOL)[[WiivampTVPrefs objectForKey:@"ReprovisionEnabled"]?:@YES boolValue];
static BOOL PongEnabled = (BOOL)[[WiivampTVPrefs objectForKey:@"PongEnabled"]?:@YES boolValue];

BOOL hasPlayedReprovision = NO;
BOOL hasPlayedScreenSaver = NO;
BOOL hasPlayedJailbreak = NO;
BOOL hasPlayedSettings = NO;
BOOL hasPlayedSearch = NO;
BOOL hasPlayedAppStore = NO;
BOOL hasPlayednitoTV = NO;
BOOL hasPlayedPhotos = NO;
BOOL hasPlayedHeadBoard = NO;
BOOL hasPlayedPong = NO;


#ifdef DEBUG
    #define DEBUGLOG(...) NSLog(__VA_ARGS__);
#else
    #define DEBUGLOG(...) {}
#endif



%hook UIViewController
- (void)viewDidAppear:(BOOL)arg1 {
    %orig;
    DEBUGLOG(@"###ZeldaTVPrefs: %@", WiivampTVPrefs);
    DEBUGLOG(@"###ZeldaTV: Main Bundle Identifier: %@", [[NSBundle mainBundle] bundleIdentifier]);

    if([[[NSBundle mainBundle] bundleIdentifier] isEqualToString:@"com.apple.TVAppStore"] && TVAppStoreEnabled && !hasPlayedAppStore) {
        [self playSong:@"shop" restartTime:CMTimeMake(7, 1)];
        hasPlayedAppStore = YES;
    }

    if([[[NSBundle mainBundle] bundleIdentifier] isEqualToString:@"ca.aerickson.TVPong"] && PongEnabled && !hasPlayedPong) {
        [self playSong:@"pong" restartTime:CMTimeMake(7, 1)];
        hasPlayedPong = YES;
    }

    if([[[NSBundle mainBundle] bundleIdentifier] isEqualToString:@"com.electrateam.ChimeraTV"] && JailbreakEnabled && !hasPlayedJailbreak) {
        [self playSong:@"jailbreak" restartTime:CMTimeMake(7, 1)];
        hasPlayedJailbreak = YES;
    }

    if([[[NSBundle mainBundle] bundleIdentifier] isEqualToString:@"com.nito.electraTV"] && JailbreakEnabled && !hasPlayedJailbreak) {
        [self playSong:@"jailbreak" restartTime:CMTimeMake(7, 1)];
        hasPlayedJailbreak = YES;
    }


    if([[[NSBundle mainBundle] bundleIdentifier] isEqualToString:@"com.matchstic.reprovision.tvos"] && ReprovisionEnabled && !hasPlayedReprovision) {
        [self playSong:@"reprovision" restartTime:CMTimeMake(7, 1)];
        hasPlayedReprovision = YES;
    }


    if([[[NSBundle mainBundle] bundleIdentifier] isEqualToString:@"com.apple.TVSettings"] && SettingsEnabled && !hasPlayedSettings) {
        [self playSong:@"settings" restartTime:CMTimeMake(8, 1)];
        hasPlayedSettings = YES;

    }

    if([[[NSBundle mainBundle] bundleIdentifier] isEqualToString:@"com.apple.TVIdleScreen"] && ScreenSaverEnabled && !hasPlayedScreenSaver) {
        [self playSong:@"screensaver" restartTime:CMTimeMake(8, 1)];
        hasPlayedScreenSaver = YES;

    }

    if([[[NSBundle mainBundle] bundleIdentifier] isEqualToString:@"com.apple.TVSearch"] && SearchEnabled && !hasPlayedSearch) {
        [self playSong:@"search" restartTime:CMTimeMake(8, 1)];
        hasPlayedSearch = YES;
    }

    if([[[NSBundle mainBundle] bundleIdentifier] isEqualToString:@"com.nito.nitoTV4"] && nitoTVEnabled && !hasPlayednitoTV) {
        [self playSong:@"nitotv" restartTime:CMTimeMake(8, 1)];
        hasPlayednitoTV = YES;
    }

    if([[[NSBundle mainBundle] bundleIdentifier] isEqualToString:@"com.apple.TVPhotos"] && TVPhotosEnabled && !hasPlayedPhotos) {
        [self playSong:@"photos" restartTime:CMTimeMake(10, 1)];
        hasPlayedPhotos = YES;  
    }

    if([[[NSBundle mainBundle] bundleIdentifier] isEqualToString:@"com.apple.HeadBoard"] && HeadBoardEnabled && !hasPlayedHeadBoard) {
        [self playSong:@"pineboard" restartTime:CMTimeMake(20, 1)];
        hasPlayedHeadBoard = YES;
    }
}
%new
- (void)playSong:(NSString *)songName restartTime:(CMTime)time {
    DEBUGLOG(@"###ZeldaTV: Playing audio: %@", songName);
    AVPlayerItem *song = [AVPlayerItem playerItemWithURL:[audioPath URLForResource:songName withExtension:@"m4a"]];
    AVPlayer *songPlayer = [[AVPlayer alloc] initWithPlayerItem:song];
    songPlayer.actionAtItemEnd = AVPlayerActionAtItemEndNone;
    NSNotificationCenter *noteCenter = [NSNotificationCenter defaultCenter];
    [noteCenter addObserverForName:AVPlayerItemDidPlayToEndTimeNotification 
                                                    object:[songPlayer currentItem] 
                                                    queue:nil 
                                                    usingBlock:^(NSNotification *note) {
                                                        [song seekToTime:time];
                                                    }];

    [noteCenter addObserverForName:UIApplicationDidEnterBackgroundNotification 
                                                    object:nil
                                                    queue:nil 
                                                    usingBlock:^(NSNotification *note) {
                                                        DEBUGLOG(@"###ZeldaTV: %@ did enter background!", [[NSBundle mainBundle] bundleIdentifier]);
                                                        [songPlayer pause];
                                                    }];

    [noteCenter addObserverForName:UIApplicationWillEnterForegroundNotification 
                                                    object:nil
                                                    queue:nil 
                                                    usingBlock:^(NSNotification *note) {
                                                        DEBUGLOG(@"###ZeldaTV: %@ did enter foreground!", [[NSBundle mainBundle] bundleIdentifier]);
                                                        usleep(1000000);
                                                        [songPlayer play];
                                                    }];

    [noteCenter addObserverForName:UIApplicationWillTerminateNotification 
                                                    object:nil
                                                    queue:nil 
                                                    usingBlock:^(NSNotification *note) {
                                                        [songPlayer release];
                                                        DEBUGLOG(@"###ZeldaTV: Released from %@!", [[NSBundle mainBundle] bundleIdentifier]);
                                                    }];
                                                    
    songPlayer.volume = 0.3;
    usleep(1000000);
    [songPlayer play];
}
%end
