import Foundation
import UIKit

@IBDesignable class Mybutton: UIButton {}
@IBDesignable class Myview: UIView {}
@IBDesignable class MyTextfeild: UITextField {}




extension Mybutton
{
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable var borderColor: UIColor {
        get {
            return UIColor.init(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue.cgColor
        }
    }
    
    
}



@IBDesignable
class SnappingSlider: UISlider {
    
    // Default increment value
    @IBInspectable var defaultIncrement: Float = 5
    
    
    override func setValue(_ value: Float, animated: Bool) {
        let roundedValue = round(value / defaultIncrement) * defaultIncrement
        super.setValue(roundedValue, animated: animated)
    }
    
    // MARK: - Tracking
    
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let location = touch.location(in: self)
        let newValue = minimumValue + (maximumValue - minimumValue) * Float(location.x / bounds.width)
        setValue(newValue, animated: true)
        sendActions(for: .valueChanged)
        return true
    }
    
    override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let location = touch.location(in: self)
        let newValue = minimumValue + (maximumValue - minimumValue) * Float(location.x / bounds.width)
        setValue(newValue, animated: true)
        sendActions(for: .valueChanged)
        return true
    }
}


extension UIViewController
{
    func addDoneButtonToNumberPad(textField: UITextField) {
        // Create a toolbar with a "Done" button
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonClicked))
        
        toolbar.items = [flexibleSpace, doneButton]
        
        // Assign the toolbar to the text field's input accessory view
        textField.inputAccessoryView = toolbar
    }
    
    @objc private func doneButtonClicked() {
        view.endEditing(true) // Close the keyboard
    }
    
    func showAlert(_ message:String){
        let alert = UIAlertController(title: "Hello Alfred", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    func showAlertWithHandler(message: String, okActionTitle: String,enableCancel: Bool, okActionHandler: ((UIAlertAction) -> Void)?, cancelActionHandler: ((UIAlertAction) -> Void)? = nil)
    {
        let alertController = UIAlertController(title: "Hello Alfred", message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: okActionTitle, style: .default, handler: okActionHandler)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: cancelActionHandler)
        
        if(enableCancel)
        {
            alertController.addAction(cancel)
        }
        alertController.addAction(okAction)
        
        
        // Present the alert controller
        self.present(alertController, animated: true, completion: nil)
    }
    
    func isValidEmail(email: String) -> Bool {
        // Regular expression for email validation
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    func isValidEmailOrPhone(_ input: String) -> Bool {
        let regexPattern = "^(?:[0-9]{10}|\\w+[.-]*\\w+@\\w+\\.[A-Za-z]{2,3})$"
        
        do {
            let regex = try NSRegularExpression(pattern: regexPattern, options: [])
            let range = NSRange(location: 0, length: input.utf16.count)
            let match = regex.firstMatch(in: input, options: [], range: range)
            
            return match != nil
        } catch {
            print("Invalid regex pattern: \(error.localizedDescription)")
            return false
        }
    }
    func isValidPassword(_ input: String) -> Bool {
        let regexPattern = "^(?=.*[A-Z])(?=.*[a-z])(?=.*\\d)(?=.*[!@#$%^&*()_+=-]).{1,}$"
        
        do {
            let regex = try NSRegularExpression(pattern: regexPattern, options: [])
            let range = NSRange(location: 0, length: input.utf16.count)
            let match = regex.firstMatch(in: input, options: [], range: range)
            
            return match != nil
        } catch {
            print("Invalid regex pattern: \(error.localizedDescription)")
            return false
        }
    }
    func validateDateOfBirth(dateString: String) -> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        if let date = dateFormatter.date(from: dateString) {
            // Calculate the age based on the given date of birth
            let calendar = Calendar.current
            let ageComponents = calendar.dateComponents([.year], from: date, to: Date())
            if let age = ageComponents.year {
                // Check if the age is between 18 and 120 years
                if age >= 18 && age <= 120 {
                    return true
                }
            }
        }
        return false
    }
    func isValidMobile(_ mobile: String?) -> Bool {
        guard let mobile = mobile else { return false }
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: mobile)
        //        return allowedCharacters.isSuperset(of: characterSet) && mobile.count == 10
        return allowedCharacters.isSuperset(of: characterSet)
    }
    
    func isValidSSN(_ ssn: String?) -> Bool {
        guard let ssn = ssn else { return false }
        return ssn.count == 9 && ssn.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
    }
    
    func isValidFeet(_ value: String?) -> Bool {
        guard let value = value, let feet = Int(value) else { return false }
        print("feet \(feet)")
        return feet >= 3
    }
    
    func isValidWeight(_ value: String?) -> Bool {
        guard let value = value, let weight = Double(value) else { return false }
        return weight >= 22 && weight <= 1400
    }
    
    func customizeInitialLetter(categoryText:String) -> NSMutableAttributedString
    {
        // Create an attributed string
        let attributedString = NSMutableAttributedString(string: categoryText)
        
        // Apply different attributes to the first letter
        attributedString.addAttribute(.foregroundColor, value: UIColor(hex: "1C77CA") ?? UIColor.blue, range: NSRange(location: 0, length: 1)) // Change color
        
        // Change font to Poppins for the first letter
        let poppinsFont = UIFont(name: "Poppins-Bold", size: 70) ?? UIFont.systemFont(ofSize: 24)
        attributedString.addAttribute(.font, value: poppinsFont, range: NSRange(location: 0, length: 1))
        
        // Set the attributed string to the label
        return attributedString
        
    }
    func createAttributedString(categoryText: String) -> NSAttributedString {
        // Create an attributed string
        let attributedString = NSMutableAttributedString(string: categoryText)
        
        // Apply different attributes to the first letter
        attributedString.addAttribute(.foregroundColor, value: UIColor(hex: "1C77CA") ?? UIColor.blue, range: NSRange(location: 0, length: 1)) // Change color
        
        // Change font to Poppins for the first letter
        let poppinsFont = UIFont(name: "Poppins-Bold", size: 70) ?? UIFont.systemFont(ofSize: 24)
        attributedString.addAttribute(.font, value: poppinsFont, range: NSRange(location: 0, length: 1))
        
        // Reduce the height between lines
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = -poppinsFont.lineHeight / 2 // Adjust this value to reduce the line spacing
        paragraphStyle.minimumLineHeight = poppinsFont.lineHeight // Ensures the minimum line height is respected
        
        attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attributedString.length))
        
        return attributedString
    }
    
    func htmlToAttributedString(html: String, fontSize: CGFloat) -> NSAttributedString? {
        guard let data = html.data(using: .utf8) else { return nil }
        do {
            let attributedString = try NSMutableAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
            
            let range = NSMakeRange(0, attributedString.length)
            attributedString.addAttributes([.font: UIFont(name: "Poppins-Regular", size: fontSize) ?? UIFont.systemFont(ofSize: fontSize)], range: range)
            
            return attributedString
        } catch {
            print("Error converting HTML to NSAttributedString: \(error)")
            return nil
        }
    }
    
    
    func fetchListItems(from html: String) -> [String] {
        let ulRegex = try! NSRegularExpression(pattern: "<ul>(.*?)</ul>", options: .dotMatchesLineSeparators)
        if let match = ulRegex.firstMatch(in: html, options: [], range: NSRange(html.startIndex..<html.endIndex, in: html)),
           let ulRange = Range(match.range(at: 1), in: html) {
            let ulContent = String(html[ulRange])
            let liRegex = try! NSRegularExpression(pattern: "<li>(.*?)</li>", options: [])
            let matches = liRegex.matches(in: ulContent, options: [], range: NSRange(ulContent.startIndex..<ulContent.endIndex, in: ulContent))
            return matches.compactMap {
                if let liRange = Range($0.range(at: 1), in: ulContent) {
                    return String(ulContent[liRange])
                }
                return nil
            }
        }
        return []
    }
    
    
    func navigateTo<T: UIViewController>(viewController: T.Type,
                                         withIdentifier identifier: String,
                                         fromStoryboard storyboardName: String = "Main",
                                         presentationStyle: UIModalPresentationStyle = .overCurrentContext,
                                         animated: Bool? = true,  // Optional animated parameter with default value true
                                         completion: (() -> Void)? = nil) {
        let storyboard = UIStoryboard(name: storyboardName, bundle: .main)
        guard let viewController = storyboard.instantiateViewController(withIdentifier: identifier) as? T else {
            print("Unable to instantiate view controller with identifier \(identifier)")
            return
        }
        viewController.modalPresentationStyle = presentationStyle
        
        // Unwrap the optional animated parameter to pass into the present method
        self.present(viewController, animated: animated ?? true, completion: completion)
    }
    
    
    func clearStoredData()
    {
        UserDefaults.standard.removeObject(forKey: "Authorization")
        UserDefaults.standard.removeObject(forKey: "PateintId")
        UserDefaults.standard.removeObject(forKey: "Username")
        UserDefaults.standard.removeObject(forKey: "ProfileImg")
        UserDefaults.standard.removeObject(forKey: "IS_LOGGED_IN")
        UserDefaults.standard.synchronize()
    }
    
    
}

