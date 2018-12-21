import UIKit
import IGListKit

final class ColumnCell: UICollectionViewCell, CellReusable {
  let collectionView: UICollectionView
  let titleLabel = UILabel(frame: .zero)
  let countLabel = LabelView(frame: .zero)

  override func prepareForReuse() {
    super.prepareForReuse()
    collectionView.contentOffset = .zero
    collectionView.dataSource = nil
    collectionView.delegate = nil
    titleLabel.text = nil
    countLabel.text = nil
  }

  // MARK: - Initializers

  override init(frame: CGRect) {
    collectionView = UICollectionView(frame: frame, collectionViewLayout: UICollectionViewFlowLayout())

    super.init(frame: frame)

    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    titleLabel.font = .preferredFont(forTextStyle: .headline)
    titleLabel.textColor = .darkText
    contentView.addSubview(titleLabel)

    countLabel.translatesAutoresizingMaskIntoConstraints = false
    countLabel.setContentHuggingPriority(UILayoutPriority.required, for: .horizontal)
    contentView.addSubview(countLabel)

    collectionView.backgroundColor = .clear
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    collectionView.alwaysBounceVertical = true
    contentView.addSubview(collectionView)

    backgroundColor = .white
    layer.cornerRadius = 5.0
    layer.borderWidth = 1 / UIScreen.main.scale
    layer.borderColor = UIColor.lightGray.cgColor

    NSLayoutConstraint.activate([
      countLabel.topAnchor.constraint(greaterThanOrEqualTo: contentView.topAnchor, constant: 8.0),
      countLabel.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 8.0),
      countLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8.0),
      countLabel.bottomAnchor.constraint(lessThanOrEqualTo: collectionView.topAnchor),
      countLabel.textLabel.firstBaselineAnchor.constraint(equalTo: titleLabel.firstBaselineAnchor),
      titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8.0),
      titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8.0),
      collectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8.0),
      collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
      collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
      collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor)
    ])
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - UICollectionViewCell

  override func preferredLayoutAttributesFitting(
    _ layoutAttributes: UICollectionViewLayoutAttributes
  ) -> UICollectionViewLayoutAttributes {
    setNeedsLayout()
    layoutIfNeeded()
    let size = contentView.systemLayoutSizeFitting(layoutAttributes.size)
    var newFrame = layoutAttributes.frame
    newFrame.size.height = ceil(size.height)
    layoutAttributes.frame = newFrame
    return layoutAttributes
  }
}

extension ColumnCell: ListBindable {
  func bindViewModel(_ viewModel: Any) {
    guard let viewModel = viewModel as? ColumnViewModel else { fatalError() }
    titleLabel.text = viewModel.title
    countLabel.text = String(viewModel.totalCount)
    viewModel.adapter.collectionView = collectionView
  }
}
