import UIKit
import IGListKit

final class GridViewController: UIViewController {
  // MARK: - Initializers

  init(bridge: RCTBridge) {
    self.bridge = bridge
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Properties

  let bridge: RCTBridge

  // MARK: IGListKit

  fileprivate lazy var adapter: ListAdapter = {
    return ListAdapter(updater: ListAdapterUpdater(), viewController: self)
  }()

  // MARK: Views

  fileprivate let collectionView: UICollectionView = {
    let layout = GridViewSnappingLayout(
      stickyHeaders: false,
      scrollDirection: .horizontal,
      topContentInset: 0,
      stretchToEdge: true
    )
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    collectionView.backgroundColor = .gray
    collectionView.alwaysBounceHorizontal = true
    collectionView.decelerationRate = .fast
    // collectionView.contentInset = HorizontalSectionController.Insets.containerContentInset
    return collectionView
  }()

  // MARK: - UIView

  override func viewDidLoad() {
    super.viewDidLoad()

    view.addSubview(collectionView)

    if #available(iOS 11.0, *) {
      NSLayoutConstraint.activate([
        collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
        collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
        collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
      ])
    } else {
      NSLayoutConstraint.activate([
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        collectionView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor),
        collectionView.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor)
      ])
    }

    adapter.collectionView = collectionView
    adapter.dataSource = self
  }

  override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    super.viewWillTransition(to: size, with: coordinator)
    coordinator.animate(alongsideTransition: { _ in
      self.adapter.visibleSectionControllers().forEach { controller in
        controller.collectionContext?.invalidateLayout(for: controller)
      }
    })
  }
}

extension GridViewController: ListAdapterDataSource {
  func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
    return [
      GridViewModel(columns: [
        ColumnViewModel(
          title: "Wat",
          items: [
            // TODO: can't get the proper width here. Need it from the section controller 🤔
            ReactViewModel(bridge: bridge, module: "NumberCell", props: ["number" : 100], width: 330)
          ],
          viewController: self
        )
      ])
    ]
  }

  func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
    return GridSectionController()
  }

  func emptyView(for listAdapter: ListAdapter) -> UIView? {
    return nil
  }
}