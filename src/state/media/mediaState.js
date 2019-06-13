// @flow
import { Record } from 'immutable';

import type { List, Map, RecordOf, RecordFactory } from 'immutable';

import type { MediaObject, AlbumObject } from '../../types';

export type AlbumLoadingStatus = boolean;

export type MediaStateObject = {
  albums: List<AlbumObject>,
  assets: List<MediaObject>,
  albumAssets: Map<string, Map<string, AlbumLoadingStatus>>,
};

export type MediaStateRecord = RecordOf<MediaStateObject>;

// eslint-disable-next-line flowtype/generic-spacing
export const createMediaState: MediaStateObject => RecordFactory<
  MediaStateObject
> = defaultState => Record(defaultState);
