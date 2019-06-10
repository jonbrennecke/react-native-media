// @flow
import { PureComponent } from 'react';

import type { Element } from 'react';

export type Props<T> = {
  loadAsync: () => Promise<T>;
  render: (data: ?T) => ?Element<*>;
};

export type State<T> = {
  data: ?T;
};

export class StorybookAsyncWrapper<T> extends PureComponent<Props<T>, State<T>> {
  state: State<T> = {
    data: null
  };

  async componentDidMount() {
    const data = await this.props.loadAsync();
    this.setState({ data });
  }

  async componentWillReceiveProps(nextProps: Props<T>) {
    const data = await nextProps.loadAsync();
    this.setState({ data });
  }

  render() {
    return this.props.render(this.state.data);
  }
}
