// @flow
import Bluebird from 'bluebird';
import { NativeModules } from 'react-native';

import type { MediaObject } from '../types';

const DEFAULT_LIMIT = 20;

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

export type MediaType = 'video' | 'image';

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
  limit = DEFAULT_LIMIT,
  creationDateQuery,
}: {
  mediaType: MediaType,
  creationDateQuery?: DateQuery,
  limit?: number,
} = {}): Promise<MediaObject[]> => {
  return MediaLibrary.queryAsync({
    mediaType: 'image',
    creationDateQuery,
    limit,
  });
};
