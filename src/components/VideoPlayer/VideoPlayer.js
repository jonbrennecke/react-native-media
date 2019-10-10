// @flow
import React, { Component } from 'react';
import Bluebird from 'bluebird';
import { autobind } from 'core-decorators';
import { View, requireNativeComponent, NativeModules } from 'react-native';

import type { Style } from '../../types/react';
import type { Size, Orientation } from '../../types/media';

const NativeVideoPlayerView = requireNativeComponent('HSVideoPlayerView');
const { HSVideoPlayerViewManager: _VideoPlayerViewManager } = NativeModules;
const VideoPlayerViewManager = Bluebird.promisifyAll(_VideoPlayerViewManager);

export type PlaybackState = 'playing' | 'paused' | 'waiting' | 'readyToPlay';

type ReactNativeFiberHostComponent = any;

type Props = {
  style?: ?Style,
  assetID: string,
  onVideoDidFailToLoad?: () => void,
  onPlaybackTimeDidUpdate?: (playbackTime: number, duration: number) => void,
  onVideoWillRestart?: () => void,
  onViewDidResize?: Size => void,
  onPlaybackStateDidChange?: PlaybackState => void,
  onOrientationDidLoad?: Orientation => void,
};

const styles = {
  container: {},
  nativeView: {
    flex: 1,
    borderRadius: 3,
    overflow: 'hidden',
  },
};

// $FlowFixMe
@autobind
export class VideoPlayer extends Component<Props> {
  nativeComponentRef: ?ReactNativeFiberHostComponent;

  async seekToTime(time: number) {
    if (!this.nativeComponentRef) {
      return;
    }
    await VideoPlayerViewManager.seekToTimeAsync(
      this.nativeComponentRef._nativeTag,
      time
    );
  }

  pause() {
    if (!this.nativeComponentRef) {
      return;
    }
    VideoPlayerViewManager.pause(this.nativeComponentRef._nativeTag);
  }

  restart() {
    if (!this.nativeComponentRef) {
      return;
    }
    VideoPlayerViewManager.restart(this.nativeComponentRef._nativeTag);
  }

  play() {
    if (!this.nativeComponentRef) {
      return;
    }
    VideoPlayerViewManager.play(this.nativeComponentRef._nativeTag);
  }

  viewDidLayout({ nativeEvent: { layout } }: any) {
    const viewSize = {
      width: layout.width,
      height: layout.height,
    };
    this.props.onViewDidResize && this.props.onViewDidResize(viewSize);
  }

  render() {
    return (
      <View
        style={[styles.container, this.props.style]}
        onLayout={this.viewDidLayout}
      >
        <NativeVideoPlayerView
          ref={ref => {
            this.nativeComponentRef = ref;
          }}
          style={styles.nativeView}
          assetID={this.props.assetID}
          onVideoDidFailToLoad={this.props.onVideoDidFailToLoad}
          onVideoWillRestart={() => {
            if (this.props.onVideoWillRestart) {
              this.props.onVideoWillRestart();
            }
          }}
          onPlaybackTimeDidUpdate={({ nativeEvent }) => {
            if (!nativeEvent) {
              return;
            }
            const { playbackTime, duration } = nativeEvent;
            if (this.props.onPlaybackTimeDidUpdate) {
              this.props.onPlaybackTimeDidUpdate(playbackTime, duration);
            }
          }}
          onPlaybackStateDidChange={({ nativeEvent }) => {
            if (!nativeEvent || !this.props.onPlaybackStateDidChange) {
              return;
            }
            this.props.onPlaybackStateDidChange(nativeEvent.playbackState);
          }}
          onOrientationDidLoad={({ nativeEvent }) => {
            if (!nativeEvent || !this.props.onOrientationDidLoad) {
              return;
            }
            this.props.onOrientationDidLoad(nativeEvent.orientation);
          }}
        />
      </View>
    );
  }
}
