// @flow
import React, { Component } from 'react';
import { storiesOf } from '@storybook/react-native';
import { SafeAreaView, View } from 'react-native';
import { autobind } from 'core-decorators';
import {
  authorizeMediaLibrary,
  startObservingVideos,
  stopObservingVideos
} from '@jonbrennecke/react-native-media';

const styles = {
  container: {
    flex: 1
  }
};

// $FlowFixMe
@autobind
class MediaLibraryDidChangeStory extends Component<{}> {
  subscription: any;

  async componentDidMount() {
    await authorizeMediaLibrary();
    this.subscription = startObservingVideos(this.onMediaChanged);
  }

  componentWillUnmount() {
    if (this.subscription) {
      stopObservingVideos(this.subscription);
    }
  }

  onMediaChanged() {
    console.log('media library changed');
  }

  render() {
    return (
      <View/>
    );
  }
}

storiesOf('Events', module).add('Media Library Changed', () => (
  <SafeAreaView style={styles.container}>
    <MediaLibraryDidChangeStory/>
  </SafeAreaView>
));
