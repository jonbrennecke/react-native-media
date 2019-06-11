// @flow
import React from 'react';
import { requireNativeComponent } from 'react-native';

import type { Style, SFC } from '../../types/react';

const NativeSeekbarBackgroundView = requireNativeComponent('HSSeekbarView');

type SeekbarBackgroundProps = {
  style?: ?Style,
  assetID: string,
};

const styles = {
  container: {
    overflow: 'hidden',
  },
};

export const SeekbarBackground: SFC<SeekbarBackgroundProps> = ({
  style,
  assetID,
}: SeekbarBackgroundProps) => (
  <NativeSeekbarBackgroundView
    style={[styles.container, style]}
    assetID={assetID}
  />
);