extension UIView {
    func setShadowWithCornerRadius(corners : CGFloat){
        self.layer.cornerRadius = corners
        let shadowPath2 = UIBezierPath(rect: self.bounds)
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOffset = CGSize(width: CGFloat(1.0), height: CGFloat(3.0))
        self.layer.shadowOpacity = 0.5
        self.layer.shadowPath = shadowPath2.cgPath
        
    }
}

extension UIView {
    func addTopShadow(shadowColor : UIColor, shadowOpacity : Float,shadowRadius : CGFloat,offset:CGSize){
        self.layer.shadowColor = shadowColor.cgColor
        self.layer.shadowOffset = offset
        self.layer.shadowOpacity = shadowOpacity
        self.layer.shadowRadius = shadowRadius
        self.clipsToBounds = false
    }
}

extension UIView {
    
    func fixInView(_ container: UIView!) -> Void{
        self.translatesAutoresizingMaskIntoConstraints = false;
        self.frame = container.frame;
        container.addSubview(self);
        NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: container, attribute: .leading, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: container, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: container, attribute: .top, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: container, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
    }
}

extension MyTextfeild {
    
    
    
    @IBInspectable var leftPadding: CGFloat {
        get {
            return self.leftView?.frame.size.width ?? 0
        }
        set {
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: newValue, height: self.frame.size.height))
            self.leftView = paddingView
            self.leftViewMode = .always
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
        
        
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable var borderColor: UIColor {
        get {
            return UIColor.init(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue.cgColor
        }
        
        
    }
    
    
}

extension UIView {
    func commonInit(_ nibName: String) {
        guard let view = loadViewFromNib(nibName) else {
            return
        }
        view.addAsSubViewWithEqualConstraintTo(self)
    }
    
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
    
