// @flow
import React from 'react';
import { requireNativeComponent } from 'react-native';

import type { Style, SFC } from '../../types/react';

const NativeSeekbarView = requireNativeComponent('HSSeekbarView');

type SeekbarProps = {
  style?: ?Style,
  assetID: string,
};

const styles = {
  container: {
    overflow: 'hidden',
  },
};

export const Seekbar: SFC<SeekbarProps> = ({
  style,
  assetID,
}: SeekbarProps) => (
  <NativeSeekbarView style={[styles.container, style]} assetID={assetID} />
);
