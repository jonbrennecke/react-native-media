// @flow
import React from 'react';
import { requireNativeComponent } from 'react-native';

import type { SFC, Style } from '../../types';

const NativeThumbnailView = requireNativeComponent('HSThumbnailView');

export type ThumbnailProps = {
  style?: ?Style,
  assetID: string,
};

export const Thumbnail: SFC<ThumbnailProps> = ({
  style,
  assetID,
}: ThumbnailProps) => <NativeThumbnailView style={style} assetID={assetID} />;
