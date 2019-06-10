
#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>

#import "HSReactNativeMedia-Swift.h"
#import "HSThumbnailViewManager.h"

@implementation HSThumbnailViewManager

- (dispatch_queue_t)methodQueue {
  return dispatch_get_main_queue();
}

RCT_EXPORT_MODULE(HSThumbnailViewManager)

- (UIView *)view {
  HSThumbnailView *thumbnailView = [[HSThumbnailView alloc] init];
  return (UIView *)thumbnailView;
}

RCT_CUSTOM_VIEW_PROPERTY(videoID, NSString, HSThumbnailView) {
  NSString *videoID = [RCTConvert NSString:json];
  PHFetchResult<PHAsset *> *fetchResult =
      [PHAsset fetchAssetsWithLocalIdentifiers:@[ videoID ] options:nil];
  PHAsset *asset = fetchResult.firstObject;
  if (asset == nil) {
    return;
  }
  if (![view isKindOfClass:[HSThumbnailView class]]) {
    RCTLogError(@"View is not the correct class. Expected 'HSThumbnailView'.");
    return;
  }
  view.asset = asset;
}

@end
