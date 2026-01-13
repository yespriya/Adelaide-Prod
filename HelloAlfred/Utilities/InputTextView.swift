import UIKit

@IBDesignable
open class InputTextView: UITextView {

    // MARK: - Properties

    open override var text: String! {
        didSet {
            postTextViewDidChangeNotification()
        }
    }

    open override var attributedText: NSAttributedString! {
        didSet {
            postTextViewDidChangeNotification()
        }
    }

    /// The placeholder text that appears when there is no text
    open var placeholder: String? = "Aa" {
        didSet {
            placeholderLabel.text = placeholder
        }
    }

    /// The UILabel that holds the InputTextView's placeholder text
    public let placeholderLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .lightGray
        label.text = "Aa"
        label.backgroundColor = .clear
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    /// The placeholderLabel's textColor
    open var placeholderTextColor: UIColor? = .lightGray {
        didSet {
            placeholderLabel.textColor = placeholderTextColor
        }
    }

    /// The UIEdgeInsets the placeholderLabel has within the InputTextView
    open var placeholderLabelInsets: UIEdgeInsets = UIEdgeInsets(top: 8, left: 4, bottom: 8, right: 4) {
        didSet {
            updateConstraintsForPlaceholderLabel()
        }
    }

    /// The font of the InputTextView. When set the placeholderLabel's font is also updated
    open override var font: UIFont! {
        didSet {
            placeholderLabel.font = font
        }
    }

    /// The textAlignment of the InputTextView. When set the placeholderLabel's textAlignment is also updated
    open override var textAlignment: NSTextAlignment {
        didSet {
            placeholderLabel.textAlignment = textAlignment
        }
    }

    // MARK: - Editable Handling

    open override var isEditable: Bool {
        didSet {
            handleEditableState()
        }
    }

    // MARK: - Border Properties

    /// The border color of the InputTextView
    @IBInspectable open var borderColor: UIColor = .lightGray {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }

    /// The border width of the InputTextView
    @IBInspectable open var borderWidth: CGFloat = 1.0 {
        didSet {
            layer.borderWidth = showBorder ? borderWidth : 0
        }
    }

    /// Toggles border visibility
    @IBInspectable open var showBorder: Bool = true {
        didSet {
            layer.borderWidth = showBorder ? borderWidth : 0
        }
    }

    // MARK: - Initializers

    public override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        setup()
        // Ensure initial editable state is handled
        handleEditableState()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
        // Ensure initial editable state is handled
        handleEditableState()
    }

    // MARK: - Setup

    private func setup() {
        font = UIFont(name: "Poppins-Regular", size: 14) ?? UIFont.preferredFont(forTextStyle: .body)
        isScrollEnabled = false
        setupPlaceholderLabel()
        setupObservers()
        
        // Set default border settings
        layer.borderColor = borderColor.cgColor
        layer.borderWidth = showBorder ? borderWidth : 0
        layer.cornerRadius = 5 // Optional: Adjust corner radius as needed
        layer.masksToBounds = true // Ensures corners are rounded if set
    }

    /// Adds the placeholderLabel to the view and sets up its initial constraints
    private func setupPlaceholderLabel() {
        addSubview(placeholderLabel)
        updateConstraintsForPlaceholderLabel()
    }

    private func updateConstraintsForPlaceholderLabel() {
        NSLayoutConstraint.activate([
            placeholderLabel.topAnchor.constraint(equalTo: topAnchor, constant: placeholderLabelInsets.top),
            placeholderLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: placeholderLabelInsets.left + 4),
            placeholderLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -placeholderLabelInsets.right),
            placeholderLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -placeholderLabelInsets.bottom)
        ])
    }

    // MARK: - Handling Editable State

    private func handleEditableState() {
        // Disable or enable user interaction based on isEditable property
        isUserInteractionEnabled = isEditable
        // Optionally, hide the placeholder if the text view is not editable
        placeholderLabel.isHidden = !isEditable || !text.isEmpty
    }

    // MARK: - Notifications

    private func postTextViewDidChangeNotification() {
        NotificationCenter.default.post(name: UITextView.textDidChangeNotification, object: self)
    }

    private func setupObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(textViewTextDidChange), name: UITextView.textDidChangeNotification, object: nil)
    }

    @objc private func textViewTextDidChange() {
        placeholderLabel.isHidden = !text.isEmpty
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

