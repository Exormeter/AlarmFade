#line 1 "Tweak.xm"
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



#include <substrate.h>
#if defined(__clang__)
#if __has_feature(objc_arc)
#define _LOGOS_SELF_TYPE_NORMAL __unsafe_unretained
#define _LOGOS_SELF_TYPE_INIT __attribute__((ns_consumed))
#define _LOGOS_SELF_CONST const
#define _LOGOS_RETURN_RETAINED __attribute__((ns_returns_retained))
#else
#define _LOGOS_SELF_TYPE_NORMAL
#define _LOGOS_SELF_TYPE_INIT
#define _LOGOS_SELF_CONST
#define _LOGOS_RETURN_RETAINED
#endif
#else
#define _LOGOS_SELF_TYPE_NORMAL
#define _LOGOS_SELF_TYPE_INIT
#define _LOGOS_SELF_CONST
#define _LOGOS_RETURN_RETAINED
#endif

@class MTAlarmScheduler; @class MTAlarmStorage; @class AVSystemController; 
static MTAlarmScheduler* (*_logos_orig$_ungrouped$MTAlarmScheduler$initWithStorage$notificationCenter$scheduler$)(_LOGOS_SELF_TYPE_INIT MTAlarmScheduler*, SEL, id, id, id) _LOGOS_RETURN_RETAINED; static MTAlarmScheduler* _logos_method$_ungrouped$MTAlarmScheduler$initWithStorage$notificationCenter$scheduler$(_LOGOS_SELF_TYPE_INIT MTAlarmScheduler*, SEL, id, id, id) _LOGOS_RETURN_RETAINED; static void (*_logos_orig$_ungrouped$MTAlarmScheduler$_fireScheduledAlarm$firedDate$completionBlock$)(_LOGOS_SELF_TYPE_NORMAL MTAlarmScheduler* _LOGOS_SELF_CONST, SEL, id, id, id); static void _logos_method$_ungrouped$MTAlarmScheduler$_fireScheduledAlarm$firedDate$completionBlock$(_LOGOS_SELF_TYPE_NORMAL MTAlarmScheduler* _LOGOS_SELF_CONST, SEL, id, id, id); static void _logos_method$_ungrouped$MTAlarmScheduler$updatePreferences(_LOGOS_SELF_TYPE_NORMAL MTAlarmScheduler* _LOGOS_SELF_CONST, SEL); static void _logos_method$_ungrouped$MTAlarmScheduler$onTick$(_LOGOS_SELF_TYPE_NORMAL MTAlarmScheduler* _LOGOS_SELF_CONST, SEL, NSTimer *); static void _logos_method$_ungrouped$MTAlarmScheduler$restoreRingerVolume(_LOGOS_SELF_TYPE_NORMAL MTAlarmScheduler* _LOGOS_SELF_CONST, SEL); static void _logos_method$_ungrouped$MTAlarmScheduler$stopTimer(_LOGOS_SELF_TYPE_NORMAL MTAlarmScheduler* _LOGOS_SELF_CONST, SEL); static void (*_logos_orig$_ungrouped$MTAlarmStorage$dismissAlarmWithIdentifier$dismissDate$dismissAction$withCompletion$source$)(_LOGOS_SELF_TYPE_NORMAL MTAlarmStorage* _LOGOS_SELF_CONST, SEL, id, id, unsigned long long, id, id); static void _logos_method$_ungrouped$MTAlarmStorage$dismissAlarmWithIdentifier$dismissDate$dismissAction$withCompletion$source$(_LOGOS_SELF_TYPE_NORMAL MTAlarmStorage* _LOGOS_SELF_CONST, SEL, id, id, unsigned long long, id, id); static void (*_logos_orig$_ungrouped$MTAlarmStorage$snoozeAlarmWithIdentifier$snoozeAction$withCompletion$source$)(_LOGOS_SELF_TYPE_NORMAL MTAlarmStorage* _LOGOS_SELF_CONST, SEL, id, unsigned long long, id, id); static void _logos_method$_ungrouped$MTAlarmStorage$snoozeAlarmWithIdentifier$snoozeAction$withCompletion$source$(_LOGOS_SELF_TYPE_NORMAL MTAlarmStorage* _LOGOS_SELF_CONST, SEL, id, unsigned long long, id, id); 
static __inline__ __attribute__((always_inline)) __attribute__((unused)) Class _logos_static_class_lookup$AVSystemController(void) { static Class _klass; if(!_klass) { _klass = objc_getClass("AVSystemController"); } return _klass; }
#line 30 "Tweak.xm"



