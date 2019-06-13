// @flow
import { List, Map, Set } from 'immutable';

import { createReducer } from '../createReducer';
import { queryAlbums, queryMedia } from '../../utils';
import { createMediaState } from './mediaState';
import { selectAlbumAssetsByAlbumId } from './mediaSelectors';

import type { Action, AlbumObject, MediaObject, Dispatch } from '../../types';
import type {
  IMediaState,
  AlbumAssetsObject,
  AlbumLoadingStatus,
  AlbumAssetValueObject,
} from './mediaState';
import type { AlbumQuery, MediaQuery } from '../../utils';

const MediaState = createMediaState({
  albums: List([]),
  assets: List([]),
  albumAssets: Map({}),
});

export const initialState = new MediaState();

const reducers = {
  setAlbums: (
    state,
    { payload }: Action<{ albums: Array<AlbumObject> }>
  ): IMediaState => {
    if (!payload) {
      return state;
    }
    return state.setAlbums(payload.albums);
  },

  setAssets: (
    state,
    { payload }: Action<{ assets: Array<MediaObject> }>
  ): IMediaState => {
    if (!payload) {
      return state;
    }
    return state.setAssets(payload.assets);
  },

  setAlbumAssets: (
    state,
    { payload }: Action<{ albumAssets: AlbumAssetsObject }>
  ): IMediaState => {
    if (!payload) {
      return state;
    }
    return state.setAlbumAssets(payload.albumAssets);
  },

  setAlbumAssetByAlbumID: (
    state,
    { payload }: Action<{ albumID: string, value: AlbumAssetValueObject }>
  ): IMediaState => {
    if (!payload) {
      return state;
    }
    return state.setAlbumAssetsAtID(payload.albumID, payload.value);
  },

  setAlbumAssetLoadingStatus: (
    state,
    { payload }: Action<{ albumID: string, loadingStatus: AlbumLoadingStatus }>
  ): IMediaState => {
    if (!payload) {
      return state;
    }
    const albumAssetsValue = selectAlbumAssetsByAlbumId(state, payload.albumID);
    return state.setAlbumAssetsAtID(payload.albumID, {
      ...(albumAssetsValue || { assetIDs: Set() }),
      loadingStatus: payload.loadingStatus,
    });
  },

  setHasLoadedAssetsInAlbum: (
    state,
    { payload }: Action<{ albumID: string, assetIDs: string[] }>
  ): IMediaState => {
    if (!payload) {
      return state;
    }
    const albumAssetsValue = selectAlbumAssetsByAlbumId(state, payload.albumID);
    const assetIDs = albumAssetsValue?.assetIDs || Set();
    return state.setAlbumAssetsAtID(payload.albumID, {
      assetIDs: assetIDs.union(payload.assetIDs),
      loadingStatus: 'isLoaded',
    });
  },
};

export const {
  reducer,
  actionCreators: identityActionCreators,
} = createReducer(initialState, reducers);

export const actionCreators = {
  ...identityActionCreators,

  queryAlbums: (query: AlbumQuery) => async (dispatch: Dispatch<*>) => {
    const albums = await queryAlbums(query);
    dispatch(actionCreators.setAlbums({ albums }));
  },

  queryMedia: (query: MediaQuery) => async (dispatch: Dispatch<any>) => {
    if (query.albumID) {
      dispatch(
        actionCreators.setAlbumAssetLoadingStatus({
          albumID: query.albumID,
          loadingStatus: 'isLoading',
        })
      );
    }
    const assets = await queryMedia(query);
    dispatch(actionCreators.setAssets({ assets }));
    if (query.albumID) {
      const assetIDs = assets.map(a => a.assetID);
      dispatch(
        actionCreators.setHasLoadedAssetsInAlbum({
          albumID: query.albumID || '',
          assetIDs,
        })
      );
      // dispatch(
      //   actionCreators.setAlbumAssetLoadingStatus({
      //     albumID: query.albumID,
      //     loadingStatus: 'isLoaded',
      //   })
      // );
    }
  },
};