    func loadViewFromNib(_ nibName: String) -> UIView? {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
    
    func addAsSubViewWithEqualConstraintTo(_ containerView: UIView) {
        self.frame = containerView.bounds
        containerView.addSubview(self)
        self.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 0.0),
            self.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 0.0),
            self.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: 0.0),
            self.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 0.0)
        ])
    }
    
    
    
}
extension String {
    func removingSpecialCharacters() -> String {
        return self.components(separatedBy: CharacterSet.alphanumerics.inverted).joined()
    }
}

extension UIColor {
    convenience init(hex: Int, alpha: CGFloat = 1.0) {
        self.init(
            red: CGFloat((hex & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((hex & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(hex & 0x0000FF) / 255.0,
            alpha: alpha
        )
    }
}

@IBDesignable
public class Gradient: UIView {
    @IBInspectable var startColor:   UIColor = .black { didSet { updateColors() }}
    @IBInspectable var endColor:     UIColor = .white { didSet { updateColors() }}
    @IBInspectable var startLocation: Double =   0.05 { didSet { updateLocations() }}
    @IBInspectable var endLocation:   Double =   0.95 { didSet { updateLocations() }}
    @IBInspectable var horizontalMode:  Bool =  false { didSet { updatePoints() }}
    @IBInspectable var diagonalMode:    Bool =  false { didSet { updatePoints() }}
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    override public class var layerClass: AnyClass { CAGradientLayer.self }
    
    var gradientLayer: CAGradientLayer { layer as! CAGradientLayer }
    
    func updatePoints() {
        if horizontalMode {
            gradientLayer.startPoint = diagonalMode ? .init(x: 1, y: 0) : .init(x: 0, y: 0.5)
            gradientLayer.endPoint   = diagonalMode ? .init(x: 0, y: 1) : .init(x: 1, y: 0.5)
        } else {
            gradientLayer.startPoint = diagonalMode ? .init(x: 0, y: 0) : .init(x: 0.5, y: 0)
            gradientLayer.endPoint   = diagonalMode ? .init(x: 1, y: 1) : .init(x: 0.5, y: 1)
        }
    }
    func updateLocations() {
        gradientLayer.locations = [startLocation as NSNumber, endLocation as NSNumber]
    }
    func updateColors() {
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
    }
    override public func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        updatePoints()
        updateLocations()
        updateColors()
    }
    
}

extension UIColor {
    convenience init?(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt64 = 0
        
        guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else {
            return nil
        }
        
        let red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgb & 0x0000FF) / 255.0
        
        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
}
extension Myview
{
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable var borderColor: UIColor {
        get {
            return UIColor.init(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue.cgColor
        }
    }
    
    
}

@IBDesignable
class LeadingRoundedCornerView: UIView {
    
    @IBInspectable var topRightCornerRadius: CGFloat = 0 {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable var bottomRightCornerRadius: CGFloat = 0 {
        didSet {
            setNeedsLayout()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Create a path with the specified corner radii
        let path = UIBezierPath()
        
        // Top-left corner (not rounded)
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: bounds.width - topRightCornerRadius, y: 0))
        
        // Top-right corner (rounded)
        path.addArc(withCenter: CGPoint(x: bounds.width - topRightCornerRadius, y: topRightCornerRadius),
                    radius: topRightCornerRadius,
                    startAngle: CGFloat(3 * Double.pi / 2),
                    endAngle: 0,
                    clockwise: true)
        
        // Bottom-right corner (rounded)
        path.addLine(to: CGPoint(x: bounds.width, y: bounds.height - bottomRightCornerRadius))
        path.addArc(withCenter: CGPoint(x: bounds.width - bottomRightCornerRadius, y: bounds.height - bottomRightCornerRadius),
                    radius: bottomRightCornerRadius,
                    startAngle: 0,
                    endAngle: CGFloat(Double.pi / 2),
                    clockwise: true)
        
        // Bottom-left corner (not rounded)
        path.addLine(to: CGPoint(x: 0, y: bounds.height))
        path.addLine(to: CGPoint(x: 0, y: 0))
        
        // Create a shape layer and mask
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        layer.mask = shapeLayer
    }
}

extension NSLayoutConstraint {
    // This extension method allows changing the multiplier of a constraint
    func constraintWithMultipliers(_ multiplier: CGFloat) -> NSLayoutConstraint {
        // Deactivate the original constraint
        NSLayoutConstraint.deactivate([self])
        
        // Create a new constraint with the same parameters as the original, but with a new multiplier
        let newConstraint = NSLayoutConstraint(
            item: self.firstItem!,
            attribute: self.firstAttribute,
            relatedBy: self.relation,
            toItem: self.secondItem,
            attribute: self.secondAttribute,
            multiplier: multiplier,
            constant: self.constant
        )
        
        // Copy the priority and identifier to the new constraint
        newConstraint.priority = self.priority
        newConstraint.identifier = self.identifier
        
        // Activate the new constraint
        NSLayoutConstraint.activate([newConstraint])
        
        return newConstraint
    }
}
