#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>
#import <React/RCTBridge.h>
#import <React/RCTUIManager.h>

#import "HSReactNativeMedia-Swift.h"
#import "HSVideoPlayerViewManager.h"
#import "RCTConvert+UIImageOrientation.h"

@implementation HSVideoPlayerViewManager

RCT_EXPORT_MODULE()

- (NSDictionary *)constantsToExport {
  return @{
    @"up" : @(UIImageOrientationUp),
    @"upMirrored" : @(UIImageOrientationUpMirrored),
    @"down" : @(UIImageOrientationDown),
    @"downMirrored" : @(UIImageOrientationDownMirrored),
    @"left" : @(UIImageOrientationLeft),
    @"leftMirrored" : @(UIImageOrientationLeftMirrored),
    @"right" : @(UIImageOrientationRight),
    @"rightMirrored" : @(UIImageOrientationRightMirrored),
  };
}

+ (BOOL)requiresMainQueueSetup {
  return NO;
}

RCT_EXPORT_VIEW_PROPERTY(playbackEventThrottle, float)
RCT_EXPORT_VIEW_PROPERTY(onVideoDidFailToLoad, RCTDirectEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onVideoDidPlayToEnd, RCTDirectEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onPlaybackStateDidChange, RCTDirectEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onPlaybackTimeDidUpdate, RCTDirectEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onOrientationDidLoad, RCTDirectEventBlock)

RCT_EXPORT_METHOD(play : (nonnull NSNumber *)reactTag) {
  [self.bridge.uiManager
      addUIBlock:^(RCTUIManager *uiManager,
                   NSDictionary<NSNumber *, UIView *> *viewRegistry) {
        HSVideoPlayerBridgeView *view =
            (HSVideoPlayerBridgeView *)viewRegistry[reactTag];
        if (!view || ![view isKindOfClass:[HSVideoPlayerBridgeView class]]) {
          RCTLogError(@"Cannot find HSVideoPlayerBridgeView with tag #%@",
                      reactTag);
          return;
        }
        [view play];
      }];
}

RCT_EXPORT_METHOD(pause : (nonnull NSNumber *)reactTag) {
  [self.bridge.uiManager
      addUIBlock:^(RCTUIManager *uiManager,
                   NSDictionary<NSNumber *, UIView *> *viewRegistry) {
        HSVideoPlayerBridgeView *view =
            (HSVideoPlayerBridgeView *)viewRegistry[reactTag];
        if (!view || ![view isKindOfClass:[HSVideoPlayerBridgeView class]]) {
          RCTLogError(@"Cannot find HSVideoPlayerBridgeView with tag #%@",
                      reactTag);
          return;
        }
        [view pause];
      }];
}

RCT_EXPORT_METHOD(restart
                  : (nonnull NSNumber *)reactTag callback
                  : (RCTResponseSenderBlock)callback) {
  [self.bridge.uiManager
      addUIBlock:^(RCTUIManager *uiManager,
                   NSDictionary<NSNumber *, UIView *> *viewRegistry) {
        HSVideoPlayerBridgeView *view =
            (HSVideoPlayerBridgeView *)viewRegistry[reactTag];
        if (!view || ![view isKindOfClass:[HSVideoPlayerBridgeView class]]) {
          RCTLogError(@"Cannot find HSVideoPlayerBridgeView with tag #%@",
                      reactTag);
          return;
        }
        [view restartWithCompletionHandler:^(BOOL success) {
          callback(@[ [NSNull null], @(success) ]);
        }];
      }];
}

RCT_EXPORT_METHOD(seekToTime
                  : (nonnull NSNumber *)reactTag time
                  : (nonnull NSNumber *)seekTime
                  : (RCTResponseSenderBlock)callback) {
  [self.bridge.uiManager
      addUIBlock:^(RCTUIManager *uiManager,
                   NSDictionary<NSNumber *, UIView *> *viewRegistry) {
        HSVideoPlayerBridgeView *view =
            (HSVideoPlayerBridgeView *)viewRegistry[reactTag];
        if (!view || ![view isKindOfClass:[HSVideoPlayerBridgeView class]]) {
          RCTLogError(@"Cannot find HSVideoPlayerBridgeView with tag #%@",
                      reactTag);
          return;
        }
        CMTime time = CMTimeMakeWithSeconds([seekTime floatValue], 600);
        [view seekTo:time
            completionHandler:^(BOOL success) {
              callback(@[ [NSNull null], @(success) ]);
            }];
      }];
}

