import React from 'react';
import { AppRegistry, StyleSheet, Text, View } from 'react-native';

import GridView from './GridView';

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

type Props = {};

const createItems = (size = 200) =>
  Array.from(Array(size)).map((_, number) => ({
    moduleName,
    props: { number }
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

export default class App extends React.Component<Props> {
  render() {
    const sections = createSections(20);
    return <GridView style={{ flex: 1 }} sections={sections} />;
  }
}
