// @flow
import React from 'react';
import { View } from 'react-native';

import { AlbumExplorerItem } from '../AlbumExplorerItem';

import type { SFC, Style, AlbumObject } from '../../types';

export type AlbumExplorerProps = {
  style?: ?Style,
  albums: AlbumObject[],
  onPressAlbum: (albumID: string) => void;
  thumbnailAssetIDForAlbumID: (albumID: string) => ?string,
};

const styles = {
  container: {},
};  

export const AlbumExplorer: SFC<AlbumExplorerProps> = ({
  style,
  albums,
  onPressAlbum,
  thumbnailAssetIDForAlbumID,
}: AlbumExplorerProps) => (
  <View style={[styles.container, style]}>
    {albums.map(album => (
      <AlbumExplorerItem
        key={album.albumID}
        album={album}
        onPressAlbum={onPressAlbum}
        thumbnailAssetIDForAlbumID={thumbnailAssetIDForAlbumID}
      />
    ))}
  </View>
);
