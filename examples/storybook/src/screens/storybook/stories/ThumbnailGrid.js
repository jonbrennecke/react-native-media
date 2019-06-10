import React from 'react';
import { storiesOf } from '@storybook/react-native';
import { SafeAreaView } from 'react-native';

import {
  ThumbnailGrid,
  queryImages,
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
  return await queryImages();
};

storiesOf('Thumbnails', module).add('Thumbnail Grid', () => (
  <SafeAreaView style={styles.container}>
    <StorybookAsyncWrapper
      loadAsync={authorizeAndLoadAssets}
      render={assets => (
        <ThumbnailGrid
          style={styles.thumbnail}
          assets={assets || []}
          extraDurationStyle={styles.duration}
        />
      )}
    />
  </SafeAreaView>
));
