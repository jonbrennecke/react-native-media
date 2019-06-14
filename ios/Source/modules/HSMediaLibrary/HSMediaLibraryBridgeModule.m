#import <Photos/PHAsset.h>
#import <React/RCTConvert.h>

#import "HSMediaLibraryBridgeModule.h"

@implementation HSMediaLibraryBridgeModule {
  bool hasListeners;
}

@synthesize mediaLibrary;

- (instancetype)init {
  self = [super init];
  if (self != nil) {
    mediaLibrary = [[HSMediaLibrary alloc] init];
    mediaLibrary.delegate = self;
  }
  return self;
}

#pragma mark - HSMediaLibraryDelegate

- (void)mediaLibraryDidGenerateThumbnail:(UIImage *)thumbnail
                           forTargetSize:(CGSize)size {
  if (!thumbnail || !hasListeners) {
    return;
  }
  [self sendEventWithName:@"mediaLibraryDidOutputThumbnail"
                     body:@{
                       @"size" : @(size),
                       @"image" : thumbnail
                     }];
}

- (void)mediaLibraryDidUpdateVideos:(NSArray<PHAsset *> *)videoAssets {
  if (!hasListeners) {
    return;
  }
  NSMutableArray<NSDictionary *> *videos =
      [[NSMutableArray alloc] initWithCapacity:videoAssets.count];
  [videoAssets
      enumerateObjectsUsingBlock:^(PHAsset *_Nonnull asset, NSUInteger idx,
                                   BOOL *_Nonnull stop) {
        if (asset == nil) {
          return;
        }
        HSMediaAsset *mediaAsset = [[HSMediaAsset alloc] initWithAsset:asset];
        [videos insertObject:[mediaAsset asDictionary] atIndex:idx];
      }];
  [self sendEventWithName:@"mediaLibraryDidUpdateVideos"
                     body:@{@"videos" : videos}];
}

#pragma mark - React Native module

- (void)startObserving {
  hasListeners = YES;
}

- (void)stopObserving {
  hasListeners = NO;
}

+ (BOOL)requiresMainQueueSetup {
  return NO;
}

- (NSArray<NSString *> *)supportedEvents {
  return @[ @"mediaLibraryDidOutputThumbnail", @"mediaLibraryDidUpdateVideos" ];
}

RCT_EXPORT_MODULE(HSMediaLibrary)

RCT_EXPORT_METHOD(authorizeMediaLibrary : (RCTResponseSenderBlock)callback) {
  [mediaLibrary authorizeMediaLibrary:^(BOOL success) {
    callback(@[ [NSNull null], @(success) ]);
  }];
}

RCT_EXPORT_METHOD(queryMedia
                  : (NSDictionary *)queryArgs callback
                  : (RCTResponseSenderBlock)callback) {
  HSMediaLibraryMediaQuery *query = [[HSMediaLibraryMediaQuery alloc] initWithDict:queryArgs];
  if (!query) {
    id error =
        RCTMakeError(@"Invalid meida query sent to MediaLibrary", queryArgs, nil);
    callback(@[ error, [NSNull null] ]);
    return;
  }
  NSArray<id<NSDictionaryConvertible>> *queryResult = [mediaLibrary queryMedia:query];
  NSMutableArray<NSDictionary *> *assets = [[NSMutableArray alloc] initWithCapacity:queryResult.count];
  [queryResult enumerateObjectsUsingBlock:^(id<NSDictionaryConvertible> res, NSUInteger idx,
                                            BOOL *_Nonnull stop) {
    [assets insertObject:[res asDictionary] atIndex:idx];
  }];
  callback(@[ [NSNull null], assets ]);
}

RCT_EXPORT_METHOD(queryAlbums
                  : (NSDictionary *)queryArgs callback
                  : (RCTResponseSenderBlock)callback) {
  HSMediaLibraryAlbumQuery *query = [[HSMediaLibraryAlbumQuery alloc] initWithDict:queryArgs];
  if (!query) {
    id error = RCTMakeError(@"Invalid album query sent to MediaLibrary", queryArgs, nil);
    callback(@[ error, [NSNull null] ]);
    return;
  }
  NSArray<id<NSDictionaryConvertible>> *queryResult = [mediaLibrary queryAlbums:query];
  NSMutableArray<NSDictionary *> *albums = [[NSMutableArray alloc] initWithCapacity:queryResult.count];
  [queryResult enumerateObjectsUsingBlock:^(id<NSDictionaryConvertible> res, NSUInteger idx,
                                       BOOL *_Nonnull stop) {
    [albums insertObject:[res asDictionary] atIndex:idx];
  }];
  callback(@[ [NSNull null], albums ]);
}

// RCT_EXPORT_METHOD(startObservingVideos) { [mediaLibrary
// startObservingVideos]; }

// RCT_EXPORT_METHOD(stopObservingVideos) { [mediaLibrary stopObservingVideos];
// }

@end
