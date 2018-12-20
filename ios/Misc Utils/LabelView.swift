import UIKit

class LabelView: UIView {
  let textLabel = UILabel(frame: .zero)

  var text: String? {
    didSet {
      textLabel.text = text
    }
  }

  override init(frame: CGRect) {
    super.init(frame: frame)

    textLabel.setContentHuggingPriority(UILayoutPriority.required, for: .vertical)
    textLabel.setContentHuggingPriority(UILayoutPriority.required, for: .horizontal)
    textLabel.setContentCompressionResistancePriority(UILayoutPriority.required, for: .vertical)
    textLabel.translatesAutoresizingMaskIntoConstraints = false
    textLabel.textColor = .darkText
    textLabel.font = .preferredFont(forTextStyle: .callout)
    textLabel.textAlignment = .center
    addSubview(textLabel)

    backgroundColor = UIColor(white: 0.0, alpha: 0.05)
    layer.cornerRadius = 4
    setContentHuggingPriority(UILayoutPriority.required, for: .vertical)
    setContentHuggingPriority(UILayoutPriority.required, for: .horizontal)

    NSLayoutConstraint.activate([
      textLabel.topAnchor.constraint(equalTo: topAnchor),
      textLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -2),
      textLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 4),
      textLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -4)
    ])
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

