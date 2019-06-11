// @flow
import { PureComponent } from 'react';

import type { Element } from 'react';

export type StorybookAsyncWrapperProps<T> = {
  loadAsync: () => Promise<T>,
  render: (data: ?T) => ?Element<*>,
};

export type StorybookAsyncWrapperState<T> = {
  data: ?T,
};

export class StorybookAsyncWrapper<T> extends PureComponent<
  StorybookAsyncWrapperProps<T>,
  StorybookAsyncWrapperState<T>
> {
  state: StorybookAsyncWrapperState<T> = {
    data: null,
  };

  async componentDidMount() {
    const data = await this.props.loadAsync();
    this.setState({ data });
  }

  async componentWillReceiveProps(nextProps: StorybookAsyncWrapperProps<T>) {
    const data = await nextProps.loadAsync();
    this.setState({ data });
  }

  render() {
    // $FlowFixMe
    return this.props.render(this.state.data);
  }
}
