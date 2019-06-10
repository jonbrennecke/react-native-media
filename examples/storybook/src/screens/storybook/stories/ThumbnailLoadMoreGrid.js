import React from 'react';
import { storiesOf } from '@storybook/react-native';
import { SafeAreaView } from 'react-native';
import sortBy from 'lodash/sortBy';
import uniqBy from 'lodash/uniqBy';

import {
  ThumbnailLoadMoreGrid,
  queryImages,
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

const sortAssets = assets => uniqBy(sortBy(assets, 'creationDate').reverse(), 'assetID');

storiesOf('Thumbnails', module).add('Thumbnail Grid (Load More)', () => (
  <SafeAreaView style={styles.container}>
    <StorybookStateWrapper
      initialState={{ assets: [], hasLoadedAllAssets: false }}
      onMount={async (unused, setState) => {
        await authorizeMediaLibrary();
        const assets = await queryImages();
        setState({ assets: sortAssets(assets) });
      }}
      render={({ assets, hasLoadedAllAssets }, setState) => {
        if (!assets || !assets.length) {
          return null;
        }
        const last = assets[assets.length - 1];
        const loadMore = async () => {
          if (hasLoadedAllAssets) {
            return;
          }
          const newAssets = await queryImages({
            creationDateQuery: {
              date: last.creationDate,
              equation: 'lessThan',
            },
          });
          setState({
            assets: sortAssets([ ...assets, ...newAssets ]),
            hasLoadedAllAssets: !newAssets.length
          });
        };
        return (
          <ThumbnailLoadMoreGrid
            assets={assets || []}
            extraDurationStyle={styles.duration}
            onRequestLoadMore={loadMore}
          />
        );
      }}
    />
  </SafeAreaView>
));
