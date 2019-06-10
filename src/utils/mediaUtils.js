// @flow
import Bluebird from 'bluebird';
import { NativeModules } from 'react-native';

import type { MediaObject } from '../types';

const { MediaLibrary: NativeMediaLibrary } = NativeModules;
const MediaLibrary = Bluebird.promisifyAll(NativeMediaLibrary);

export const authorizeMediaLibrary = (): Promise<boolean> => {
  return MediaLibrary.authorizeMediaLibraryAsync();
};

export type DateQueryEquation =
  | 'greaterThan'
  | 'greaterThanOrEqualTo'
  | 'equalTo'
  | 'lessThan'
  | 'lessThanOrEqualTo';

export type MediaType = 'video' | 'image' | 'any';

export type DateQuery = {
  date: Date,
  equation: DateQueryEquation,
};

export const queryVideos = ({
  limit,
  creationDateQuery,
}: {
  creationDateQuery?: DateQuery,
  limit?: number,
} = {}): Promise<MediaObject[]> => {
  return queryMedia({
    mediaType: 'video',
    creationDateQuery,
    limit,
  });
};

export const queryImages = ({
  limit,
  creationDateQuery,
}: {
  creationDateQuery?: DateQuery,
  limit?: number,
} = {}): Promise<MediaObject[]> => {
  return queryMedia({
    mediaType: 'image',
    creationDateQuery,
    limit,
  });
};

export const queryMedia = ({
  mediaType = 'any',
  limit = 20,
  creationDateQuery,
}: {
  mediaType: MediaType,
  creationDateQuery?: DateQuery,
  limit?: number,
} = {}): Promise<MediaObject[]> => {
  return MediaLibrary.queryAsync({
    mediaType,
    creationDateQuery,
    limit,
  });
};