__attribute__((used)) static float _logos_method$_ungrouped$MTAlarmScheduler$originalRingerVolume(MTAlarmScheduler * __unused self, SEL __unused _cmd) { NSValue * value = objc_getAssociatedObject(self, (void *)_logos_method$_ungrouped$MTAlarmScheduler$originalRingerVolume); float rawValue; [value getValue:&rawValue]; return rawValue; }; __attribute__((used)) static void _logos_method$_ungrouped$MTAlarmScheduler$setOriginalRingerVolume(MTAlarmScheduler * __unused self, SEL __unused _cmd, float rawValue) { NSValue * value = [NSValue valueWithBytes:&rawValue objCType:@encode(float)]; objc_setAssociatedObject(self, (void *)_logos_method$_ungrouped$MTAlarmScheduler$originalRingerVolume, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC); }
__attribute__((used)) static float _logos_method$_ungrouped$MTAlarmScheduler$currentVolume(MTAlarmScheduler * __unused self, SEL __unused _cmd) { NSValue * value = objc_getAssociatedObject(self, (void *)_logos_method$_ungrouped$MTAlarmScheduler$currentVolume); float rawValue; [value getValue:&rawValue]; return rawValue; }; __attribute__((used)) static void _logos_method$_ungrouped$MTAlarmScheduler$setCurrentVolume(MTAlarmScheduler * __unused self, SEL __unused _cmd, float rawValue) { NSValue * value = [NSValue valueWithBytes:&rawValue objCType:@encode(float)]; objc_setAssociatedObject(self, (void *)_logos_method$_ungrouped$MTAlarmScheduler$currentVolume, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC); }
__attribute__((used)) static float _logos_method$_ungrouped$MTAlarmScheduler$maxVolume(MTAlarmScheduler * __unused self, SEL __unused _cmd) { NSValue * value = objc_getAssociatedObject(self, (void *)_logos_method$_ungrouped$MTAlarmScheduler$maxVolume); float rawValue; [value getValue:&rawValue]; return rawValue; }; __attribute__((used)) static void _logos_method$_ungrouped$MTAlarmScheduler$setMaxVolume(MTAlarmScheduler * __unused self, SEL __unused _cmd, float rawValue) { NSValue * value = [NSValue valueWithBytes:&rawValue objCType:@encode(float)]; objc_setAssociatedObject(self, (void *)_logos_method$_ungrouped$MTAlarmScheduler$maxVolume, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC); }
__attribute__((used)) static float _logos_method$_ungrouped$MTAlarmScheduler$volumeIncrement(MTAlarmScheduler * __unused self, SEL __unused _cmd) { NSValue * value = objc_getAssociatedObject(self, (void *)_logos_method$_ungrouped$MTAlarmScheduler$volumeIncrement); float rawValue; [value getValue:&rawValue]; return rawValue; }; __attribute__((used)) static void _logos_method$_ungrouped$MTAlarmScheduler$setVolumeIncrement(MTAlarmScheduler * __unused self, SEL __unused _cmd, float rawValue) { NSValue * value = [NSValue valueWithBytes:&rawValue objCType:@encode(float)]; objc_setAssociatedObject(self, (void *)_logos_method$_ungrouped$MTAlarmScheduler$volumeIncrement, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC); }
__attribute__((used)) static BOOL _logos_method$_ungrouped$MTAlarmScheduler$isEnabled(MTAlarmScheduler * __unused self, SEL __unused _cmd) { NSValue * value = objc_getAssociatedObject(self, (void *)_logos_method$_ungrouped$MTAlarmScheduler$isEnabled); BOOL rawValue; [value getValue:&rawValue]; return rawValue; }; __attribute__((used)) static void _logos_method$_ungrouped$MTAlarmScheduler$setIsEnabled(MTAlarmScheduler * __unused self, SEL __unused _cmd, BOOL rawValue) { NSValue * value = [NSValue valueWithBytes:&rawValue objCType:@encode(BOOL)]; objc_setAssociatedObject(self, (void *)_logos_method$_ungrouped$MTAlarmScheduler$isEnabled, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC); }
__attribute__((used)) static BOOL _logos_method$_ungrouped$MTAlarmScheduler$fadeIsEnabled(MTAlarmScheduler * __unused self, SEL __unused _cmd) { NSValue * value = objc_getAssociatedObject(self, (void *)_logos_method$_ungrouped$MTAlarmScheduler$fadeIsEnabled); BOOL rawValue; [value getValue:&rawValue]; return rawValue; }; __attribute__((used)) static void _logos_method$_ungrouped$MTAlarmScheduler$setFadeIsEnabled(MTAlarmScheduler * __unused self, SEL __unused _cmd, BOOL rawValue) { NSValue * value = [NSValue valueWithBytes:&rawValue objCType:@encode(BOOL)]; objc_setAssociatedObject(self, (void *)_logos_method$_ungrouped$MTAlarmScheduler$fadeIsEnabled, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC); }
__attribute__((used)) static int _logos_method$_ungrouped$MTAlarmScheduler$fadeSeconds(MTAlarmScheduler * __unused self, SEL __unused _cmd) { NSValue * value = objc_getAssociatedObject(self, (void *)_logos_method$_ungrouped$MTAlarmScheduler$fadeSeconds); int rawValue; [value getValue:&rawValue]; return rawValue; }; __attribute__((used)) static void _logos_method$_ungrouped$MTAlarmScheduler$setFadeSeconds(MTAlarmScheduler * __unused self, SEL __unused _cmd, int rawValue) { NSValue * value = [NSValue valueWithBytes:&rawValue objCType:@encode(int)]; objc_setAssociatedObject(self, (void *)_logos_method$_ungrouped$MTAlarmScheduler$fadeSeconds, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC); }
__attribute__((used)) static AVSystemController* _logos_method$_ungrouped$MTAlarmScheduler$avSystemController(MTAlarmScheduler * __unused self, SEL __unused _cmd) { NSValue * value = objc_getAssociatedObject(self, (void *)_logos_method$_ungrouped$MTAlarmScheduler$avSystemController); AVSystemController* rawValue; [value getValue:&rawValue]; return rawValue; }; __attribute__((used)) static void _logos_method$_ungrouped$MTAlarmScheduler$setAvSystemController(MTAlarmScheduler * __unused self, SEL __unused _cmd, AVSystemController* rawValue) { NSValue * value = [NSValue valueWithBytes:&rawValue objCType:@encode(AVSystemController*)]; objc_setAssociatedObject(self, (void *)_logos_method$_ungrouped$MTAlarmScheduler$avSystemController, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC); }
__attribute__((used)) static NSTimer* _logos_method$_ungrouped$MTAlarmScheduler$timer(MTAlarmScheduler * __unused self, SEL __unused _cmd) { NSValue * value = objc_getAssociatedObject(self, (void *)_logos_method$_ungrouped$MTAlarmScheduler$timer); NSTimer* rawValue; [value getValue:&rawValue]; return rawValue; }; __attribute__((used)) static void _logos_method$_ungrouped$MTAlarmScheduler$setTimer(MTAlarmScheduler * __unused self, SEL __unused _cmd, NSTimer* rawValue) { NSValue * value = [NSValue valueWithBytes:&rawValue objCType:@encode(NSTimer*)]; objc_setAssociatedObject(self, (void *)_logos_method$_ungrouped$MTAlarmScheduler$timer, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC); }

