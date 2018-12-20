import React from 'react';
import {
  AppRegistry,
  StyleSheet,
  Text,
  View,
  requireNativeComponent
} from 'react-native';

const GridView = requireNativeComponent('RNLGridView');

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

const createItems = (size = 20) =>
  new Array(20).map((x, number) => ({
    moduleName,
    props: { number }
  }));

export default class App extends React.Component<Props> {
  render() {
    const items = createItems(20);
    return (
      <GridView
        style={{ flex: 1 }}
        sections={[
          {
            title: 'Section 1',
            items
          }
        ]}
      />
    );
  }
}
