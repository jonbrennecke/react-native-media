import React from 'react';
import { storiesOf } from '@storybook/react-native';
import { View } from 'react-native';

import { ThumbnailView, loadVideoAssets } from '@jonbrennecke/react-native-media';

import { StorybookDataLoader } from '../utils';

storiesOf('Thumbnail view', module).add('Hello world', () => (
  <StorybookDataLoader
    loadAsync={() => loadVideoAssets()}
    render={data => {
      console.log('data', data);
      return (
        <View style={{ flex: 1, alignItems: 'center', justifyContent: 'center' }}>
          {/* <ThumbnailView videoID="asfaf" /> */}
        </View>
      );
    }}
  />
));
