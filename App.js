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

const NumberCell = ({ number } = { number: 1 }) => (
  <View style={styles.container}>
    <Text style={styles.text}>{number}</Text>
  </View>
);

const moduleName = 'NumberCell';
AppRegistry.registerComponent(moduleName, () => NumberCell);

const createItems = (size = 20, startingAt = 0) =>
  Array.from(Array(size)).map((_, number) => ({
    moduleName,
    props: { number: number + startingAt }
  }));

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
  sections: Array<Sections>
  loading: Set<string>,
};

export default class App extends React.Component<{}, State> {
  state = {
    sections: createSections(20),
    loading: new Set([])
  };

  loadMore = (sectionId: string) => {
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
