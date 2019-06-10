// @flow
import React from 'react';
import { requireNativeComponent } from 'react-native';

import type { SFC, Style } from '../../types';

const NativeThumbnailView = requireNativeComponent('HSThumbnailView');

export type Props = {
  style?: ?Style,
  assetID: string,
};

export const Thumbnail: SFC<Props> = ({ style, assetID }: Props) => (
  <NativeThumbnailView style={style} assetID={assetID} />
);
