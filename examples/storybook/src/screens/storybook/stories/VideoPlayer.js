// @flow
import React, { PureComponent, createRef } from 'react';
import { autobind } from 'core-decorators';
import { storiesOf } from '@storybook/react-native';
import { withKnobs, button } from '@storybook/addon-knobs';
import { SafeAreaView } from 'react-native';

import {
  VideoPlayer,
  queryVideos,
  authorizeMediaLibrary,
} from '@jonbrennecke/react-native-media';

import type { MediaObject } from '@jonbrennecke/react-native-media';

const styles = {
  container: {
    flex: 1,
  },
  video: {
    flex: 1,
  },
};

type Props = {};

type State = {
  assets: Array<MediaObject>,
};

// $FlowFixMe
@autobind
class StoryComponent extends PureComponent<Props, State> {
  videoPlayerRef = createRef();
  state = {
    assets: [],
  };
  
  async componentDidMount() {
    await authorizeMediaLibrary();
    const assets = await queryVideos({ limit: 1 });
    this.setState({ assets });
  }

  configureButtons() {
    button('Play', () => {
      if (this.videoPlayerRef.current) {
        this.videoPlayerRef.current.play();
      }
    });
    button('Pause', () => {
      if (this.videoPlayerRef.current) {
        this.videoPlayerRef.current.pause();
      }
    });
    button('Seek to beginning', () => {
      if (this.videoPlayerRef.current) {
        this.videoPlayerRef.current.seekToTime(0);
      }
    });
  }

  render() {
    this.configureButtons();
    const { assets } = this.state;
    if (!assets || !assets.length) {
      return null;
    }
    return (
      <VideoPlayer
        ref={this.videoPlayerRef}
        style={styles.video}
        assetID={assets[0].assetID}
        onVideoDidFailToLoad={() => {
          // eslint-disable-next-line no-console
          console.log('video failed to load');
        }}
        onVideoDidUpdatePlaybackTime={progress => {
          // eslint-disable-next-line no-console
          console.log(`progress: ${progress}`);
        }}
        onPlaybackStateDidChange={playbackState => {
          // eslint-disable-next-line no-console
          console.log(`playback state: ${playbackState}`);
        }}
        onVideoDidRestart={() => {
          // eslint-disable-next-line no-console
          console.log('video restarted');
        }}
        onOrientationDidLoad={orientation => {
          // eslint-disable-next-line no-console
          console.log(`Orientation: ${orientation}`);
        }}
      />
    );
  }
}

const stories = storiesOf('Video', module)
stories.addDecorator(withKnobs);
stories.add('Video Player', () => (
  <SafeAreaView style={styles.container}>
    <StoryComponent/>
  </SafeAreaView>
));
