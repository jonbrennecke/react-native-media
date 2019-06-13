// @flow
import { List, Map } from 'immutable';

import { createReducer } from '../createReducer';
import { createMediaState } from './mediaState';

import type { Action, AlbumObject, MediaObject } from '../../types';
import type { MediaStateRecord } from './mediaState';

const createInitialState = createMediaState({
  albums: List([]),
  assets: List([]),
  albumAssets: Map({}),
});

export const initialState = createInitialState();

const reducers = {
  setAlbums: (
    state,
    { payload }: Action<{ albums: Array<AlbumObject> }>
  ): MediaStateRecord => {
    if (!payload) {
      return state;
    }
    return state.set('albums', List(payload.albums));
  },

  setAssets: (
    state,
    { payload }: Action<{ assets: Array<MediaObject> }>
  ): MediaStateRecord => {
    if (!payload) {
      return state;
    }
    return state.set('assets', List(payload.assets));
  },
};

export const { reducer, actionCreators } = createReducer(
  initialState,
  reducers
);