static MTAlarmScheduler* _logos_method$_ungrouped$MTAlarmScheduler$initWithStorage$notificationCenter$scheduler$(_LOGOS_SELF_TYPE_INIT MTAlarmScheduler* __unused self, SEL __unused _cmd, id arg1, id arg2, id arg3) _LOGOS_RETURN_RETAINED{
    NSLog(@"Alarmfade Initialized");
    self.avSystemController = [_logos_static_class_lookup$AVSystemController() sharedAVSystemController];
    self.originalRingerVolume = DEFAULT_VOLUME;
    self.timer = nil;

    self.isEnabled = true;
    self.fadeIsEnabled = true;
    self.fadeSeconds = 120;
    self.maxVolume = 0.5;
    return _logos_orig$_ungrouped$MTAlarmScheduler$initWithStorage$notificationCenter$scheduler$(self, _cmd, arg1, arg2, arg3);
}

static void _logos_method$_ungrouped$MTAlarmScheduler$_fireScheduledAlarm$firedDate$completionBlock$(_LOGOS_SELF_TYPE_NORMAL MTAlarmScheduler* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, id arg1, id arg2, id arg3) {
    [self updatePreferences];
    if(!self.isEnabled){
        return _logos_orig$_ungrouped$MTAlarmScheduler$_fireScheduledAlarm$firedDate$completionBlock$(self, _cmd, arg1, arg2, arg3);
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
            return _logos_orig$_ungrouped$MTAlarmScheduler$_fireScheduledAlarm$firedDate$completionBlock$(self, _cmd, arg1, arg2, arg3);
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
    
    _logos_orig$_ungrouped$MTAlarmScheduler$_fireScheduledAlarm$firedDate$completionBlock$(self, _cmd, arg1, arg2, arg3);

}


static void _logos_method$_ungrouped$MTAlarmScheduler$updatePreferences(_LOGOS_SELF_TYPE_NORMAL MTAlarmScheduler* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd){
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


static void _logos_method$_ungrouped$MTAlarmScheduler$onTick$(_LOGOS_SELF_TYPE_NORMAL MTAlarmScheduler* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, NSTimer * timer) {
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


static void _logos_method$_ungrouped$MTAlarmScheduler$restoreRingerVolume(_LOGOS_SELF_TYPE_NORMAL MTAlarmScheduler* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd){
    if(self.isEnabled){
        NSLog(@"Reset Volume");
        [self.avSystemController setVolumeTo: self.originalRingerVolume forCategory:@"Ringtone"];
    }
    
}


static void _logos_method$_ungrouped$MTAlarmScheduler$stopTimer(_LOGOS_SELF_TYPE_NORMAL MTAlarmScheduler* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd){
    NSLog(@"Timer stopped");
    if(self.timer != nil && [self.timer isValid]){
        [self.timer invalidate];
        self.timer = nil;
    }
    
}










static void _logos_method$_ungrouped$MTAlarmStorage$dismissAlarmWithIdentifier$dismissDate$dismissAction$withCompletion$source$(_LOGOS_SELF_TYPE_NORMAL MTAlarmStorage* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, id arg1, id arg2, unsigned long long arg3, id arg4, id arg5){
    [self.scheduler stopTimer];
    [self.scheduler restoreRingerVolume]; 
    NSLog(@"Dissmissed Alarm");
    return _logos_orig$_ungrouped$MTAlarmStorage$dismissAlarmWithIdentifier$dismissDate$dismissAction$withCompletion$source$(self, _cmd, arg1, arg2, arg3, arg4, arg5);
}

static void _logos_method$_ungrouped$MTAlarmStorage$snoozeAlarmWithIdentifier$snoozeAction$withCompletion$source$(_LOGOS_SELF_TYPE_NORMAL MTAlarmStorage* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, id arg1, unsigned long long arg2, id arg3, id arg4){
    [self.scheduler stopTimer];
    [self.scheduler restoreRingerVolume]; 
    NSLog(@"Snoozed Alarm");
    return _logos_orig$_ungrouped$MTAlarmStorage$snoozeAlarmWithIdentifier$snoozeAction$withCompletion$source$(self, _cmd, arg1, arg2, arg3, arg4);
}


static __attribute__((constructor)) void _logosLocalInit() {
{Class _logos_class$_ungrouped$MTAlarmScheduler = objc_getClass("MTAlarmScheduler"); MSHookMessageEx(_logos_class$_ungrouped$MTAlarmScheduler, @selector(initWithStorage:notificationCenter:scheduler:), (IMP)&_logos_method$_ungrouped$MTAlarmScheduler$initWithStorage$notificationCenter$scheduler$, (IMP*)&_logos_orig$_ungrouped$MTAlarmScheduler$initWithStorage$notificationCenter$scheduler$);MSHookMessageEx(_logos_class$_ungrouped$MTAlarmScheduler, @selector(_fireScheduledAlarm:firedDate:completionBlock:), (IMP)&_logos_method$_ungrouped$MTAlarmScheduler$_fireScheduledAlarm$firedDate$completionBlock$, (IMP*)&_logos_orig$_ungrouped$MTAlarmScheduler$_fireScheduledAlarm$firedDate$completionBlock$);{ char _typeEncoding[1024]; unsigned int i = 0; _typeEncoding[i] = 'v'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$MTAlarmScheduler, @selector(updatePreferences), (IMP)&_logos_method$_ungrouped$MTAlarmScheduler$updatePreferences, _typeEncoding); }{ char _typeEncoding[1024]; unsigned int i = 0; _typeEncoding[i] = 'v'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; memcpy(_typeEncoding + i, @encode(NSTimer *), strlen(@encode(NSTimer *))); i += strlen(@encode(NSTimer *)); _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$MTAlarmScheduler, @selector(onTick:), (IMP)&_logos_method$_ungrouped$MTAlarmScheduler$onTick$, _typeEncoding); }{ char _typeEncoding[1024]; unsigned int i = 0; _typeEncoding[i] = 'v'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$MTAlarmScheduler, @selector(restoreRingerVolume), (IMP)&_logos_method$_ungrouped$MTAlarmScheduler$restoreRingerVolume, _typeEncoding); }{ char _typeEncoding[1024]; unsigned int i = 0; _typeEncoding[i] = 'v'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$MTAlarmScheduler, @selector(stopTimer), (IMP)&_logos_method$_ungrouped$MTAlarmScheduler$stopTimer, _typeEncoding); }{ char _typeEncoding[1024]; sprintf(_typeEncoding, "%s@:", @encode(float)); class_addMethod(_logos_class$_ungrouped$MTAlarmScheduler, @selector(originalRingerVolume), (IMP)&_logos_method$_ungrouped$MTAlarmScheduler$originalRingerVolume, _typeEncoding); sprintf(_typeEncoding, "v@:%s", @encode(float)); class_addMethod(_logos_class$_ungrouped$MTAlarmScheduler, @selector(setOriginalRingerVolume:), (IMP)&_logos_method$_ungrouped$MTAlarmScheduler$setOriginalRingerVolume, _typeEncoding); } { char _typeEncoding[1024]; sprintf(_typeEncoding, "%s@:", @encode(float)); class_addMethod(_logos_class$_ungrouped$MTAlarmScheduler, @selector(currentVolume), (IMP)&_logos_method$_ungrouped$MTAlarmScheduler$currentVolume, _typeEncoding); sprintf(_typeEncoding, "v@:%s", @encode(float)); class_addMethod(_logos_class$_ungrouped$MTAlarmScheduler, @selector(setCurrentVolume:), (IMP)&_logos_method$_ungrouped$MTAlarmScheduler$setCurrentVolume, _typeEncoding); } { char _typeEncoding[1024]; sprintf(_typeEncoding, "%s@:", @encode(float)); class_addMethod(_logos_class$_ungrouped$MTAlarmScheduler, @selector(maxVolume), (IMP)&_logos_method$_ungrouped$MTAlarmScheduler$maxVolume, _typeEncoding); sprintf(_typeEncoding, "v@:%s", @encode(float)); class_addMethod(_logos_class$_ungrouped$MTAlarmScheduler, @selector(setMaxVolume:), (IMP)&_logos_method$_ungrouped$MTAlarmScheduler$setMaxVolume, _typeEncoding); } { char _typeEncoding[1024]; sprintf(_typeEncoding, "%s@:", @encode(float)); class_addMethod(_logos_class$_ungrouped$MTAlarmScheduler, @selector(volumeIncrement), (IMP)&_logos_method$_ungrouped$MTAlarmScheduler$volumeIncrement, _typeEncoding); sprintf(_typeEncoding, "v@:%s", @encode(float)); class_addMethod(_logos_class$_ungrouped$MTAlarmScheduler, @selector(setVolumeIncrement:), (IMP)&_logos_method$_ungrouped$MTAlarmScheduler$setVolumeIncrement, _typeEncoding); } { char _typeEncoding[1024]; sprintf(_typeEncoding, "%s@:", @encode(BOOL)); class_addMethod(_logos_class$_ungrouped$MTAlarmScheduler, @selector(isEnabled), (IMP)&_logos_method$_ungrouped$MTAlarmScheduler$isEnabled, _typeEncoding); sprintf(_typeEncoding, "v@:%s", @encode(BOOL)); class_addMethod(_logos_class$_ungrouped$MTAlarmScheduler, @selector(setIsEnabled:), (IMP)&_logos_method$_ungrouped$MTAlarmScheduler$setIsEnabled, _typeEncoding); } { char _typeEncoding[1024]; sprintf(_typeEncoding, "%s@:", @encode(BOOL)); class_addMethod(_logos_class$_ungrouped$MTAlarmScheduler, @selector(fadeIsEnabled), (IMP)&_logos_method$_ungrouped$MTAlarmScheduler$fadeIsEnabled, _typeEncoding); sprintf(_typeEncoding, "v@:%s", @encode(BOOL)); class_addMethod(_logos_class$_ungrouped$MTAlarmScheduler, @selector(setFadeIsEnabled:), (IMP)&_logos_method$_ungrouped$MTAlarmScheduler$setFadeIsEnabled, _typeEncoding); } { char _typeEncoding[1024]; sprintf(_typeEncoding, "%s@:", @encode(int)); class_addMethod(_logos_class$_ungrouped$MTAlarmScheduler, @selector(fadeSeconds), (IMP)&_logos_method$_ungrouped$MTAlarmScheduler$fadeSeconds, _typeEncoding); sprintf(_typeEncoding, "v@:%s", @encode(int)); class_addMethod(_logos_class$_ungrouped$MTAlarmScheduler, @selector(setFadeSeconds:), (IMP)&_logos_method$_ungrouped$MTAlarmScheduler$setFadeSeconds, _typeEncoding); } { char _typeEncoding[1024]; sprintf(_typeEncoding, "%s@:", @encode(AVSystemController*)); class_addMethod(_logos_class$_ungrouped$MTAlarmScheduler, @selector(avSystemController), (IMP)&_logos_method$_ungrouped$MTAlarmScheduler$avSystemController, _typeEncoding); sprintf(_typeEncoding, "v@:%s", @encode(AVSystemController*)); class_addMethod(_logos_class$_ungrouped$MTAlarmScheduler, @selector(setAvSystemController:), (IMP)&_logos_method$_ungrouped$MTAlarmScheduler$setAvSystemController, _typeEncoding); } { char _typeEncoding[1024]; sprintf(_typeEncoding, "%s@:", @encode(NSTimer*)); class_addMethod(_logos_class$_ungrouped$MTAlarmScheduler, @selector(timer), (IMP)&_logos_method$_ungrouped$MTAlarmScheduler$timer, _typeEncoding); sprintf(_typeEncoding, "v@:%s", @encode(NSTimer*)); class_addMethod(_logos_class$_ungrouped$MTAlarmScheduler, @selector(setTimer:), (IMP)&_logos_method$_ungrouped$MTAlarmScheduler$setTimer, _typeEncoding); } Class _logos_class$_ungrouped$MTAlarmStorage = objc_getClass("MTAlarmStorage"); MSHookMessageEx(_logos_class$_ungrouped$MTAlarmStorage, @selector(dismissAlarmWithIdentifier:dismissDate:dismissAction:withCompletion:source:), (IMP)&_logos_method$_ungrouped$MTAlarmStorage$dismissAlarmWithIdentifier$dismissDate$dismissAction$withCompletion$source$, (IMP*)&_logos_orig$_ungrouped$MTAlarmStorage$dismissAlarmWithIdentifier$dismissDate$dismissAction$withCompletion$source$);MSHookMessageEx(_logos_class$_ungrouped$MTAlarmStorage, @selector(snoozeAlarmWithIdentifier:snoozeAction:withCompletion:source:), (IMP)&_logos_method$_ungrouped$MTAlarmStorage$snoozeAlarmWithIdentifier$snoozeAction$withCompletion$source$, (IMP*)&_logos_orig$_ungrouped$MTAlarmStorage$snoozeAlarmWithIdentifier$snoozeAction$withCompletion$source$);} }
#line 183 "Tweak.xm"
