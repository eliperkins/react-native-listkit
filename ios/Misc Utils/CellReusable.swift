import UIKit

protocol CellReusable: class {
  static var reuseIdentifier: String { get }
}

extension CellReusable {
  static var reuseIdentifier: String {
    return String(describing: self)
  }
}

extension UICollectionView {
  func registerReusableClass(cellClass: CellReusable.Type) {
    register(cellClass, forCellWithReuseIdentifier: cellClass.reuseIdentifier)
  }
}
