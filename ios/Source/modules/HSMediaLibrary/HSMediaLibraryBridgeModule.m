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

- (void)mediaLibraryDidChange {
  if (!hasListeners) {
    return;
  }
  [self sendEventWithName:@"mediaLibraryDidChange" body:@{}];
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
  return @[ @"mediaLibraryDidChange" ];
}

RCT_EXPORT_MODULE(HSMediaLibrary)

#pragma mark - React Native exported methods

RCT_EXPORT_METHOD(startObservingVideos) { [mediaLibrary startObserving]; }

RCT_EXPORT_METHOD(stopObservingVideos) { [mediaLibrary stopObserving]; }

RCT_EXPORT_METHOD(authorizeMediaLibrary : (RCTResponseSenderBlock)callback) {
  [mediaLibrary authorizeMediaLibrary:^(BOOL success) {
    callback(@[ [NSNull null], @(success) ]);
  }];
}

RCT_EXPORT_METHOD(queryMedia
                  : (NSDictionary *)queryArgs callback
                  : (RCTResponseSenderBlock)callback) {
  HSMediaLibraryMediaQuery *query =
      [[HSMediaLibraryMediaQuery alloc] initWithDict:queryArgs];
  if (!query) {
    id error = RCTMakeError(@"Invalid media query sent to MediaLibrary",
                            queryArgs, nil);
    callback(@[ error, [NSNull null] ]);
    return;
  }
  NSArray<id<NSDictionaryConvertible>> *queryResult =
      [mediaLibrary queryMedia:query];
  NSMutableArray<NSDictionary *> *assets =
      [[NSMutableArray alloc] initWithCapacity:queryResult.count];
  [queryResult
      enumerateObjectsUsingBlock:^(id<NSDictionaryConvertible> res,
                                   NSUInteger idx, BOOL *_Nonnull stop) {
        [assets insertObject:[res asDictionary] atIndex:idx];
      }];
  callback(@[ [NSNull null], assets ]);
}

RCT_EXPORT_METHOD(queryAlbums
                  : (NSDictionary *)queryArgs callback
                  : (RCTResponseSenderBlock)callback) {
  HSMediaLibraryAlbumQuery *query =
      [[HSMediaLibraryAlbumQuery alloc] initWithDict:queryArgs];
  if (!query) {
    id error = RCTMakeError(@"Invalid album query sent to MediaLibrary",
                            queryArgs, nil);
    callback(@[ error, [NSNull null] ]);
    return;
  }
  NSArray<id<NSDictionaryConvertible>> *queryResult =
      [mediaLibrary queryAlbums:query];
  NSMutableArray<NSDictionary *> *albums =
      [[NSMutableArray alloc] initWithCapacity:queryResult.count];
  [queryResult
      enumerateObjectsUsingBlock:^(id<NSDictionaryConvertible> res,
                                   NSUInteger idx, BOOL *_Nonnull stop) {
        [albums insertObject:[res asDictionary] atIndex:idx];
      }];
  callback(@[ [NSNull null], albums ]);
}

RCT_EXPORT_METHOD(getFavoritesAlbum : (RCTResponseSenderBlock)callback) {
  id<NSDictionaryConvertible> album = [mediaLibrary getFavoritesAlbum];
  if (album == nil) {
    id error = RCTMakeError(@"Unable to find favorites album", nil, nil);
    callback(@[ error, [NSNull null] ]);
    return;
  }
  NSDictionary *dict = [album asDictionary];
  callback(@[ [NSNull null], dict ]);
}

RCT_EXPORT_METHOD(getCameraRollAlbum : (RCTResponseSenderBlock)callback) {
  id<NSDictionaryConvertible> album = [mediaLibrary getCameraRollAlbum];
  if (album == nil) {
    id error = RCTMakeError(@"Unable to find camera roll album", nil, nil);
    callback(@[ error, [NSNull null] ]);
    return;
  }
  NSDictionary *dict = [album asDictionary];
  callback(@[ [NSNull null], dict ]);
}

@end
