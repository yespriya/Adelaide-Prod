import UIKit

@IBDesignable
class UnderlinedTextField: UITextField {
    
    @IBInspectable var underlineColor: UIColor = .black {
        didSet {
            underline.backgroundColor = underlineColor
        }
    }
    
    @IBInspectable var rightImage: UIImage? {
        didSet {
            updateRightView()
        }
    }
    
    @IBInspectable var leftPadding: CGFloat = 8 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var rightPadding: CGFloat = 8 {
        didSet {
            updateRightView()
        }
    }
    
    @IBInspectable var hideUnderline: Bool = true {
        didSet {
            underline.isHidden = hideUnderline
        }
    }
    
    @IBInspectable var placeholderColor: UIColor = UIColor(red: 53/255, green: 72/255, blue: 102/255, alpha: 0.5) {
        didSet {
            updatePlaceholder()
        }
    }
    
    @IBInspectable var textFieldBackgroundColor: UIColor? {
        didSet {
            self.backgroundColor = textFieldBackgroundColor
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat = 8 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }
    
    private var underline: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonSetup()
        setupTextField()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonSetup()
        setupTextField()
    }
    
    private func commonSetup() {
        updateRightView()
    }
    
    private func updateRightView() {
        if let image = rightImage {
            let imageView = UIImageView(image: image)
            imageView.contentMode = .center

            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: rightPadding, height: frame.size.height))
            rightView = UIView(frame: CGRect(x: 0, y: 0, width: image.size.width + rightPadding, height: frame.size.height))
            
            let imageX = (rightView!.frame.width - image.size.width) / 2
            imageView.frame = CGRect(x: imageX, y: 0, width: image.size.width, height: frame.size.height)
            
            rightView?.addSubview(paddingView)
            rightView?.addSubview(imageView)

            rightViewMode = .always
        } else {
            rightView = nil
        }
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setupTextField()
    }
    
    override func resignFirstResponder() -> Bool {
        let resigned = super.resignFirstResponder()
        if resigned {
            self.endEditing(true)
        }
        return resigned
    }
    
    private func setupTextField() {
        self.borderStyle = .none
        self.backgroundColor = textFieldBackgroundColor ?? UIColor(named: "TextfeildBG")
        
        underline = UIView()
        underline.backgroundColor = underlineColor
        underline.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(underline)
        
        NSLayoutConstraint.activate([
            underline.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            underline.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            underline.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            underline.heightAnchor.constraint(equalToConstant: 1.0)
        ])
        
        underline.isHidden = hideUnderline
        updatePlaceholder()
        
        // Apply the corner radius with default value 8
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = cornerRadius > 0
    }
    
    private func updatePlaceholder() {
        guard let placeholderText = placeholder else { return }
        let attributes: [NSAttributedString.Key: Any] = [.foregroundColor: placeholderColor]
        attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: attributes)
    }

    // Add padding for placeholder, text, and editing text
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: leftPadding, dy: 0)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: leftPadding, dy: 0)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: leftPadding, dy: 0)
    }
}

