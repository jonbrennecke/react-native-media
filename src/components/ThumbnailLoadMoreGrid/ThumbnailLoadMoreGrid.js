// @flow
import React, { PureComponent } from 'react';
import { View, FlatList, Dimensions } from 'react-native';
import noop from 'lodash/noop';

import { ThumbnailGridItem } from '../ThumbnailGridItem';

import type { SFC, Style, MediaObject } from '../../types';

type ThumbnailLoadMoreGridProps = {
  style?: ?Style,
  extraDurationStyle?: ?Style,
  assets: MediaObject[],
  onRequestLoadMore?: () => void,
  onPressThumbnail?: (asssetID: string) => void,
};

const { width: SCREEN_WIDTH } = Dimensions.get('window');

const GRID_ITEM_WIDTH = SCREEN_WIDTH / 3;
const GRID_ITEM_HEIGHT = GRID_ITEM_WIDTH * (4 / 3);

const styles = {
  container: {},
  gridItem: {
    width: GRID_ITEM_WIDTH,
    height: GRID_ITEM_HEIGHT,
  },
};

export class ThumbnailLoadMoreGrid extends PureComponent<
  ThumbnailLoadMoreGridProps
> {
  flatListRef: ?FlatList<MediaObject>;

  render() {
    const {
      style,
      assets,
      extraDurationStyle,
      onRequestLoadMore,
      onPressThumbnail = noop,
    } = this.props;
    return (
      <View style={[styles.container, style]}>
        <FlatList
          ref={ref => {
            this.flatListRef = ref;
          }}
          initialScrollIndex={0}
          enableEmptySections
          numColumns={3}
          horizontal={false}
          data={assets}
          removeClippedSubviews
          initialNumToRender={15}
          keyExtractor={asset => asset.assetID}
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
          getItemLayout={(unused, index) => ({
            length: GRID_ITEM_WIDTH,
            offset: GRID_ITEM_HEIGHT,
            index,
          })}
          onEndReached={({ distanceFromEnd }) => {
            if (distanceFromEnd < 0) {
              // this.flatListRef && this.flatListRef.scrollToOffset({
              //   offset: Math.abs(distanceFromEnd),
              //   animated: false,
              // });
              return;
            }
            onRequestLoadMore && onRequestLoadMore();
          }}
          onScrollToIndexFailed={() => console.log('here')}
          onEndReachedThreshold={0.75}
        />
      </View>
    );
  }
}
