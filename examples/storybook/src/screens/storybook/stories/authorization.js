// @flow
import React from 'react';
import { storiesOf } from '@storybook/react-native';
import { SafeAreaView, Text, Button } from 'react-native';
import {
  authorizeMediaLibrary,
  isMediaLibraryAuthorized
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

const checkAuthorization = async (state, setState) => {
  const isAuthorized = await isMediaLibraryAuthorized();
  setState({
    isAuthorized
  });
};

storiesOf('Authorization', module).add('Media Library Authorization', () => (
  <SafeAreaView style={styles.container}>
    <StorybookStateWrapper
      onMount={(state, setState) => {
        checkAuthorization(state, setState);
      }}
      initialState={{ isAuthorized: false }}
      render={(getState, setState) => (
        <>
          <Text>{`Authorized: ${getState().isAuthorized ? 'Yes' : 'No'}`}</Text>
          <Button
            title="Authorize"
            onPress={async () => {
              await authorizeMediaLibrary();
              checkAuthorization(getState(), setState);
            }}
          />
        </>
      )}
    />
  </SafeAreaView>
));
