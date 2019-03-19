#import <Celestial/AVSystemController.h>
#define settingsPath [NSHomeDirectory() stringByAppendingPathComponent:@"/Library/Preferences/com.exormeter.alarmfade.plist"]
#define LOWEST_POSSIBLE_VOLUME 0.0625
#define DEFAULT_VOLUME 0.5
#define TIMER_INTERVAL 1.0



@interface MTAlarmScheduler
@property (nonatomic) float originalRingerVolume;
@property (nonatomic) float currentVolume;
@property (nonatomic) float volumeIncrement;
@property (nonatomic) float maxVolume;
@property (nonatomic) BOOL isEnabled;
@property (nonatomic) BOOL fadeIsEnabled;
@property (nonatomic) int fadeSeconds;
@property (nonatomic, assign) AVSystemController* avSystemController;
@property (nonatomic, assign) NSTimer* timer;
-(void)onTick:(NSTimer *)timer;
-(void)restoreRingerVolume;
-(void)stopTimer;
-(void)updatePreferences;
@end

@interface MTAlarmStorage
@property (assign,nonatomic,weak) MTAlarmScheduler* scheduler;
@end


%hook MTAlarmScheduler


%property (assign) float originalRingerVolume;
%property (assign) float currentVolume;
%property (assign) float maxVolume;
%property (assign) float volumeIncrement;
%property (assign) BOOL isEnabled;
%property (assign) BOOL fadeIsEnabled;
%property (assign) int fadeSeconds;
%property (nonatomic, assign) AVSystemController* avSystemController;
%property (nonatomic, assign) NSTimer* timer;

-(id)initWithStorage:(id)arg1 notificationCenter:(id)arg2 scheduler:(id)arg3{
    NSLog(@"Alarmfade Initialized");
    self.avSystemController = [%c(AVSystemController) sharedAVSystemController];
    self.originalRingerVolume = DEFAULT_VOLUME;
    self.timer = nil;

    self.isEnabled = true;
    self.fadeIsEnabled = true;
    self.fadeSeconds = 120;
    self.maxVolume = 0.5;
    return %orig;
}

-(void)_fireScheduledAlarm:(id)arg1 firedDate:(id)arg2 completionBlock:(/*^block*/id)arg3 {
    [self updatePreferences];
    if(!self.isEnabled){
        return %orig;
    }
    
    self.volumeIncrement = self.maxVolume / self.fadeSeconds;
    self.currentVolume = LOWEST_POSSIBLE_VOLUME;

    float *originalVolume  = (float*) malloc(sizeof(float));
    if(originalVolume){
        [self.avSystemController getVolume: originalVolume forCategory:@"Ringtone"];
        self.originalRingerVolume = *originalVolume;
        free(originalVolume);
    }
    
    if(self.fadeIsEnabled){
        if(self.fadeSeconds <= 0){
            return %orig;
        }
        [self.avSystemController setVolumeTo: LOWEST_POSSIBLE_VOLUME forCategory:@"Ringtone"];
    }
    else{
        [self.avSystemController setVolumeTo: self.maxVolume forCategory:@"Ringtone"];
    }
    

    if(self.timer == nil && self.fadeIsEnabled){
        dispatch_async(dispatch_get_main_queue(), ^{
            NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval: TIMER_INTERVAL
                        target: self
                        selector:@selector(onTick:)
                        userInfo: nil 
                        repeats:YES];
            self.timer = timer;
        });
    }
    

    NSLog(@"Fired Alarm");
    
    %orig;

}

%new
-(void)updatePreferences{
    NSMutableDictionary *prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:settingsPath];

    if([prefs objectForKey:@"isEnabled"] != nil){
        self.isEnabled = [[prefs objectForKey:@"isEnabled"] boolValue];
    }
    
    if ([prefs objectForKey:@"fadeIsEnabled"] != nil){
         self.fadeIsEnabled = [[prefs objectForKey:@"fadeIsEnabled"] boolValue];
    }

    if([prefs objectForKey:@"fadein"] != nil){
        self.fadeSeconds = [[prefs objectForKey:@"fadein"] intValue];
    }

    if([prefs objectForKey:@"maxVolume"] != nil){
        self.maxVolume = [[prefs objectForKey:@"maxVolume"] floatValue];
    }

    [prefs release];
}

%new
-(void)onTick:(NSTimer *)timer {
    NSLog(@"Timer active");

    if(self.currentVolume <= self.maxVolume){
        [self.avSystemController setActiveCategoryVolumeTo: self.currentVolume];
        self.currentVolume += self.volumeIncrement;
    }
    else{
        [self.timer invalidate];
        self.timer = nil;
    }
    
    
}

%new
-(void)restoreRingerVolume{
    if(self.isEnabled){
        NSLog(@"Reset Volume");
        [self.avSystemController setVolumeTo: self.originalRingerVolume forCategory:@"Ringtone"];
    }
    
}

%new
-(void)stopTimer{
    NSLog(@"Timer stopped");
    if(self.timer != nil && [self.timer isValid]){
        [self.timer invalidate];
        self.timer = nil;
    }
    
}

%end




%hook MTAlarmStorage



-(void)dismissAlarmWithIdentifier:(id)arg1 dismissDate:(id)arg2 dismissAction:(unsigned long long)arg3 withCompletion:(/*^block*/id)arg4 source:(id)arg5{
    [self.scheduler stopTimer];
    [self.scheduler restoreRingerVolume]; 
    NSLog(@"Dissmissed Alarm");
    return %orig;
}

-(void)snoozeAlarmWithIdentifier:(id)arg1 snoozeAction:(unsigned long long)arg2 withCompletion:(/*^block*/id)arg3 source:(id)arg4{
    [self.scheduler stopTimer];
    [self.scheduler restoreRingerVolume]; 
    NSLog(@"Snoozed Alarm");
    return %orig;
}

%end