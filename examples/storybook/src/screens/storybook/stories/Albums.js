// @flow
import React from 'react';
import { storiesOf } from '@storybook/react-native';
import { SafeAreaView } from 'react-native';
import uniqBy from 'lodash/uniqBy';
import uniq from 'lodash/uniq';
import map from 'lodash/map';

import {
  AlbumExplorer,
  queryAlbums,
  queryMedia,
  authorizeMediaLibrary,
} from '@jonbrennecke/react-native-media';

import { StorybookStateWrapper } from '../utils';

const styles = {
  container: {
    flex: 1,
  },
  explorer: {
    flex: 1,
  },
};

type State = {
  albums: { albumID: string }[],
  assets: { assetID: string }[],
  albumAssets: {
    // albumID
    [key: string]: {
      // assetID
      [key: string]: {
        isLoading: true
      }
    }
  };
};

type SetState = (partialState: $Shape<State>) => void;
type GetState = () => State;

const initialState: State = {
  albums: [],
  assets: [],
  albumAssets: {},
};

const authorizeAndLoadAlbums = async (state: State, setState: SetState) => {
  await authorizeMediaLibrary();
  const albums = await queryAlbums();
  setState({ albums });
};

const fetchAlbumAssets = async albumID => {
  return await queryMedia({ albumID });
};

const uniqueAssets = assets => uniqBy(assets, 'assetID');
// const uniqueAlbums = albums => uniqBy(albums, 'albumID');

const updateAlbumAssets = async (
  state: State,
  setState: SetState,
  albumID: string
) => {
  const { assets, albumAssets } = state;
  const currentAlbumAssets = await fetchAlbumAssets(albumID);
  const previousAlbumAssetIDs = selectAlbumAssetIDs(state, albumID);
  setState({
    assets: uniqueAssets([...assets, ...currentAlbumAssets]),
    albumAssets: {
      ...albumAssets,
      [albumID]: uniq([
        ...previousAlbumAssetIDs,
        ...map(currentAlbumAssets, 'assetID'),
      ]),
    },
  });
};

const selectAlbumAssetIDs = (state: State, albumID: string): string[] => {
  if (state.albumAssets.hasOwnProperty(albumID)) {
    const albumAssets = state.albumAssets[albumID];
    return albumAssets;
  }
  return [];
};

storiesOf('Albums', module).add('Album Explorer', () => (
  <SafeAreaView style={styles.container}>
    <StorybookStateWrapper
      initialState={initialState}
      onMount={(state, setState) => {
        authorizeAndLoadAlbums(state, setState);
      }}
      render={(getState: GetState, setState: SetState) => {
        const state = getState();
        return (
          <AlbumExplorer
            albums={state.albums}
            style={styles.explorer}
            thumbnailAssetIDForAlbumID={albumID => {
              const state = getState();
              const assetIDs = selectAlbumAssetIDs(state, albumID);
              if (!assetIDs.length) {
                // TODO check if currently loading
                updateAlbumAssets(state, setState, albumID);
                return;
              }
              return assetIDs[0];
            }}
          />
        );
      }}
    />
  </SafeAreaView>
));
