// @flow
import React from 'react';
import { storiesOf } from '@storybook/react-native';
import { SafeAreaView } from 'react-native';

import {
  Thumbnail,
  queryImages,
  authorizeMediaLibrary,
} from '@jonbrennecke/react-native-media';

import { StorybookAsyncWrapper } from '../utils';

const styles = {
  container: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
  },
  thumbnail: {
    height: 75,
    width: 75,
  },
};

const authorizeAndLoadAssets = async () => {
  await authorizeMediaLibrary();
  return await queryImages({ limit: 3 });
};

storiesOf('Thumbnails', module).add('Thumbnail', () => (
  <SafeAreaView style={styles.container}>
    <StorybookAsyncWrapper
      loadAsync={authorizeAndLoadAssets}
      render={assets =>
        assets &&
        assets.map(({ assetID }) => (
          <Thumbnail style={styles.thumbnail} key={assetID} assetID={assetID} />
        ))
      }
    />
  </SafeAreaView>
));
