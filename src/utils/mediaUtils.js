// @flow
import Bluebird from 'bluebird';
import { NativeModules } from 'react-native';

import type { MediaObject } from '../types';
// import type { Return } from '../types/util';

const DEFAULT_LIMIT = 20;

const { MediaLibrary: NativeMediaLibrary } = NativeModules;
const MediaLibrary = Bluebird.promisifyAll(NativeMediaLibrary);

// const NativeMediaManagerEventEmitter = new NativeEventEmitter(_MediaLibrary);

// const EVENTS = {
//   DID_UPDATE_VIDEOS: 'mediaLibraryDidUpdateVideos',
// };

// // eslint-disable-next-line flowtype/generic-spacing
// export type EmitterSubscription = Return<
//   typeof NativeMediaManagerEventEmitter.addListener
// >;

export const authorizeMediaLibrary = (): Promise<boolean> => {
  return MediaLibrary.authorizeMediaLibraryAsync();
};

export const loadImageAssets = ({
  limit = DEFAULT_LIMIT,
}: {
  limit?: number,
} = {}): Promise<MediaObject[]> => {
  return MediaLibrary.queryAsync({
    mediaType: 'image',
    limit,
  });
};

// static startObservingVideos(
//   listener: ({ videos: VideoObject[] }) => void
// ): EmitterSubscription {
//   MediaLibrary.startObservingVideos();
//   return MediaManager.addDidUpdateVideosListener(listener);
// }

// static stopObservingVideos() {
//   MediaLibrary.stopObservingVideos();
//   MediaManager.removeAllDidUpdateVideosListeners();
// }

// static addDidUpdateVideosListener(
//   listener: ({ videos: VideoObject[] }) => void
// ): EmitterSubscription {
//   return NativeMediaManagerEventEmitter.addListener(
//     EVENTS.DID_UPDATE_VIDEOS,
//     listener
//   );
// }

// static removeAllDidUpdateVideosListeners() {
//   return NativeMediaManagerEventEmitter.removeAllListeners(
//     EVENTS.DID_UPDATE_VIDEOS
//   );
// }
