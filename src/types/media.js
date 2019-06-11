// @flow
export type MediaType = 'video' | 'image' | 'any';

export type MediaObject = {
  assetID: string,
  duration: number,
  mediaType: MediaType,
};
