import IGListKit

final class ReactViewModel: ListDiffable {
  let module: String
  let props: JSON
  let bridge: RCTBridge
  let width: CGFloat

  init(bridge: RCTBridge, module: String, props: JSON, width: CGFloat) {
    self.bridge = bridge
    self.module = module
    self.props = props
    self.width = width
  }

  func diffIdentifier() -> NSObjectProtocol {
    return props.hashValue ^ width.hashValue as NSObject
  }

  func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
    return true
  }
}
