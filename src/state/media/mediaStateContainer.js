// @flow
import React from 'react';
import { connect } from 'react-redux';

import {
  actionCreators,
  selectAlbums,
  selectAlbumAssets,
  selectAssets,
  selectIsLoadingAssetsForAlbum,
  selectAssetsForAlbum,
} from './';

import type { ComponentType } from 'react';

import type { Dispatch, AlbumObject, ReturnType } from '../../types';
import type { IMediaState } from './';
import type { MediaQuery, AlbumQuery } from '../../utils';

type OwnProps = {};

type StateProps = {
  albums: ReturnType<typeof selectAlbums>,
  assets: ReturnType<typeof selectAssets>,
  albumAssets: ReturnType<typeof selectAlbumAssets>,
  isLoadingAssetsForAlbum: ReturnType<typeof selectIsLoadingAssetsForAlbum>,
  assetsForAlbum: ReturnType<typeof selectAssetsForAlbum>,
};

type DispatchProps = {
  queryAlbums: AlbumQuery => any,
  queryMedia: MediaQuery => any,
  setAlbums: ({ albums: AlbumObject[] }) => any, // TODO: FunctionArgsType<typeof actionCreators.setAlbums>
};

export type MediaStateContainerProps = OwnProps & StateProps & DispatchProps;

function mapStateToProps(state: IMediaState): StateProps {
  return {
    albums: selectAlbums(state),
    assets: selectAssets(state),
    albumAssets: selectAlbumAssets(state),
    isLoadingAssetsForAlbum: selectIsLoadingAssetsForAlbum(state),
    assetsForAlbum: selectAssetsForAlbum(state),
  };
}

function mapDispatchToProps(dispatch: Dispatch<*>): DispatchProps {
  return {
    queryAlbums: (...args) => dispatch(actionCreators.queryAlbums(...args)),
    queryMedia: (...args) => dispatch(actionCreators.queryMedia(...args)),
    setAlbums: (...args) => dispatch(actionCreators.setAlbums(...args)), // TODO: probably don't need this
  };
}

export const MediaStateContainer = <OriginalProps>(
  Component: ComponentType<MediaStateContainerProps & OriginalProps>
): ComponentType<MediaStateContainerProps> => {
  const fn = (props: MediaStateContainerProps & OriginalProps) => (
    <Component {...props} />
  );
  return connect(mapStateToProps, mapDispatchToProps)(fn);
};
