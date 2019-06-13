// @flow
import { Record, List, Map, Set } from 'immutable';

import type { RecordOf, RecordInstance } from 'immutable';

import type { MediaObject, AlbumObject } from '../../types';

export type AlbumLoadingStatus = 'isLoading' | 'isLoaded';

export type AlbumAssetValueObject = {
  assetIDs: Set<string>,
  loadingStatus: AlbumLoadingStatus,
};

export type AlbumAssetsObject = { [key: string]: AlbumAssetValueObject };

// eslint-disable-next-line flowtype/generic-spacing
export type AlbumAssets = Map<string, AlbumAssetValueObject>;

export type MediaStateObject = {
  albums: List<AlbumObject>,
  assets: List<MediaObject>,
  albumAssets: AlbumAssets,
};

export type MediaStateRecord = RecordOf<MediaStateObject>;

export type ArrayOrList<T> = Array<T> | List<T>;

export interface IMediaState {
  getAlbums(): List<AlbumObject>;
  setAlbums(albums: ArrayOrList<AlbumObject>): IMediaState;

  getAssets(): List<MediaObject>;
  setAssets(assets: ArrayOrList<MediaObject>): IMediaState;

  getAlbumAssets(): AlbumAssets;
  setAlbumAssets(albumAssets: AlbumAssets | AlbumAssetsObject): IMediaState;

  setAlbumAssetsAtID(
    albumID: string,
    value: AlbumAssetValueObject
  ): IMediaState;
}

// eslint-disable-next-line flowtype/generic-spacing
export const createMediaState: MediaStateObject => Class<
  RecordInstance<MediaStateRecord> & IMediaState
> = defaultState =>
  class MediaState extends Record(defaultState) implements IMediaState {
    getAlbums(): List<AlbumObject> {
      return this.get('albums');
    }

    setAlbums(albums: ArrayOrList<AlbumObject>): MediaState {
      return this.set('albums', List(albums));
    }

    getAssets(): List<MediaObject> {
      return this.get('assets');
    }

    setAssets(assets: ArrayOrList<MediaObject>): MediaState {
      return this.set('assets', List(assets));
    }

    getAlbumAssets(): AlbumAssets {
      return this.get('albumAssets');
    }

    setAlbumAssets(albumAssets: AlbumAssets | AlbumAssetsObject): MediaState {
      return this.set('albumAssets', Map(albumAssets));
    }

    setAlbumAssetsAtID(
      albumID: string,
      value: AlbumAssetValueObject
    ): MediaState {
      return this.setIn(['albumAssets', albumID], value);
    }
  };
