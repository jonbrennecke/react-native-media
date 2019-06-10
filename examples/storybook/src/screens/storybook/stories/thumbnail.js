import React from 'react';
import { storiesOf } from '@storybook/react-native';
import { View } from 'react-native';

import { Thumbnail, loadImageAssets, authorizeMediaLibrary } from '@jonbrennecke/react-native-media';

import { StorybookAsyncWrapper } from '../utils';

const styles = {
  container: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center'
  },
  thumbnail: {
    height: 75,
    width: 75
  }
};

const authorizeAndLoadAssets = async () => {
  await authorizeMediaLibrary();
  return await loadImageAssets();
};

storiesOf('Media library', module).add('<Thumbnail/>', () => (
  <View style={styles.container}>
    <StorybookAsyncWrapper
      loadAsync={authorizeAndLoadAssets}
      render={assets =>
        assets && assets.map(({ assetID }) => (
          <Thumbnail style={styles.thumbnail} key={assetID} assetID={assetID} />
        ))
      }
    />
  </View>
));
