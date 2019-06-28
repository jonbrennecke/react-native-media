// @flow
import { Record, Map, Set } from 'immutable';
import uniqBy from 'lodash/uniqBy';
import property from 'lodash/property';

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
  albums: Set<AlbumObject>,
  assets: Set<MediaObject>,
  albumAssets: AlbumAssets,
};

export type MediaStateRecord = RecordOf<MediaStateObject>;

export type ArrayOrSet<T> = Array<T> | Set<T>;

export interface IMediaState {
  getAlbums(): Set<AlbumObject>;
  setAlbums(albums: ArrayOrSet<AlbumObject>): IMediaState;
  appendAlbums(albums: ArrayOrSet<AlbumObject>): IMediaState;

  getAssets(): Set<MediaObject>;
  setAssets(assets: ArrayOrSet<MediaObject>): IMediaState;
  appendAssets(assets: ArrayOrSet<MediaObject>): IMediaState;

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
    getAlbums(): Set<AlbumObject> {
      return this.get('albums');
    }

    setAlbums(albums: ArrayOrSet<AlbumObject>): MediaState {
      const uniqueAlbums = uniqBy(
        // $FlowFixMe
        albums.toArray ? albums.toArray() : albums,
        property('albumID')
      );
      return this.set('albums', Set(uniqueAlbums));
    }

    appendAlbums(albums: ArrayOrSet<AlbumObject>): MediaState {
      const currentAlbums = this.getAlbums();
      return this.setAlbums(currentAlbums.concat(albums));
    }

    getAssets(): Set<MediaObject> {
      return this.get('assets');
    }

    setAssets(assets: ArrayOrSet<MediaObject>): MediaState {
      const uniqueAssets = uniqBy(
        // $FlowFixMe
        assets.toArray ? assets.toArray() : assets,
        property('assetID')
      );
      return this.set('assets', Set(uniqueAssets));
    }

    appendAssets(assets: ArrayOrSet<MediaObject>): IMediaState {
      const currentAssets = this.getAssets();
      return this.setAssets(currentAssets.concat(assets));
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
