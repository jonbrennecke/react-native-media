
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

RCT_CUSTOM_VIEW_PROPERTY(assetID, NSString, HSThumbnailView) {
  NSString *assetID = [RCTConvert NSString:json];
  PHFetchResult<PHAsset *> *fetchResult =
      [PHAsset fetchAssetsWithLocalIdentifiers:@[ assetID ] options:nil];
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

RCT_CUSTOM_VIEW_PROPERTY(resizeCover, BOOL, HSThumbnailView) {
  BOOL resizeCover = [RCTConvert BOOL:json];
  if (![view isKindOfClass:[HSThumbnailView class]]) {
    RCTLogError(@"View is not the correct class. Expected 'HSThumbnailView'.");
    return;
  }
  view.resizeCover = resizeCover;
}

@end
