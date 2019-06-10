// @flow
import Bluebird from 'bluebird';
import { NativeModules } from 'react-native';

// import type { VideoAssetIdentifier } from '../types/media';
// import type { Return } from '../types/util';

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

export type VideoObject = { assetID: string, duration: number };

export const loadVideoAssets = (): Promise<VideoObject[]> => {
  return MediaLibrary.queryAsync({ mediaType: 'image' });
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
