// @flow
import React from 'react';
import { View, Text, TouchableOpacity, StyleSheet } from 'react-native';

import { Thumbnail } from '../Thumbnail';

import type { SFC, Style, AlbumObject } from '../../types';

export type Props = {
  style?: ?Style,
  albumTitleStyle?: ?Style,
  album: AlbumObject,
  onPressAlbum: (albumID: string) => void,
  thumbnailAssetIDForAlbumID: (albumID: string) => ?string,
};

const styles = {
  container: {
    width: '100%',
    height: 170,
  },
  albumTitle: {
    position: 'absolute',
    bottom: 0,
    left: 0,
    paddingBottom: 7,
    paddingLeft: 10,
    color: '#fff',
    textShadowColor: 'rgba(0,0,0,0.5)',
    textShadowOffset: {
      width: 0,
      height: 1,
    },
    textShadowRadius: 1,
    textAlign: 'left',
    fontSize: 19,
  },
  thumbnail: {
    flex: 1,
    borderRadius: 3,
    overflow: 'hidden',
  },
  thumbnailWrap: {
    flex: 1,
    padding: 1,
  },
  thumbnailBackground: {
    ...StyleSheet.absoluteFill,
    backgroundColor: '#ccc',
    borderRadius: 3,
  },
};

export const AlbumExplorerItem: SFC<Props> = ({
  style,
  album,
  albumTitleStyle,
  onPressAlbum,
  thumbnailAssetIDForAlbumID,
}: Props) => {
  const assetID = thumbnailAssetIDForAlbumID(album.albumID);
  return (
    <View style={[styles.container, style]}>
      <TouchableOpacity
        style={styles.thumbnailWrap}
        onPress={() => onPressAlbum(album.albumID)}
      >
        <View style={styles.thumbnailBackground} />
        {assetID && (
          <Thumbnail style={styles.thumbnail} assetID={assetID} resizeCover />
        )}
      </TouchableOpacity>
      <Text numberOfLines={1} style={[styles.albumTitle, albumTitleStyle]}>
        {album.title}
      </Text>
    </View>
  );
};
