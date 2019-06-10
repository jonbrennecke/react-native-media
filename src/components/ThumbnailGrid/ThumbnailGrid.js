// @flow
import React from 'react';
import { Text, View, Dimensions, TouchableOpacity } from 'react-native';
import noop from 'lodash/noop';

import { Thumbnail } from '../Thumbnail';

import type { SFC, Style, MediaObject } from '../../types';

type Props = {
  style?: ?Style,
  extraDurationStyle?: ?Style,
  assets: MediaObject[],
  onPressThumbnail?: (video: MediaObject) => void,
};

const { width: SCREEN_WIDTH } = Dimensions.get('window');

const styles = {
  container: {
    flexDirection: 'row',
    flexWrap: 'wrap',
    alignItems: 'flex-start',
  },
  thumbnailWrap: {
    width: SCREEN_WIDTH / 3,
    height: SCREEN_WIDTH / 3 * (4 / 3),
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

export const ThumbnailGrid: SFC<Props> = ({
  style,
  assets,
  extraDurationStyle,
  onPressThumbnail = noop,
}: Props) => (
  <View style={[styles.container, style]}>
    {assets.map(asset => (
      <TouchableOpacity
        key={asset.assetID}
        onPress={() => onPressThumbnail(asset)}
      >
        <View style={styles.thumbnailWrap}>
          <Thumbnail style={styles.thumbnail} assetID={asset.assetID} />
          <Text numberOfLines={1} style={[styles.duration, extraDurationStyle]}>
            {formatDuration(asset.duration)}
          </Text>
        </View>
      </TouchableOpacity>
    ))}
  </View>
);

const formatDuration = (duration: number): string => {
  const minutes = parseInt(duration / 60).toFixed(0);
  const seconds = parseInt(duration % 60)
    .toFixed(0)
    .padStart(2, '0');
  return `${minutes}:${seconds}`;
};
