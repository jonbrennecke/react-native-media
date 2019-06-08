import React from 'react';
import { storiesOf } from '@storybook/react-native';
import { View, Text } from 'react-native';

storiesOf('Example', module).add('Hello world', () => (
  <View style={{ flex: 1, alignItems: 'center', justifyContent: 'center' }}>
    <Text>Hello World</Text>
  </View>
));
