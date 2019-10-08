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

RCT_EXPORT_VIEW_PROPERTY(onVideoDidFailToLoad, RCTDirectEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onVideoDidUpdatePlaybackTime, RCTDirectEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onVideoWillRestart, RCTDirectEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onPlaybackStateChange, RCTDirectEventBlock)

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

RCT_EXPORT_METHOD(restart : (nonnull NSNumber *)reactTag) {
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
          [view play];
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

RCT_CUSTOM_VIEW_PROPERTY(localIdentifier, NSString, UIView) {
  NSString *localIdentifier = [RCTConvert NSString:json];
  PHFetchResult<PHAsset *> *fetchResult =
      [PHAsset fetchAssetsWithLocalIdentifiers:@[ localIdentifier ]
                                       options:nil];
  PHAsset *asset = fetchResult.firstObject;
  if (asset == nil) {
    return;
  }
  PHVideoRequestOptions *requestOptions = [[PHVideoRequestOptions alloc] init];
  requestOptions.deliveryMode =
      PHImageRequestOptionsDeliveryModeHighQualityFormat;
  [PHImageManager.defaultManager
      requestAVAssetForVideo:asset
                     options:requestOptions
               resultHandler:^(AVAsset *_Nullable asset,
                               AVAudioMix *_Nullable audioMix,
                               NSDictionary *_Nullable info) {
                 if (!view ||
                     ![view isKindOfClass:[HSVideoPlayerBridgeView class]]) {
                   RCTLogError(@"Cannot find HSVideoPlayerBridgeView");
                   return;
                 }
                 ((HSVideoPlayerBridgeView *)view).asset = asset;
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
  if (bridgeView.onPlaybackStateChange) {
    NSDictionary *conversionDict = @{
      @(HSVideoPlaybackStatePlaying) : @"playing",
      @(HSVideoPlaybackStatePaused) : @"paused",
      @(HSVideoPlaybackStateWaiting) : @"waiting",
      @(HSVideoPlaybackStateReadyToPlay) : @"readyToPlay",
    };
    NSString *playbackStateKey = [conversionDict objectForKey:@(playbackState)];
    if (bridgeView.onPlaybackStateChange) {
      bridgeView.onPlaybackStateChange(@{@"playbackState" : playbackStateKey});
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
  if (!bridgeView.onVideoDidUpdatePlaybackTime) {
    return;
  }
  NSNumber *durationNumber =
      [NSNumber numberWithFloat:CMTimeGetSeconds(duration)];
  NSNumber *playbackTimeNumber =
      [NSNumber numberWithFloat:CMTimeGetSeconds(time)];
  NSDictionary *body =
      @{@"duration" : durationNumber, @"playbackTime" : playbackTimeNumber};
  if (bridgeView.onVideoDidUpdatePlaybackTime) {
    bridgeView.onVideoDidUpdatePlaybackTime(body);
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

- (void)videoPlayerViewWillRestartVideo:(HSVideoPlayerView *_Nonnull)view {
  if (![view isKindOfClass:[HSVideoPlayerBridgeView class]]) {
    return;
  }
  HSVideoPlayerBridgeView *bridgeView = (HSVideoPlayerBridgeView *)view;
  if (bridgeView.onVideoWillRestart) {
    bridgeView.onVideoWillRestart(@{});
  }
}

@end
