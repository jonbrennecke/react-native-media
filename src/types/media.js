// @flow
export type MediaType = 'video' | 'image' | 'any';

export type MediaObject = {
  assetID: string,
  duration: number,
  mediaType: MediaType,
};

export type Size = {
  width: number,
  height: number,
};

export type Orientation =
  | 'left'
  | 'leftMirrored'
  | 'right'
  | 'rightMirrored'
  | 'up'
  | 'upMirrored'
  | 'down'
  | 'downMirrored';
