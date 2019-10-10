// @flow
export type MediaType = 'video' | 'image' | 'any';

export type MediaObject = {
  assetID: string,
  duration: number,
  mediaType: MediaType,
  creationDate: string, // ISO 8601 date string
  size: Size,
};

export type AlbumObject = {
  albumID: string,
  count: number,
  title: string,
  startDate: string,
  endDate: string,
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
