import React from 'react';
import { storiesOf } from '@storybook/react-native';
import { SafeAreaView } from 'react-native';

import {
  ThumbnailLoadMore,
  loadImageAssets,
  authorizeMediaLibrary,
} from '@jonbrennecke/react-native-media';

import { StorybookStateWrapper } from '../utils';

const styles = {
  container: {
    flex: 1,
  },
  thumbnail: {
    flex: 1,
  },
  duration: {
    color: '#fff',
  },
};

storiesOf('Thumbnails', module).add('Thumbnail Load More', () => (
  <SafeAreaView style={styles.container}>
    <StorybookStateWrapper
      initialState={{ assets: [] }}
      onMount={async (unused, setState) => {
        await authorizeMediaLibrary();
        const assets = await loadImageAssets({ limit: 5 });
        setState({ assets });
      }}
      render={({ assets }, setState) => {
        if (!assets || !assets.length) {
          return null;
        }
        const last = assets[assets.length - 1];

        const loadMore = async () => {
          const assets = await loadImageAssets({
            limit: 5,
            creationDateQuery: {
              date: last.creationDate,
              equation: 'lessThan',
            },
          });
          setState({ assets });
        };
        return (
          <ThumbnailLoadMore
            assets={assets || []}
            loadMoreText="Load More"
            extraDurationStyle={styles.duration}
            onRequestLoadMore={loadMore}
          />
        );
      }}
    />
  </SafeAreaView>
));
