import React from 'react';
import { AppRegistry, StyleSheet, Text, View } from 'react-native';

import GridView from './GridView';
import type { Section } from './GridView';

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: 'tomato',
    padding: 16
  },
  text: {
    fontSize: 32,
    textAlign: 'center'
  }
});

// Demo component that we'll load in each collection view cell
const NumberCell = ({ number } = { number: 1 }) => (
  <View style={styles.container}>
    <Text style={styles.text}>{number}</Text>
  </View>
);

// Since our UICollectionViewCell will contain a RCTRootView, we've gotta register this
// component here to instantiate it natively.
const moduleName = 'NumberCell';
AppRegistry.registerComponent(moduleName, () => NumberCell);

// Creates a set of props for a number of items.
const createItems = (size = 20) =>
  Array.from(Array(size)).map((_, number) => ({
    moduleName,
    props: { number }
  }));

// Creates a set of sections, with an array of items inside.
const createSections = (size = 20) =>
  Array.from(Array(size)).map((_, number) => {
    const items = createItems();
    return {
      title: `Section ${number}`,
      id: number.toString(),
      items: items,
      totalCount: items * 10
    };
  });

type State = {
  // Used to populate the collection view.
  sections: Array<Sections>,

  // Used to prevent loading the same section multiple times.
  loading: Set<string>
};

export default class App extends React.Component<{}, State> {
  state = {
    sections: createSections(20),
    loading: new Set([])
  };

  loadMore = (sectionId: string) => {
    // Fakes doing a network request and replacing the necessary state.
    setTimeout(() => {
      const sectionIndex = parseInt(sectionId);
      const { items: oldItems } = this.state.sections[sectionIndex];
      const newSections = [...this.state.sections];
      const sectionToUpdate = newSections[sectionIndex];
      const newSection = {
        ...sectionToUpdate,
        items: createItems(oldItems.length + 20)
      };
      newSections[sectionIndex] = newSection;
      this.state.loading.delete(sectionId);
      this.setState({
        sections: newSections,
        loading: new Set(this.state.loading)
      });
    }, 3000);
  };

  onSectionEndReached = (sectionId: string) => {
    if (!this.state.loading.has(sectionId)) {
      this.setState({ loading: new Set(this.state.loading.add(sectionId)) });
      this.loadMore(sectionId);
    }
  };

  render() {
    return (
      <GridView
        style={{ flex: 1 }}
        sections={this.state.sections}
        onSectionEndReached={this.onSectionEndReached}
      />
    );
  }
}
