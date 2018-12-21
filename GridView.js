/* @flow */

import * as React from 'react';
import { ViewPropTypes, requireNativeComponent } from 'react-native';

const RNLGridView = requireNativeComponent('RNLGridView');

export type Item = {|
  moduleName: string,
  props: mixed
|};

export type Section = {|
  // Title to display at the top of the section.
  title: string,
  // Unique identifier for this section.
  id: string,
  // Module name and props to show in collection view cells
  items: Array<Item>,
  // Total number of cells in a given section.
  totalCount: number
|};

type Props = {
  // Called when the end of a section is reached. Used to load more.
  onSectionEndReached: (sectionId: string) => void,
  sections: Array<Section>,
  style: ViewPropTypes.style
};

const GridView = ({ onSectionEndReached, ...props }: Props) => (
  <RNLGridView
    {...props}
    onSectionEndReached={({ nativeEvent }) => {
      // Since we're binding to an RCTDirectEventBlock, we need to pull the value
      // the block was called with from the native event.
      const { sectionId } = nativeEvent;
      if (onSectionEndReached != null && sectionId != null) {
        onSectionEndReached(sectionId);
      }
    }}
  />
);

export default GridView;
