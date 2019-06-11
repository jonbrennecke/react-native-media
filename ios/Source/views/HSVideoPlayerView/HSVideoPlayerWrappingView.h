#pragma once

#import "HSReactNativeMedia-Swift.h"
#import <React/RCTViewManager.h>

@class HSVideoPlayerWrappingView;
@interface HSVideoPlayerWrappingView : UIView <HSVideoPlayerViewDelegate>
@property(nonatomic, retain) HSVideoPlayerView *playerView;
@property(nonatomic, copy) RCTBubblingEventBlock onVideoDidBecomeReadyToPlay;
@property(nonatomic, copy) RCTBubblingEventBlock onVideoDidFailToLoad;
@property(nonatomic, copy) RCTBubblingEventBlock onVideoDidPause;
@property(nonatomic, copy) RCTBubblingEventBlock onVideoDidUpdatePlaybackTime;
@property(nonatomic, copy) RCTBubblingEventBlock onVideoDidRestart;
- (void)videoPlayerDidFailToLoad;
- (void)videoPlayerDidBecomeReadyToPlayAsset:(AVAsset *)asset;
- (void)videoPlayerDidPause;
- (void)videoPlayerDidUpdatePlaybackTime:(CMTime)time duration:(CMTime)duration;
- (void)videoPlayerDidRestartVideo;
@end
