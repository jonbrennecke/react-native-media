// @flow
import type { IMediaState } from './mediaState';

export const selectAlbums = (state: IMediaState) => state.getAlbums();

export const selectAssets = (state: IMediaState) => state.getAssets();

export const selectAlbumAssets = (state: IMediaState) => state.getAlbumAssets();

export const selectAlbumAssetsByAlbumId = (
  state: IMediaState,
  albumID: string
) => selectAlbumAssets(state).get(albumID);

export const selectIsLoadingAssetsForAlbum = (state: IMediaState) => (
  albumID: string
): boolean => {
  const albumAssets = selectAlbumAssetsByAlbumId(state, albumID);
  if (!albumAssets) {
    return false;
  }
  return albumAssets.loadingStatus === 'isLoading';
};

export const selectAssetsForAlbum = (state: IMediaState) => (
  albumID: string
) => {
  return selectAlbumAssetsByAlbumId(state, albumID);
};