RCT_CUSTOM_VIEW_PROPERTY(assetID, NSString, UIView) {
  NSString *assetID = [RCTConvert NSString:json];
  if (!view || ![view isKindOfClass:[HSVideoPlayerBridgeView class]]) {
    RCTLogError(@"Cannot find HSVideoPlayerBridgeView");
    return;
  }
  HSVideoPlayerBridgeView *bridgeView = (HSVideoPlayerBridgeView *)view;
  [bridgeView loadAssetWithAssetID:assetID
                 completionHandler:^(AVAsset *_Nullable asset) {
                   bridgeView.asset = asset;
                   if (!asset) {
                     return;
                   }
                   UIImageOrientation orientation =
                       [OrientationUtil orientationForAsset:asset];
                   NSDictionary *conversionDict = @{
                     @(UIImageOrientationUp) : @"up",
                     @(UIImageOrientationUpMirrored) : @"upMirrored",
                     @(UIImageOrientationDown) : @"down",
                     @(UIImageOrientationDownMirrored) : @"downMirrored",
                     @(UIImageOrientationLeft) : @"left",
                     @(UIImageOrientationLeftMirrored) : @"leftMirrored",
                     @(UIImageOrientationRight) : @"right",
                     @(UIImageOrientationRightMirrored) : @"rightMirrored",
                   };
                   NSString *orientationString =
                       [conversionDict objectForKey:@(orientation)];
                   if (bridgeView.onOrientationDidLoad) {
                     NSArray<AVAssetTrack *> *videoTracks =
                         [asset tracksWithMediaType:AVMediaTypeVideo];
                     if (videoTracks.count > 0) {
                       AVAssetTrack *videoTrack = videoTracks[0];
                       bridgeView.onOrientationDidLoad(@{
                         @"orientation" : orientationString,
                         @"dimensions" : @{
                           @"width" : @(videoTrack.naturalSize.width),
                           @"height" : @(videoTrack.naturalSize.height)
                         }
                       });
                     }
                   }
                 }];
}

- (UIView *)view {
  HSVideoPlayerBridgeView *view = [[HSVideoPlayerBridgeView alloc] init];
  view.delegate = self;
  return view;
}

#pragma MARK - HSVideoPlayerViewDelegate methods

- (void)videoPlayerView:(HSVideoPlayerView *)view
    didChangePlaybackState:(enum HSVideoPlaybackState)playbackState {
  if (![view isKindOfClass:[HSVideoPlayerBridgeView class]]) {
    return;
  }
  HSVideoPlayerBridgeView *bridgeView = (HSVideoPlayerBridgeView *)view;
  if (bridgeView.onPlaybackStateDidChange) {
    NSDictionary *conversionDict = @{
      @(HSVideoPlaybackStatePlaying) : @"playing",
      @(HSVideoPlaybackStatePaused) : @"paused",
      @(HSVideoPlaybackStateWaiting) : @"waiting",
      @(HSVideoPlaybackStateReadyToPlay) : @"readyToPlay",
    };
    NSString *playbackStateKey = [conversionDict objectForKey:@(playbackState)];
    if (bridgeView.onPlaybackStateDidChange) {
      bridgeView.onPlaybackStateDidChange(
          @{@"playbackState" : playbackStateKey});
    }
  }
}

- (void)videoPlayerView:(HSVideoPlayerView *_Nonnull)view
    didUpdatePlaybackTime:(CMTime)time
                 duration:(CMTime)duration {
  if (![view isKindOfClass:[HSVideoPlayerBridgeView class]]) {
    return;
  }
  HSVideoPlayerBridgeView *bridgeView = (HSVideoPlayerBridgeView *)view;
  NSNumber *durationNumber =
      [NSNumber numberWithFloat:CMTimeGetSeconds(duration)];
  NSNumber *playbackTimeNumber =
      [NSNumber numberWithFloat:CMTimeGetSeconds(time)];
  NSDictionary *body =
      @{@"duration" : durationNumber, @"playbackTime" : playbackTimeNumber};
  if (bridgeView.onPlaybackTimeDidUpdate) {
    bridgeView.onPlaybackTimeDidUpdate(body);
  }
}

- (void)videoPlayerViewDidFailToLoad:(HSVideoPlayerView *_Nonnull)view {
  if (![view isKindOfClass:[HSVideoPlayerBridgeView class]]) {
    return;
  }
  HSVideoPlayerBridgeView *bridgeView = (HSVideoPlayerBridgeView *)view;
  if (bridgeView.onVideoDidFailToLoad) {
    bridgeView.onVideoDidFailToLoad(@{});
  }
}

- (void)videoPlayerViewDidPlayToEnd:(HSVideoPlayerView *_Nonnull)view {
  if (![view isKindOfClass:[HSVideoPlayerBridgeView class]]) {
    return;
  }
  HSVideoPlayerBridgeView *bridgeView = (HSVideoPlayerBridgeView *)view;
  if (bridgeView.onVideoDidPlayToEnd) {
    bridgeView.onVideoDidPlayToEnd(@{});
  }
}

@end
