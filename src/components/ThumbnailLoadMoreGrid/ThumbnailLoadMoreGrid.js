// @flow
import React from 'react';
import { View, FlatList, Dimensions } from 'react-native';
import noop from 'lodash/noop';

import { ThumbnailGridItem } from '../ThumbnailGridItem';

import type { SFC, Style, MediaObject } from '../../types';

type ThumbnailLoadMoreGridProps = {
  style?: ?Style,
  extraDurationStyle?: ?Style,
  assets: MediaObject[],
  onRequestLoadMore?: () => void,
  onPressThumbnail?: (video: MediaObject) => void,
};

const { width: SCREEN_WIDTH } = Dimensions.get('window');

const styles = {
  container: {
    flex: 1,
  },
  content: {
    flexDirection: 'row',
    flexWrap: 'wrap',
    alignItems: 'flex-start',
    width: SCREEN_WIDTH
  },
  gridItem: {
    width: SCREEN_WIDTH / 3,
    height: SCREEN_WIDTH / 3 * (4 / 3)
  }
};

export const ThumbnailLoadMoreGrid: SFC<ThumbnailLoadMoreGridProps> = ({
  style,
  assets,
  extraDurationStyle,
  onRequestLoadMore,
  onPressThumbnail = noop,
}: ThumbnailLoadMoreGridProps) => (
  <View style={[styles.container, style]}>
    <FlatList
      numColumns={3}
      horizontal={false}
      data={assets}
      keyExtractor={asset => asset.assetID}
      renderItem={({ item: asset }) => (
        <ThumbnailGridItem
          style={styles.gridItem}
          asset={asset}
          extraDurationStyle={extraDurationStyle}
          onPressThumbnail={onPressThumbnail}
        />
      )}
      contentContainerStyle={styles.content}
      onEndReached={onRequestLoadMore}
    />
  </View>
);
