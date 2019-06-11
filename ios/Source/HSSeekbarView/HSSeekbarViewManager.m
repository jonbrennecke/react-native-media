#import "HSSeekbarViewManager.h"
#import "HSReactNativeMedia-Swift.h"

@implementation HSSeekbarViewManager

RCT_EXPORT_MODULE(HSSeekbarViewManager)

RCT_CUSTOM_VIEW_PROPERTY(assetID, NSString, HSSeekbarView) {
  NSString *assetID = [RCTConvert NSString:json];
  PHFetchResult<PHAsset *> *fetchResult =
      [PHAsset fetchAssetsWithLocalIdentifiers:@[ assetID ] options:nil];
  PHAsset *asset = fetchResult.firstObject;
  if (asset == nil) {
    return;
  }
  if (![view isKindOfClass:[HSSeekbarView class]]) {
    RCTLogError(@"View is not the correct class. Expected 'HSSeekbarView'.");
    return;
  }
  view.asset = asset;
}

- (UIView *)view {
  HSSeekbarView *view = [[HSSeekbarView alloc] init];
  return (UIView *)view;
}

@end
