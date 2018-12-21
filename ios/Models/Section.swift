struct Section {
  let identifier: String
  let items: [Item]
  let totalCount: Int
  let title: String
  let index: Int

  init(index: Int, json: JSON) {
    guard let identifier = json["id"] as? String,
      let title = json["title"] as? String,
      let itemsJSON = json["items"] as? [JSON]
      else { fatalError("Invalid section type") }
    self.identifier = identifier
    self.title = title
    let items = itemsJSON.map(Item.init)
    self.items = items
    self.totalCount = json["totalCount"] as? Int ?? items.count
    self.index = index
  }
}
