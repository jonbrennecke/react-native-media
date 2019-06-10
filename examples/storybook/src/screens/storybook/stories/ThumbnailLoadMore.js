import React from 'react';
import { storiesOf } from '@storybook/react-native';
import { SafeAreaView } from 'react-native';

import {
  ThumbnailLoadMore,
  loadImageAssets,
  authorizeMediaLibrary,
} from '@jonbrennecke/react-native-media';

import { StorybookAsyncWrapper } from '../utils';

const styles = {
  container: {
    flex: 1,
  },
  thumbnail: {
    flex: 1,
  },
  duration: {
    color: '#fff',
  },
};

const authorizeAndLoadAssets = async () => {
  await authorizeMediaLibrary();
  return await loadImageAssets({ limit: 1 });
};

storiesOf('Thumbnails', module).add('Thumbnail Load More', () => (
  <SafeAreaView style={styles.container}>
    <StorybookAsyncWrapper
      loadAsync={authorizeAndLoadAssets}
      render={assets => (
        <ThumbnailLoadMore
          assets={assets || []}
          loadMoreText="Load More"
          extraDurationStyle={styles.duration}
          onRequestLoadMore={() => {}}
        />
      )}
    />
  </SafeAreaView>
));
