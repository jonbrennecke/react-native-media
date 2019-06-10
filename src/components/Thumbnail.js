// @flow
import React from 'react';
import { requireNativeComponent } from 'react-native';

import type { SFC, Style } from '../types/react';

const NativeThumbnailView = requireNativeComponent('HSThumbnailView');

export type ThumbnailProps = {
  style?: ?Style,
  videoID: string,
};

export const Thumbnail: SFC<ThumbnailProps> = ({
  style,
  videoID,
}: ThumbnailProps) => <NativeThumbnailView style={style} videoID={videoID} />;
