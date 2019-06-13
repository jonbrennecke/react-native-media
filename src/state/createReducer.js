// @flow
import { handleActions, createAction } from 'redux-actions';

import type { Action, Reducer, Dispatch } from '../types';

// Necessary for some reason, putting any in directly doesn't work
type AnyPayload = any;

// eslint-disable-next-line no-unused-vars
type GetPayloadType<Payload: *, Fn: (any, Action<Payload>) => any> = Payload;

type MapActions = <Payload>(
  (any, Action<Payload>) => any
) => Payload => Action<Payload>;

type MapActionCreators = <Payload>(
  (any, Action<Payload>) => any
) => Payload => (dispatch: Dispatch<Payload>) => void;

export function createReducer<
  State,
  Reducers: { [key: string]: Reducer<State, AnyPayload> }
>(
  initialState: State,
  reducers: Reducers
): {
  reducer: $Call<handleActions<State, Action<AnyPayload>>>,
  actions: $ObjMap<Reducers, MapActions>,
  actionCreators: $ObjMap<Reducers, MapActionCreators>,
} {
  const actions = Object.keys(reducers).reduce(
    (actions, key) => ({
      ...actions,
      [key]: createAction(key),
    }),
    {}
  );

  const actionCreators = Object.keys(reducers).reduce(
    (actionCreators, key) => ({
      ...actionCreators,
      [key]: (...args) => dispatch => dispatch(actions[key](...args)),
    }),
    {}
  );

  return {
    // $FlowFixMe (types fine as `handleActions<State, Action<Payload>>(...)`, but breaks babel)
    reducer: handleActions(reducers, initialState),
    actions,
    actionCreators,
  };
}
