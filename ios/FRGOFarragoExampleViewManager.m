
#import "FRGOFarragoExampleViewManager.h"

@implementation FRGOFarragoExampleViewManager

- (dispatch_queue_t)methodQueue {
  return dispatch_get_main_queue();
}

RCT_EXPORT_MODULE()

- (UIView *)view {
  UIView *exampleView = [[UIView alloc] init];
  return (UIView *)exampleView;
}

@end
