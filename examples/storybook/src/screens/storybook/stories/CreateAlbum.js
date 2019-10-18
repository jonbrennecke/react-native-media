// @flow
import React from 'react';
import { SafeAreaView, Button } from 'react-native';
import { storiesOf } from '@storybook/react-native';

import { createAlbum } from '@jonbrennecke/react-native-media';

const styles = {
  container: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
  },
};

storiesOf('Albums', module).add('Create Album', () => (
  <SafeAreaView style={styles.container}>
    <Button
      title="Create Album"
      onPress={async () => {
        const album = await createAlbum('Test album');
        // eslint-disable-next-line no-console
        console.log(album);
      }}
    />
  </SafeAreaView>
));
