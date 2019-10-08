#import "HSReactNativeMedia-Swift.h"
#import <React/RCTConvert.h>

@implementation RCTConvert (HSVideoPlaybackState)

RCT_ENUM_CONVERTER(HSVideoPlaybackState, (@{
                     @"playing" : @(HSVideoPlaybackStatePlaying),
                     @"paused" : @(HSVideoPlaybackStatePaused),
                     @"waiting" : @(HSVideoPlaybackStateWaiting),
                     @"readyToPlay" : @(HSVideoPlaybackStateReadyToPlay)
                   }),
                   HSVideoPlaybackStateWaiting, integerValue)

@end
