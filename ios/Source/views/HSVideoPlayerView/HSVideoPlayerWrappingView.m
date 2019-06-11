#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>
#import <React/RCTBridge.h>
#import <React/RCTUIManager.h>

#import "HSReactNativeMedia-Swift.h"
#import "HSVideoPlayerWrappingView.h"
#import "RCTConvert+UIImageOrientation.h"

@implementation HSVideoPlayerWrappingView
@synthesize playerView;

- (instancetype)init {
  self = [super init];
  if (self) {
    playerView = [[HSVideoPlayerView alloc] init];
    playerView.delegate = self;
    [self addSubview:playerView];
  }
  return self;
}

- (void)layoutSubviews {
  [super layoutSubviews];
  playerView.frame = self.bounds;
}

- (void)removeFromSuperview {
  [super removeFromSuperview];
  [playerView stop];
}

#pragma mark - HSVideoPlayerViewDelegate

- (NSString *)stringForImageOrientation:(UIImageOrientation)orientation {
  NSDictionary *orientationToStringMap = @{
    @(UIImageOrientationUp) : @"up",
    @(UIImageOrientationUpMirrored) : @"upMirrored",
    @(UIImageOrientationDown) : @"down",
    @(UIImageOrientationDownMirrored) : @"downMirrored",
    @(UIImageOrientationLeft) : @"left",
    @(UIImageOrientationLeftMirrored) : @"leftMirrored",
    @(UIImageOrientationRight) : @"right",
    @(UIImageOrientationRightMirrored) : @"rightMirrored",
  };
  NSString *orientationStr =
      [orientationToStringMap objectForKey:@(orientation)];
  if (!orientationStr) {
    return [orientationToStringMap objectForKey:@(UIImageOrientationUp)];
  }
  return orientationStr;
}

- (void)videoPlayerDidFailToLoad {
  if (!self.onVideoDidFailToLoad) {
    return;
  }
  self.onVideoDidFailToLoad(@{});
}

- (void)videoPlayerDidBecomeReadyToPlayAsset:(AVAsset *)asset {
  [asset loadValuesAsynchronouslyForKeys:@[ @"tracks" ]
                       completionHandler:^{
                         if (!self.onVideoDidBecomeReadyToPlay) {
                           return;
                         }
                         UIImageOrientation orientation =
                             [OrientationUtil orientationForAsset:asset];
                         NSString *orientationStr =
                             [self stringForImageOrientation:orientation];
                         NSNumber *duration = [NSNumber
                             numberWithFloat:CMTimeGetSeconds(asset.duration)];
                         self.onVideoDidBecomeReadyToPlay(@{
                           @"duration" : duration,
                           @"orientation" : orientationStr
                         });
                       }];
}

- (void)videoPlayerDidPause {
  if (!self.onVideoDidPause) {
    return;
  }
  NSDictionary *body = @{};
  self.onVideoDidPause(body);
}

- (void)videoPlayerDidUpdatePlaybackTime:(CMTime)time
                                duration:(CMTime)duration {
  if (!self.onVideoDidUpdatePlaybackTime) {
    return;
  }
  NSNumber *durationNumber =
      [NSNumber numberWithFloat:CMTimeGetSeconds(duration)];
  NSNumber *playbackTimeNumber =
      [NSNumber numberWithFloat:CMTimeGetSeconds(time)];
  NSDictionary *body =
      @{@"duration" : durationNumber, @"playbackTime" : playbackTimeNumber};
  self.onVideoDidUpdatePlaybackTime(body);
}

- (void)videoPlayerDidRestartVideo {
  self.onVideoDidRestart(@{});
}

@end
