// @flow
import React from 'react';
import { SafeAreaView } from 'react-native';
import { storiesOf } from '@storybook/react-native';

const styles = {
  container: {
    flex: 1,
  },
};

storiesOf('Albums', module).add('Create Album', () => (
  <SafeAreaView style={styles.container}>
    
  </SafeAreaView>
));
