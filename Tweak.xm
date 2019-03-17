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
@property (nonatomic, assign) AVSystemController* avSystemController;
@property (nonatomic, assign) NSTimer* timer;
-(void)onTick:(NSTimer *)timer;
-(void)restoreRingerVolume;
-(void)stopTimer;
@end

@interface MTAlarmStorage
@property (assign,nonatomic,weak) MTAlarmScheduler* scheduler;
@end


%hook MTAlarmScheduler


%property (assign) float originalRingerVolume;
%property (assign) float currentVolume;
%property (assign) float maxVolume;
%property (assign) float volumeIncrement;
%property (nonatomic, assign) AVSystemController* avSystemController;
%property (nonatomic, assign) NSTimer* timer;

-(id)initWithStorage:(id)arg1 notificationCenter:(id)arg2 scheduler:(id)arg3{
    NSLog(@"Alarmfade Initialized");
    self.avSystemController = [%c(AVSystemController) sharedAVSystemController];
    self.originalRingerVolume = DEFAULT_VOLUME;
    self.timer = nil;
    return %orig;
}

-(void)_fireScheduledAlarm:(id)arg1 firedDate:(id)arg2 completionBlock:(/*^block*/id)arg3 {
    NSMutableDictionary *prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:settingsPath];
    BOOL isEnabled = [[prefs objectForKey:@"isEnabled"] boolValue];
    BOOL fadeIsEnabled = [[prefs objectForKey:@"fadeIsEnabled"] boolValue];
    if(!isEnabled){
        return %orig;
    }

    int fadeSeconds = [[prefs objectForKey:@"fadein"] intValue];
    self.maxVolume = [[prefs objectForKey:@"maxVolume"] floatValue];

    
    self.volumeIncrement = self.maxVolume / fadeSeconds;
    self.currentVolume = LOWEST_POSSIBLE_VOLUME;

    float *originalVolume  = (float*) malloc(sizeof(float));
    if(originalVolume){
        [self.avSystemController getVolume: originalVolume forCategory:@"Ringtone"];
        self.originalRingerVolume = *originalVolume;
        free(originalVolume);
    }
    
    if(fadeIsEnabled){
        if(fadeSeconds <= 0){
            return %orig;
        }
        [self.avSystemController setVolumeTo: LOWEST_POSSIBLE_VOLUME forCategory:@"Ringtone"];
    }
    else{
        [self.avSystemController setVolumeTo: self.maxVolume forCategory:@"Ringtone"];
    }
    

    if(self.timer == nil && fadeIsEnabled){
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
    [prefs release];
    %orig;

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
    NSMutableDictionary *prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:settingsPath];
    BOOL isEnabled = [[prefs objectForKey:@"isEnabled"] boolValue];
    if(isEnabled){
        NSLog(@"Reset Volume");
        [self.avSystemController setVolumeTo: self.originalRingerVolume forCategory:@"Ringtone"];
    }
    [prefs release];
    
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