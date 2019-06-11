#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>
#import <React/RCTBridge.h>
#import <React/RCTUIManager.h>

#import "HSReactNativeMedia-Swift.h"
#import "HSVideoPlayerViewManager.h"
#import "HSVideoPlayerWrappingView.h"
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

RCT_EXPORT_VIEW_PROPERTY(onVideoDidBecomeReadyToPlay, RCTBubblingEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onVideoDidFailToLoad, RCTBubblingEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onVideoDidPause, RCTBubblingEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onVideoDidUpdatePlaybackTime, RCTBubblingEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onVideoDidRestart, RCTBubblingEventBlock)

RCT_EXPORT_METHOD(play : (nonnull NSNumber *)reactTag) {
  [self.bridge.uiManager addUIBlock:^(
                             RCTUIManager *uiManager,
                             NSDictionary<NSNumber *, UIView *> *viewRegistry) {
    HSVideoPlayerWrappingView *view =
        (HSVideoPlayerWrappingView *)viewRegistry[reactTag];
    if (!view || ![view isKindOfClass:[HSVideoPlayerWrappingView class]]) {
      RCTLogError(@"Cannot find HSVideoPlayerWrappingView with tag #%@", reactTag);
      return;
    }
    [view.playerView play];
  }];
}

RCT_EXPORT_METHOD(pause : (nonnull NSNumber *)reactTag) {
  [self.bridge.uiManager
      addUIBlock:^(RCTUIManager *uiManager,
                   NSDictionary<NSNumber *, UIView *> *viewRegistry) {
        HSVideoPlayerWrappingView *view =
            (HSVideoPlayerWrappingView *)viewRegistry[reactTag];
        if (!view || ![view isKindOfClass:[HSVideoPlayerWrappingView class]]) {
          RCTLogError(@"Cannot find VideoPlayerView with tag #%@", reactTag);
          return;
        }
        [view.playerView pause];
      }];
}

RCT_EXPORT_METHOD(restart : (nonnull NSNumber *)reactTag) {
  [self.bridge.uiManager
      addUIBlock:^(RCTUIManager *uiManager,
                   NSDictionary<NSNumber *, UIView *> *viewRegistry) {
        HSVideoPlayerWrappingView *view =
            (HSVideoPlayerWrappingView *)viewRegistry[reactTag];
        if (!view || ![view isKindOfClass:[HSVideoPlayerWrappingView class]]) {
          RCTLogError(@"Cannot find VideoPlayerView with tag #%@", reactTag);
          return;
        }
        [view.playerView restartWithCompletionHandler:^(BOOL success) {
          [view.playerView play];
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
        HSVideoPlayerWrappingView *view =
            (HSVideoPlayerWrappingView *)viewRegistry[reactTag];
        if (!view || ![view isKindOfClass:[HSVideoPlayerWrappingView class]]) {
          RCTLogError(@"Cannot find VideoPlayerView with tag #%@", reactTag);
          return;
        }
        CMTime time = CMTimeMakeWithSeconds([seekTime floatValue], 600);
        [view.playerView seekTo:time
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
                 HSVideoPlayerWrappingView *playerViewWrap =
                     (HSVideoPlayerWrappingView *)view;
                 playerViewWrap.playerView.asset = asset;
               }];
}

- (UIView *)view {
  HSVideoPlayerWrappingView *view = [[HSVideoPlayerWrappingView alloc] init];
  return view;
}

@end
