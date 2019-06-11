// @flow
import type { ____DangerouslyImpreciseStyle_Internal } from 'react-native/Libraries/StyleSheet/StyleSheetTypes';

import type {
  Element,
  ChildrenArray,
  StatelessFunctionalComponent
} from 'react';

export type Style = $Shape<____DangerouslyImpreciseStyle_Internal>;

export type SFC<P> = StatelessFunctionalComponent<P>;

export type Children = ChildrenArray<?Element<*>> | string;
