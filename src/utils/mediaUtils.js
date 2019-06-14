// @flow
import Bluebird from 'bluebird';
import { NativeModules } from 'react-native';

import type { AlbumObject, MediaObject, MediaType } from '../types';

const { MediaLibrary: NativeMediaLibrary } = NativeModules;
const MediaLibrary = Bluebird.promisifyAll(NativeMediaLibrary);

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
  date: Date,
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
