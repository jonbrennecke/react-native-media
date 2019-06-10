#pragma once

#if __has_include("RCTViewManager.h")
#import "RCTViewManager.h"
#else
#import <React/RCTViewManager.h>
#endif

@class HSThumbnailViewManager;
@interface HSThumbnailViewManager : RCTViewManager
@end
