#pragma once

#import "HSReactNativeMedia-Swift.h"
#import <React/RCTBridgeModule.h>
#import <React/RCTEventEmitter.h>

@interface HSMediaLibraryBridgeModule
    : RCTEventEmitter <RCTBridgeModule, HSMediaLibraryDelegate>
@property(nonatomic, retain) HSMediaLibrary *mediaLibrary;
- (void)mediaLibraryDidChange;
@end
