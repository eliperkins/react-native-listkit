import UIKit

typealias JSON = [String: AnyHashable]

@objc(RNLGridView)
final class GridView: UIView {

  // MARK: - Native Module Exposed Props

  @objc var sections: Array<JSON> = [] {
    didSet {
      viewController.sections = sections.enumerated().map(Section.init)
    }
  }

  @objc var onSectionEndReached: RCTDirectEventBlock?

  // MARK: - Properties

  let bridge: RCTBridge
  fileprivate let viewController: GridViewController

  // MARK: - Initializers

  @objc init(bridge: RCTBridge) {
    self.bridge = bridge
    self.viewController = GridViewController(bridge: bridge)
    super.init(frame: .zero)
    addSubview(viewController.view)
    viewController.loadingDelegate = self
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - UIView

  override func didMoveToSuperview() {
    super.didMoveToSuperview()
    guard let reactViewController = reactViewController() else { return }
    reactViewController.addChild(viewController)
    viewController.didMove(toParent: reactViewController)
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    viewController.view.frame = bounds
  }
}

extension GridView: GridViewSectionLoadingDelegate {
  func gridViewWillReachEndOfSection(with identifier: String) {
    if let onSectionEndReached = onSectionEndReached {
      onSectionEndReached([
        "sectionId": identifier
      ])
    }
  }
}
