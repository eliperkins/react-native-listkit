import UIKit
import Foundation
import IGListKit

protocol ReactViewCellSizingDelegate: class {
  func reactCell(_ cell: ReactViewCell, didCalculateHeight height: CGFloat)
}

final class ReactViewCell: UICollectionViewCell, CellReusable {
  enum Defaults {
    static var height: CGFloat = 130
  }

  // MARK: - Properties

  var rootView: RCTRootView?
  weak var delegate: ReactViewCellSizingDelegate?

  // MARK: - UICollectionView

  override func preferredLayoutAttributesFitting(
    _ layoutAttributes: UICollectionViewLayoutAttributes
  ) -> UICollectionViewLayoutAttributes {
    setNeedsLayout()
    layoutIfNeeded()
    let size = contentView.systemLayoutSizeFitting(layoutAttributes.size)
    var newFrame = layoutAttributes.frame
    newFrame.size.width = ceil(size.width)
    newFrame.size.height = ceil(size.height)
    layoutAttributes.frame = newFrame
    return layoutAttributes
  }

  // MARK: - Data source configuration

  func configure(for bridge: RCTBridge, moduleName: String, props: [String: AnyHashable], width: CGFloat) {
    if let rootView = rootView {
      if let currentProps = rootView.appProperties as? [String: AnyHashable] {
        if currentProps != props {
          rootView.appProperties = props
        }
      }
    } else {
      if let rootView = RCTRootView(bridge: bridge, moduleName: moduleName, initialProperties: props) {
        let size = CGSize(width: width, height: Defaults.height)
        rootView.frame = CGRect(origin: .zero, size: size)
        rootView.sizeFlexibility = .height
        rootView.translatesAutoresizingMaskIntoConstraints = false
        self.rootView = rootView

        rootView.delegate = self

        contentView.addSubview(rootView)

        NSLayoutConstraint.activate([
          rootView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
          rootView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
          rootView.topAnchor.constraint(equalTo: contentView.topAnchor),
          rootView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
          /**
           * This constraint is needed since React Native will not notify delegates for
           * intrinsic size changes, when one dimension is zero.
           * @seealso https://github.com/facebook/react-native/blob/eb1ce2816ce9e5db39c718f20785dd5572a172c3/React/Base/RCTRootView.m#L336-L355
           */
          rootView.heightAnchor.constraint(greaterThanOrEqualToConstant: 1)
        ])
      }
    }
  }
}

extension ReactViewCell: RCTRootViewDelegate {
  func rootViewDidChangeIntrinsicSize(_ rootView: RCTRootView!) {
    let size = rootView.intrinsicContentSize
    delegate?.reactCell(self, didCalculateHeight: size.height)
  }
}

extension ReactViewCell: ListBindable {
  func bindViewModel(_ viewModel: Any) {
    guard let viewModel = viewModel as? ReactViewModel else { return }
    configure(for: viewModel.bridge, moduleName: viewModel.module, props: viewModel.props, width: viewModel.width)
  }
}
