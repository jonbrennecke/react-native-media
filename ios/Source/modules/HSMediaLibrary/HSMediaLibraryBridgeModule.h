#pragma once

#import "HSReactNativeMedia-Swift.h"
#import <React/RCTBridgeModule.h>
#import <React/RCTEventEmitter.h>

@interface HSMediaLibraryBridgeModule
    : RCTEventEmitter <RCTBridgeModule, HSMediaLibraryDelegate>
@property(nonatomic, retain) HSMediaLibrary *mediaLibrary;

- (void)mediaLibraryWithDidGenerateThumbnail:(UIImage *)thumbnail
                                        size:(CGSize)size;
- (void)mediaLibraryWithDidUpdateVideos:(NSArray<PHAsset *> *)videos;
@end
