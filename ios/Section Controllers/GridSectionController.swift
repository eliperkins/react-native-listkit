import IGListKit

final class GridSectionController: ListBindingSectionController<GridViewModel> {
  override init() {
    super.init()
    dataSource = self
  }
}

extension GridSectionController: ListBindingSectionControllerDataSource {
  func sectionController(_ sectionController: ListBindingSectionController<ListDiffable>, viewModelsFor object: Any) -> [ListDiffable] {
    guard let object = object as? GridViewModel else { fatalError() }
    return object.columns
  }

  func sectionController(_ sectionController: ListBindingSectionController<ListDiffable>, cellForViewModel viewModel: Any, at index: Int) -> UICollectionViewCell & ListBindable {
    guard let cell = collectionContext?.dequeueReusableCell(of: ColumnCell.self, for: sectionController, at: index) as? ColumnCell else { fatalError() }
    return cell
  }

  func sectionController(_ sectionController: ListBindingSectionController<ListDiffable>, sizeForViewModel viewModel: Any, at index: Int) -> CGSize {
    guard let context = collectionContext else {
      fatalError("No context for size")
    }
    let width = min(context.insetContainerSize.width, 330)
    return CGSize(width: width, height: context.insetContainerSize.height)
  }
}
