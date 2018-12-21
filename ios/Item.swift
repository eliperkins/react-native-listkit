struct Item {
  let props: JSON
  let moduleName: String

  init(json: JSON) {
    guard let props = json["props"] as? JSON,
      let moduleName = json["moduleName"] as? String
      else { fatalError() }
    self.props = props
    self.moduleName = moduleName
  }
}
