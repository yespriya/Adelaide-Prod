import UIKit

@IBDesignable
class CircularProgressBarWithGradient: UIView {

    private var circleLayer = CAShapeLayer()
    private var progressLayer = CAShapeLayer()
    private var gradientLayer = CAGradientLayer()
    private var imageView = UIImageView()

    @IBInspectable var trackColor: UIColor = .lightGray {
        didSet {
            circleLayer.strokeColor = trackColor.cgColor
        }
    }
    
    @IBInspectable var lineWidth: CGFloat = 10.0 {
        didSet {
            circleLayer.lineWidth = lineWidth
            progressLayer.lineWidth = lineWidth
            updatePath()
        }
    }
    
    @IBInspectable var progress: Float = 0 {
        didSet {
            setProgress(to: progress)
        }
    }

    @IBInspectable var image: UIImage? {
        didSet {
            imageView.image = image
            imageView.backgroundColor = UIColor.white
        }
    }

    @IBInspectable var imageSize: CGSize = CGSize(width: 10, height: 10) {
        didSet {
            imageView.frame.size = imageSize
            
        }
    }

    @IBInspectable var showImage: Bool = true {
        didSet {
            imageView.isHidden = !showImage
        }
    }

    @IBInspectable var startColor: UIColor = .red {
        didSet {
            configureGradientLayer()
        }
    }

    @IBInspectable var midColor: UIColor = UIColor.green.withAlphaComponent(0.5) {
        didSet {
            configureGradientLayer()
        }
    }

    @IBInspectable var endColor: UIColor = .blue {
        didSet {
            configureGradientLayer()
        }
    }
    
    @IBInspectable var inwardOffset: CGFloat = 5.0 { // New property to control inward offset
        didSet {
            updateImageViewPosition(for: CGFloat(progress))
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        createCircularPath()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        createCircularPath()
    }

    private func createCircularPath() {
        self.backgroundColor = UIColor.clear
        self.layer.cornerRadius = self.frame.size.width / 2

        let circlePath = UIBezierPath(arcCenter: CGPoint(x: frame.size.width / 2, y: frame.size.height / 2), radius: (frame.size.width - lineWidth) / 2, startAngle: -CGFloat.pi / 2, endAngle: CGFloat.pi * 3 / 2, clockwise: true)

        circleLayer.path = circlePath.cgPath
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.strokeColor = trackColor.cgColor
        circleLayer.lineWidth = lineWidth
        circleLayer.strokeEnd = 1.0
        layer.addSublayer(circleLayer)

        progressLayer.path = circlePath.cgPath
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.strokeColor = UIColor.black.cgColor // Dummy color, replaced by gradient
        progressLayer.lineWidth = lineWidth
        progressLayer.strokeEnd = 0

        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        configureGradientLayer()
        gradientLayer.mask = progressLayer
        
        layer.addSublayer(gradientLayer)

        imageView.contentMode = .scaleAspectFit
        imageView.frame.size = imageSize
        imageView.isHidden = !showImage
        addSubview(imageView)
    }

    private func configureGradientLayer() {
        gradientLayer.colors = [startColor.cgColor, midColor.cgColor, endColor.cgColor]
        gradientLayer.locations = [0.0, 0.5, 1.0] // Adjust the locations as needed
        gradientLayer.frame = bounds
    }

    func setProgress(to progressConstant: Float) {
        let progress = min(max(progressConstant, 0), 1)
        progressLayer.strokeEnd = CGFloat(progress)
        updateImageViewPosition(for: CGFloat(progress))
        setNeedsDisplay()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
        updateImageViewPosition(for: progressLayer.strokeEnd)
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        updateImageViewPosition(for: progressLayer.strokeEnd)
    }

    private func updateImageViewPosition(for progress: CGFloat) {
        guard let _ = imageView.image, showImage else { return }
        
        let radius = (frame.size.width - lineWidth) / 2
        let angle = -CGFloat.pi / 2

        // Center the image at the start of the progress and adjust it inward
        let xPosition = frame.size.width / 2 + (radius - inwardOffset) * cos(angle) - imageSize.width / 2
        let yPosition = frame.size.height / 2 + (radius - inwardOffset) * sin(angle) - imageSize.height / 2

        imageView.frame = CGRect(x: xPosition, y: yPosition, width: imageSize.width, height: imageSize.height)
        imageView.transform = .identity
    }

    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        createCircularPath()
        setProgress(to: progress)
    }

    private func updatePath() {
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: frame.size.width / 2, y: frame.size.height / 2), radius: (frame.size.width - lineWidth) / 2, startAngle: -CGFloat.pi / 2, endAngle: CGFloat.pi * 3 / 2, clockwise: true)
        circleLayer.path = circlePath.cgPath
        progressLayer.path = circlePath.cgPath
    }
}

