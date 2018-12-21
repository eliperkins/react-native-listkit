/* @flow */

import * as React from 'react';
import { ViewPropTypes, requireNativeComponent } from 'react-native';

const RNLGridView = requireNativeComponent('RNLGridView');

export type Item = {|
  moduleName: string,
  props: mixed
|};

export type Section = {|
  title: string,
  id: string,
  items: Array<Item>,
  totalCount: number
|};

type Props = {
  onSectionEndReached: (sectionId: string) => void,
  sections: Array<Section>,
  style: ViewPropTypes.style
};

const GridView = ({ onSectionEndReached, ...props }: Props) => (
  <RNLGridView
    {...props}
    onSectionEndReached={({ nativeEvent }) => {
      const { sectionId } = nativeEvent;
      if (onSectionEndReached != null && sectionId != null) {
        onSectionEndReached(sectionId);
      }
    }}
  />
);

export default GridView;
