// @flow
import React from 'react';
import { View, Text } from 'react-native';

import { Thumbnail } from '../Thumbnail';

import type { SFC, Style, AlbumObject } from '../../types';

export type Props = {
  style?: ?Style,
  album: AlbumObject,
  thumbnailAssetIDForAlbumID: (albumID: string) => ?string,
};

const styles = {
  container: {
    width: '100%',
    height: 100,
    backgroundColor: 'red',
  },
  albumTitle: {},
  thumbnail: {
    flex: 1,
  },
};

export const AlbumExplorerItem: SFC<Props> = ({
  style,
  album,
  thumbnailAssetIDForAlbumID,
}: Props) => {
  const assetID = thumbnailAssetIDForAlbumID(album.albumID);
  return (
    <View style={[styles.container, style]}>
      {assetID && <Thumbnail style={styles.thumbnail} assetID={assetID} />}
      <Text numberOfLines={1} style={styles.albumTitle}>
        {album.title}
      </Text>
    </View>
  );
};
