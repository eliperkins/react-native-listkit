import IGListKit

final class ColumnViewModel: NSObject, ListDiffable {
  let title: String
  let identifier: String
  let items: [ReactViewModel]
  let adapter: ListAdapter
  let totalCount: Int

  init(viewController: UIViewController, identifier: String, title: String, totalCount: Int, items: [ReactViewModel]) {
    self.title = title
    self.items = items
    self.identifier = identifier
    self.totalCount = totalCount

    self.adapter = ListAdapter(
      updater: ListAdapterUpdater(),
      viewController: viewController,
      workingRangeSize: 20
    )

    super.init()

    // This also feels... odd...
    self.adapter.dataSource = self
  }

  func diffIdentifier() -> NSObjectProtocol {
    return identifier as NSObject
  }

  func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
    return true
  }
}

extension ColumnViewModel: ListAdapterDataSource {
  func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
    // TODO: this feels.... wrong...
    return [self]
  }

  func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
    return ColumnSectionController()
  }

  func emptyView(for listAdapter: ListAdapter) -> UIView? {
    return nil
  }
}
