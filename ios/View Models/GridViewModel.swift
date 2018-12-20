import IGListKit

final class GridViewModel: ListDiffable {
  let columns: [ColumnViewModel]

  init(columns: [ColumnViewModel]) {
    self.columns = columns
  }

  func diffIdentifier() -> NSObjectProtocol {
    return "grid" as NSObject
  }

  func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
    return true
  }
}
