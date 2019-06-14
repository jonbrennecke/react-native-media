// @flow
import React from 'react';
import { View, FlatList } from 'react-native';
import noop from 'lodash/noop';
import sortBy from 'lodash/sortBy';

import { AlbumExplorerItem } from '../AlbumExplorerItem';

import type { SFC, Style, AlbumObject } from '../../types';

export type AlbumExplorerProps = {
  style?: ?Style,
  albums: AlbumObject[],
  thumbnailAssetIDForAlbumID: (albumID: string) => ?string,
  onPressAlbum?: (albumID: string) => void,
  onRequestLoadMore?: () => void,
};

const styles = {
  container: {},
};

export const AlbumExplorer: SFC<AlbumExplorerProps> = ({
  style,
  albums,
  onPressAlbum = noop,
  thumbnailAssetIDForAlbumID,
  onRequestLoadMore,
}: AlbumExplorerProps) => (
  <View style={[styles.container, style]}>
    <FlatList
      numColumns={1}
      enableEmptySections
      horizontal={false}
      data={sortAlbums(albums)}
      keyExtractor={album => album.albumID}
      removeClippedSubviews
      initialNumToRender={15}
      renderItem={({ item: album }) => (
        <AlbumExplorerItem
          album={album}
          onPressAlbum={onPressAlbum}
          thumbnailAssetIDForAlbumID={thumbnailAssetIDForAlbumID}
        />
      )}
      onEndReached={({ distanceFromEnd }) => {
        if (distanceFromEnd < 0) {
          return;
        }
        onRequestLoadMore && onRequestLoadMore();
      }}
      onEndReachedThreshold={0.75}
    />
  </View>
);

const sortAlbums = albums => sortBy(albums, 'title');
