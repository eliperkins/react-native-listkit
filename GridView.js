/* @flow */

import * as React from 'react';
import { requireNativeComponent } from 'react-native';

const RNLGridView = requireNativeComponent('RNLGridView');

const GridView = ({ onSectionEndReached, ...props }) => (
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
