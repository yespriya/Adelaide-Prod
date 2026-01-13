import UIKit

@IBDesignable
class ErrorHandlingTextfeild: UITextField {

    // MARK: - Properties
    private var errorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .red
        label.font = UIFont.systemFont(ofSize: 10)
        label.numberOfLines = 0
        label.isHidden = true // Initially hidden
        return label
    }()

    @IBInspectable var errorMessage: String? {
        didSet {
            errorLabel.text = errorMessage
            errorLabel.isHidden = (errorMessage == nil || errorMessage?.isEmpty == true)
            invalidateIntrinsicContentSize() // Recalculate height when error message changes
        }
    }

    @IBInspectable var placeholderText: String? {
        didSet {
            self.placeholder = placeholderText
        }
    }

    @IBInspectable var borderColor: UIColor = .lightGray {
        didSet {
            self.layer.borderColor = borderColor.cgColor
        }
    }

    @IBInspectable var borderWidth: CGFloat = 1.0 {
        didSet {
            self.layer.borderWidth = borderWidth
        }
    }

    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }

    // MARK: - Setup Views
    private func setupViews() {
        self.borderStyle = .roundedRect
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor.cgColor

        // Adding the error label to the superview
        addSubview(errorLabel)

        // Constraints for error label
        NSLayoutConstraint.activate([
            errorLabel.topAnchor.constraint(equalTo: self.bottomAnchor, constant: 4),
            errorLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            errorLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }

    // MARK: - Adjust Intrinsic Content Size
    override var intrinsicContentSize: CGSize {
        let textFieldHeight: CGFloat = 10 // Fixed height for the text field
        let errorLabelHeight = errorLabel.isHidden ? 0 : errorLabel.intrinsicContentSize.height + 4
        return CGSize(width: super.intrinsicContentSize.width, height: textFieldHeight + errorLabelHeight)
    }

    // MARK: - Interface Builder Live Rendering
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setupViews()
    }

    // MARK: - Error Handling
    func showError(_ message: String?) {
        errorMessage = message
    }

    func hideError() {
        errorMessage = nil
    }
}

