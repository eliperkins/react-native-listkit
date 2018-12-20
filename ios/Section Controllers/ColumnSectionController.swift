import IGListKit

final class ColumnSectionController: ListBindingSectionController<ColumnViewModel> {
  override init() {
    super.init()
    dataSource = self
  }
}

extension ColumnSectionController: ListBindingSectionControllerDataSource {
  func sectionController(_ sectionController: ListBindingSectionController<ListDiffable>, viewModelsFor object: Any) -> [ListDiffable] {
    guard let object = object as? ColumnViewModel else { fatalError() }
    return object.items
  }

  func sectionController(_ sectionController: ListBindingSectionController<ListDiffable>, cellForViewModel viewModel: Any, at index: Int) -> UICollectionViewCell & ListBindable {
    guard let cell = collectionContext?.dequeueReusableCell(of: ReactViewCell.self, for: sectionController, at: index) as? ReactViewCell else { fatalError() }
    return cell
  }

  func sectionController(_ sectionController: ListBindingSectionController<ListDiffable>, sizeForViewModel viewModel: Any, at index: Int) -> CGSize {
    guard let context = collectionContext else {
      fatalError("No context for size")
    }
    return CGSize(width: context.containerSize.width, height: ReactViewCell.Defaults.height)
  }
}
