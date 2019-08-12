// @flow
import React from 'react';
import { storiesOf } from '@storybook/react-native';
import { SafeAreaView } from 'react-native';
import noop from 'lodash/noop';
import {
  Seekbar,
  queryVideos,
  authorizeMediaLibrary,
} from '@jonbrennecke/react-native-media';

import { StorybookStateWrapper } from '../utils';

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
  handle: {
    backgroundColor: '#fff',
  },
};

const authorizeAndLoadAssets = async (state, setState) => {
  await authorizeMediaLibrary();
  const assets = await queryVideos({ limit: 1 });
  setState({ assets });
};

storiesOf('Seekbar', module).add('Seekbar', () => (
  <SafeAreaView style={styles.container}>
    <StorybookStateWrapper
      onMount={(state, setState) => {
        authorizeAndLoadAssets(state, setState);
      }}
      initialState={{ assets: [], playbackTime: 0 }}
      render={(getState, setState) => {
        const { assets, playbackTime } = getState();
        if (!assets || !assets[0]) {
          return null;
        }
        return (
          <Seekbar
            style={styles.seekbar}
            handleStyle={styles.handle}
            assetID={assets[0].assetID}
            duration={assets[0].duration}
            playbackTime={playbackTime}
            onSeekToTime={playbackTime => setState({ playbackTime })}
            onDidBeginDrag={noop}
            onDidEndDrag={noop}
          />
        );
      }}
    />
  </SafeAreaView>
));
