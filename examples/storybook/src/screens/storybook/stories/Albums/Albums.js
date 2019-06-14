// @flow
import React from 'react';
import { storiesOf } from '@storybook/react-native';
import { SafeAreaView } from 'react-native';
import {
  AlbumExplorer,
  authorizeMediaLibrary,
  MediaStateContainer,
} from '@jonbrennecke/react-native-media';
import { Provider } from 'react-redux';
import noop from 'lodash/noop';

import { createReduxStore } from './mediaStore';
import { StorybookAsyncWrapper } from '../../utils/StorybookAsyncWrapper';

const store = createReduxStore();

const styles = {
  container: {
    flex: 1,
  },
  explorer: {
    flex: 1,
  },
};

const Component = MediaStateContainer(
  ({
    albums,
    assetsForAlbum,
    isLoadingAssetsForAlbum,
    queryMedia,
    queryAlbums,
  }) => (
  <StorybookAsyncWrapper
    loadAsync={async () => {
      await authorizeMediaLibrary();
      await queryAlbums({});
    }}
    render={() => (
      <AlbumExplorer
        albums={albums.toJSON()}
        style={styles.explorer}
        onPressAlbum={noop}
        thumbnailAssetIDForAlbumID={albumID => {
          const assets = assetsForAlbum(albumID);
          if (assets && assets.loadingStatus !== 'isLoading') {
            return assets.assetIDs.first();
          }
          if (!isLoadingAssetsForAlbum(albumID)) {
            queryMedia({ albumID })
            return; // TODO: add loading UI
          }
          return;
        }}
      />
    )}
  />
));

storiesOf('Albums', module).add('Album Explorer', () => (
  <Provider store={store}>
    <SafeAreaView style={styles.container}>
      <Component />
    </SafeAreaView>
  </Provider>
));
