// @flow
import React from 'react';
import { storiesOf } from '@storybook/react-native';
import { SafeAreaView, View, Text } from 'react-native';

import {
  queryAlbums,
  authorizeMediaLibrary
} from '@jonbrennecke/react-native-media';

import { StorybookStateWrapper } from '../utils';

const styles = {
  container: {
    flex: 1
  },
  list: {
    flex: 1,
    flexDirection: 'column'
  }
};

const authorizeAndLoadAlbums = async (state, setState) => {
  await authorizeMediaLibrary();
  const albums = await queryAlbums();
  setState({ albums });
};

storiesOf('Albums', module).add('Albums', () => (
  <SafeAreaView style={styles.container}>
    <StorybookStateWrapper
      onMount={(state, setState) => { authorizeAndLoadAlbums(state, setState); }}
      initialState={{ albums: [] }}
      render={({ albums }) => (
        <View style={styles.list}>
          {albums.map(album => (
            <Text key={album.albumID}>{album.title}</Text>
          ))}
        </View>
      )}
    />
  </SafeAreaView>
));
