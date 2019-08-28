// @flow
import React from 'react';
import { connect } from 'react-redux';
import identity from 'lodash/identity';

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
  createAlbum: (title: string) => any,
};

export type MediaStateHOCProps = OwnProps & StateProps & DispatchProps;

function mapMediaStateToProps(state: IMediaState): StateProps {
  return {
    albums: selectAlbums(state),
    assets: selectAssets(state),
    albumAssets: selectAlbumAssets(state),
    isLoadingAssetsForAlbum: selectIsLoadingAssetsForAlbum(state),
    assetsForAlbum: selectAssetsForAlbum(state),
  };
}

function mapMediaDispatchToProps(dispatch: Dispatch<*>): DispatchProps {
  return {
    queryAlbums: (...args) => dispatch(actionCreators.queryAlbums(...args)),
    queryMedia: (...args) => dispatch(actionCreators.queryMedia(...args)),
    setAlbums: (...args) => dispatch(actionCreators.setAlbums(...args)),
    createAlbum: (...args) => dispatch(actionCreators.createAlbum(...args)),
  };
}

const createSlicedStateToPropsMapper = <State, StateSlice, StateProps>(
  mapStateToProps: StateSlice => StateProps,
  stateSliceAccessor?: State => StateSlice = identity
): ((state: State) => StateProps) => {
  return state => {
    const stateSlice = stateSliceAccessor(state);
    return mapStateToProps(stateSlice);
  };
};

const createSlicedDispatchToPropsMapper = <State, StateSlice, DispatchProps>(
  mapDispatchToProps: (Dispatch<*>, () => StateSlice) => DispatchProps,
  stateSliceAccessor?: State => StateSlice = identity
): ((dispatch: Dispatch<*>, getState: () => State) => DispatchProps) => {
  return (dispatch, getState) => {
    const getSlicedSlice = () => stateSliceAccessor(getState());
    return mapDispatchToProps(dispatch, getSlicedSlice);
  };
};

export type MediaStateHOC<OriginalProps> = (
  Component: ComponentType<MediaStateHOCProps & OriginalProps>
) => ComponentType<OriginalProps>;

export function createMediaStateHOC<PassThroughProps, State: IMediaState>(
  stateSliceAccessor?: State => IMediaState = identity
): MediaStateHOC<PassThroughProps> {
  const mapStateToProps = createSlicedStateToPropsMapper(
    mapMediaStateToProps,
    stateSliceAccessor
  );
  const mapDispatchToProps = createSlicedDispatchToPropsMapper(
    mapMediaDispatchToProps,
    stateSliceAccessor
  );
  return Component => {
    const fn = (props: PassThroughProps) => <Component {...props} />;
    return connect(mapStateToProps, mapDispatchToProps)(fn);
  };
}
