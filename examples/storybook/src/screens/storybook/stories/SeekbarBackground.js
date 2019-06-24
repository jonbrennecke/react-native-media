// @flow
import React from 'react';
import { storiesOf } from '@storybook/react-native';
import { SafeAreaView } from 'react-native';

import {
  SeekbarBackground,
  queryVideos,
  authorizeMediaLibrary,
} from '@jonbrennecke/react-native-media';

import { StorybookAsyncWrapper } from '../utils';

const styles = {
  container: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
  },
  seekbar: {
    height: 75,
    width: '100%',
  },
};

const authorizeAndLoadAssets = async () => {
  await authorizeMediaLibrary();
  return await queryVideos({ limit: 1 });
};

storiesOf('Seekbar', module).add('Seekbar Background', () => (
  <SafeAreaView style={styles.container}>
    <StorybookAsyncWrapper
      loadAsync={authorizeAndLoadAssets}
      render={assets =>
        assets &&
        assets[0] && (
          <SeekbarBackground
            style={styles.seekbar}
            assetID={assets[0].assetID}
          />
        )
      }
    />
  </SafeAreaView>
));
