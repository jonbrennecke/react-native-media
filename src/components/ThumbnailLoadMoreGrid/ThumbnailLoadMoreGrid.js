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
  flatListProps?: Object,
  onRequestLoadMore?: () => void,
  onPressThumbnail?: (asssetID: string) => void,
};

const { width: SCREEN_WIDTH } = Dimensions.get('window');

const GRID_ITEM_WIDTH = SCREEN_WIDTH / 3;
const GRID_ITEM_HEIGHT = GRID_ITEM_WIDTH * (4 / 3);

const styles = {
  container: {
    flex: 1,
  },
  gridItem: {
    width: GRID_ITEM_WIDTH,
    height: GRID_ITEM_HEIGHT,
  },
};

export const ThumbnailLoadMoreGrid: SFC<ThumbnailLoadMoreGridProps> = ({
  style,
  assets,
  extraDurationStyle,
  onRequestLoadMore,
  onPressThumbnail = noop,
  flatListProps = {},
}: ThumbnailLoadMoreGridProps) => (
  <View style={[styles.container, style]}>
    <FlatList
      numColumns={3}
      enableEmptySections
      horizontal={false}
      data={assets}
      keyExtractor={asset => asset.assetID}
      removeClippedSubviews
      initialNumToRender={15}
      renderItem={({ item: asset }) => (
        <ThumbnailGridItem
          style={styles.gridItem}
          assetID={asset.assetID}
          duration={asset.duration}
          mediaType={asset.mediaType}
          extraDurationStyle={extraDurationStyle}
          onPressThumbnail={onPressThumbnail}
        />
      )}
      onEndReached={({ distanceFromEnd }) => {
        if (distanceFromEnd < 0) {
          return;
        }
        onRequestLoadMore && onRequestLoadMore();
      }}
      onEndReachedThreshold={0.75}
      {...flatListProps}
    />
  </View>
);
