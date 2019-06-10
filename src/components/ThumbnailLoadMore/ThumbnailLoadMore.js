// @flow
import React from 'react';
import { View, TouchableOpacity, Text } from 'react-native';
import noop from 'lodash/noop';

import { ThumbnailGrid } from '../ThumbnailGrid';

import type { SFC, Style, MediaObject } from '../../types';

type Props = {
  style?: ?Style,
  extraDurationStyle?: ?Style,
  loadMoreText: string,
  assets: MediaObject[],
  onRequestLoadMore?: () => void,
  onPressThumbnail?: (video: MediaObject) => void,
};

const styles = {
  container: {
    flex: 1,
  },
  grid: {},
  loadMoreText: {},
};

export const ThumbnailLoadMore: SFC<Props> = ({
  style,
  assets,
  loadMoreText,
  extraDurationStyle,
  onRequestLoadMore,
  onPressThumbnail = noop,
}: Props) => (
  <View style={[styles.container, style]}>
    <ThumbnailGrid
      style={styles.grid}
      assets={assets}
      extraDurationStyle={extraDurationStyle}
      onPressThumbnail={onPressThumbnail}
    />
    {onRequestLoadMore && (
      <TouchableOpacity onPress={onRequestLoadMore}>
        <Text numberOfLines={1} style={styles.loadMoreText}>
          {loadMoreText}
        </Text>
      </TouchableOpacity>
    )}
  </View>
);
