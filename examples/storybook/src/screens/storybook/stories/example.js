import React from 'react';
import { storiesOf } from '@storybook/react-native';
import { View } from 'react-native';

import { ThumbnailView } from '@jonbrennecke/react-native-media';

storiesOf('Thumbnail view', module).add('Hello world', () => (
  <View style={{ flex: 1, alignItems: 'center', justifyContent: 'center' }}>
    <ThumbnailView id="asfaf" />
  </View>
));
