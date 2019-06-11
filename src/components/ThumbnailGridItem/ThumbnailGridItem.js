// @flow
import React from 'react';
import { Text, View, TouchableOpacity } from 'react-native';
import noop from 'lodash/noop';

import { Thumbnail } from '../Thumbnail';

import type { SFC, Style, MediaType } from '../../types';

type ThumbnailGridItemProps = {
  style?: ?Style,
  extraDurationStyle?: ?Style,
  assetID: string,
  duration: number,
  mediaType: MediaType,
  onPressThumbnail?: (assetID: string) => void,
};

const styles = {
  container: {},
  thumbnailWrap: {
    flex: 1,
    padding: 1,
  },
  thumbnail: {
    flex: 1,
    borderRadius: 3,
    overflow: 'hidden',
  },
  duration: {
    position: 'absolute',
    bottom: 0,
    right: 0,
    paddingBottom: 5,
    paddingRight: 7,
    textShadowColor: 'rgba(0,0,0,0.5)',
    textShadowOffset: {
      width: 0,
      height: 1,
    },
    textShadowRadius: 1,
    textAlign: 'right',
  },
};

export const ThumbnailGridItem: SFC<ThumbnailGridItemProps> = ({
  style,
  assetID,
  duration,
  mediaType,
  extraDurationStyle,
  onPressThumbnail = noop,
}: ThumbnailGridItemProps) => (
  <View style={[styles.container, style]}>
    <TouchableOpacity
      style={styles.thumbnailWrap}
      onPress={() => onPressThumbnail(assetID)}
    >
      <Thumbnail style={styles.thumbnail} assetID={assetID} />
      {mediaType === 'video' && (
        <Text numberOfLines={1} style={[styles.duration, extraDurationStyle]}>
          {formatDuration(duration)}
        </Text>
      )}
    </TouchableOpacity>
  </View>
);

const formatDuration = (duration: number): string => {
  const minutes = parseInt(duration / 60).toFixed(0);
  const seconds = parseInt(duration % 60)
    .toFixed(0)
    .padStart(2, '0');
  return `${minutes}:${seconds}`;
};
