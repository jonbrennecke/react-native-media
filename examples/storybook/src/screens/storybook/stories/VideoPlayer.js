// @flow
import React from 'react';
import { storiesOf } from '@storybook/react-native';
import { SafeAreaView } from 'react-native';
import noop from 'lodash/noop';

import {
  VideoPlayer,
  queryVideos,
  authorizeMediaLibrary,
} from '@jonbrennecke/react-native-media';

import { StorybookStateWrapper } from '../utils';

const styles = {
  container: {
    flex: 1,
  },
  video: {
    flex: 1,
  },
};

const authorizeAndLoadAssets = async (state, setState) => {
  await authorizeMediaLibrary();
  const assets = await queryVideos({ limit: 1 });
  setState({ assets });
};

storiesOf('Video', module).add('Video Player', () => (
  <SafeAreaView style={styles.container}>
    <StorybookStateWrapper
      onMount={(state, setState) => {
        authorizeAndLoadAssets(state, setState);
      }}
      initialState={{ assets: [], playbackTime: 0 }}
      render={({ assets }) =>
        assets &&
        assets[0] && (
          <VideoPlayer
            style={styles.video}
            videoID={assets[0].assetID}
            onVideoDidFailToLoad={noop}
            onVideoDidBecomeReadyToPlay={noop}
            onVideoDidPause={noop}
            onVideoDidUpdatePlaybackTime={noop}
            onVideoDidRestart={noop}
            onViewDidResize={noop}
          />
        )
      }
    />
  </SafeAreaView>
));
