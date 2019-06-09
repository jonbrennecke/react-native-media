// @flow
import React from 'react';
import { requireNativeComponent } from 'react-native';

import type { SFC, Style } from './types/react';

const NativeThumbnailView = requireNativeComponent('HSThumbnailView');

export type ThumbnailViewProps = {
  style?: ?Style;
  videoID: string;
};

export const ThumbnailView: SFC<ThumbnailViewProps> = ({
  style,
  videoID
}: ThumbnailViewProps) => (
  <NativeThumbnailView
    style={style}
    localIdentifier={videoID}
  />
);
