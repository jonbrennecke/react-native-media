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
  }) => {
    const loadAssetsForAlbum = albumID => queryMedia({ albumID });
    return (
      <StorybookAsyncWrapper
        loadAsync={async () => {
          await authorizeMediaLibrary();
          await queryAlbums({});
        }}
        render={() => (
          <AlbumExplorer
            albums={albums.toJSON()}
            style={styles.explorer}
            thumbnailAssetIDForAlbumID={albumID => {
              const assets = assetsForAlbum(albumID);
              if (assets && assets.loadingStatus !== 'isLoading') {
                return assets.assetIDs.first();
              }
              if (!isLoadingAssetsForAlbum(albumID)) {
                loadAssetsForAlbum(albumID);
                return; // TODO: add loading UI
              }
              return;
            }}
          />
        )}
      />
    );
  }
);

storiesOf('Albums', module).add('Album Explorer', () => (
  <Provider store={store}>
    <SafeAreaView style={styles.container}>
      <Component />
    </SafeAreaView>
  </Provider>
));
