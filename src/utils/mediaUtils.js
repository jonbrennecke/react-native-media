// @flow
import Bluebird from 'bluebird';
import { NativeModules, NativeEventEmitter } from 'react-native';

import type { AlbumObject, MediaObject, MediaType, ReturnType } from '../types';

const { HSMediaLibrary: NativeMediaLibrary } = NativeModules;
const MediaLibrary = Bluebird.promisifyAll(NativeMediaLibrary);

export const MediaEventEmitter = new NativeEventEmitter(NativeMediaLibrary);

// eslint-disable-next-line flowtype/generic-spacing
export type MediaEventEmitterSubscription = ReturnType<
  typeof MediaEventEmitter.addListener
>;

export const MediaEvents = {
  DidUpdate: 'mediaLibraryDidChange',
};

export const authorizeMediaLibrary = (): Promise<boolean> => {
  return MediaLibrary.authorizeMediaLibraryAsync();
};

export type QuerySortEquation =
  | 'greaterThan'
  | 'greaterThanOrEqualTo'
  | 'equalTo'
  | 'lessThan'
  | 'lessThanOrEqualTo';

export type DateQuery = {
  date: Date | string,
  equation: QuerySortEquation,
};

export type TitleQuery = {
  title: string,
  equation: QuerySortEquation,
};

export const queryVideos = ({
  limit,
  creationDateQuery,
  albumID,
}: {
  creationDateQuery?: DateQuery,
  limit?: number,
  albumID?: string,
} = {}): Promise<MediaObject[]> => {
  return queryMedia({
    mediaType: 'video',
    creationDateQuery,
    limit,
    albumID,
  });
};

export const queryImages = ({
  limit,
  creationDateQuery,
  albumID,
}: {
  creationDateQuery?: DateQuery,
  limit?: number,
  albumID?: string,
} = {}): Promise<MediaObject[]> => {
  return queryMedia({
    mediaType: 'image',
    creationDateQuery,
    limit,
    albumID,
  });
};

export type MediaQuery = {
  mediaType?: MediaType,
  creationDateQuery?: DateQuery,
  limit?: number,
  albumID?: string,
};

export const queryMedia = ({
  mediaType = 'any',
  limit = 20,
  creationDateQuery,
  albumID,
}: MediaQuery = {}): Promise<MediaObject[]> => {
  return MediaLibrary.queryMediaAsync({
    mediaType,
    creationDateQuery,
    limit,
    albumID,
  });
};

export type AlbumQuery = {
  titleQuery?: TitleQuery,
  limit?: number,
};

export const queryAlbums = ({
  limit = 20,
  titleQuery,
}: AlbumQuery = {}): Promise<AlbumObject[]> => {
  return MediaLibrary.queryAlbumsAsync({
    titleQuery,
    limit,
  });
};

export const getFavoritesAlbum = (): Promise<AlbumObject> => {
  return MediaLibrary.getFavoritesAlbumAsync();
};

export const getCameraRollAlbum = (): Promise<AlbumObject> => {
  return MediaLibrary.getCameraRollAlbumAsync();
};

export const startObservingVideos = (
  listener: () => void
): MediaEventEmitterSubscription => {
  MediaLibrary.startObservingVideos();
  return MediaEventEmitter.addListener(MediaEvents.DidUpdate, listener);
};

export const stopObservingVideos = (
  subscription: MediaEventEmitterSubscription
) => {
  MediaLibrary.stopObservingVideos();
  subscription.remove();
};

export const createAlbum = async (title: string): Promise<?AlbumObject> => {
  return MediaLibrary.createAlbumAsync(title);
};
