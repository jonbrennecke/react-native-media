// @flow
import StyleSheetPropType from 'react-native/Libraries/StyleSheet/StyleSheetPropType';
import ViewStylePropTypes from 'react-native/Libraries/Components/View/ViewStylePropTypes';

import type { StatelessFunctionalComponent } from 'react';

const stylePropType = StyleSheetPropType(ViewStylePropTypes);

export type Style = stylePropType;

export type SFC<P> = StatelessFunctionalComponent<P>;
