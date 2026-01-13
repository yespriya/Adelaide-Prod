import UIKit

@IBDesignable
class CircularProgressBar: UIView {

    private var circleLayer = CAShapeLayer()
    private var progressLayer = CAShapeLayer()
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
        }
    }

    @IBInspectable var imageSize: CGSize = CGSize(width: 30, height: 30) {
        didSet {
            imageView.frame.size = imageSize
        }
    }

    @IBInspectable var showImage: Bool = true {
        didSet {
            imageView.isHidden = !showImage
        }
    }

    @IBInspectable var progressColor: UIColor = .blue {
        didSet {
            progressLayer.strokeColor = progressColor.cgColor
        }
    }

    @IBInspectable var placeImageInside: Bool = true {
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

        let circlePath = UIBezierPath(arcCenter: CGPoint(x: bounds.midX, y: bounds.midY), radius: (bounds.width - lineWidth) / 2, startAngle: -.pi / 2, endAngle: .pi * 3 / 2, clockwise: true)

        circleLayer.path = circlePath.cgPath
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.strokeColor = trackColor.cgColor
        circleLayer.lineWidth = lineWidth
        circleLayer.strokeEnd = 1.0
        layer.addSublayer(circleLayer)

        progressLayer.path = circlePath.cgPath
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.strokeColor = progressColor.cgColor
        progressLayer.lineWidth = lineWidth
        progressLayer.strokeEnd = 0
        layer.addSublayer(progressLayer)

        imageView.contentMode = .scaleAspectFit
        imageView.frame.size = imageSize
        imageView.isHidden = !showImage
        addSubview(imageView)
    }

    func setProgress(to progressConstant: Float) {
        let progress = min(max(progressConstant, 0), 1)
        progressLayer.strokeEnd = CGFloat(progress)
        updateImageViewPosition(for: CGFloat(progress))
        setNeedsDisplay()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        updatePath()
    }

    private func updateImageViewPosition(for progress: CGFloat) {
        guard let _ = imageView.image, showImage else { return }

        let radius = (frame.size.width - lineWidth) / 2
        let angle = progress * 2 * .pi - .pi / 2

        if placeImageInside {
            // Position image inside the circle
            let inwardOffset = lineWidth / 2 + imageSize.width / 2 // Adjust offset to move the image further inside
            let adjustedRadius = radius - inwardOffset
            let xPosition = frame.size.width / 2 + adjustedRadius * cos(angle) - imageSize.width / 2
            let yPosition = frame.size.height / 2 + adjustedRadius * sin(angle) - imageSize.height / 2
            
            imageView.frame = CGRect(x: xPosition, y: yPosition, width: imageSize.width, height: imageSize.height)
            imageView.transform = .identity // No rotation when inside
        } else {
            // Project the image slightly outside the circle
            let projectionDistance: CGFloat = (lineWidth / 2) + 2 // Adjust to project the image outwards
            let xPosition = frame.size.width / 2 + (radius + projectionDistance) * cos(angle) - imageSize.width / 2
            let yPosition = frame.size.height / 2 + (radius + projectionDistance) * sin(angle) - imageSize.height / 2
            
            imageView.frame = CGRect(x: xPosition, y: yPosition, width: imageSize.width, height: imageSize.height)
            imageView.transform = CGAffineTransform(rotationAngle: angle + .pi / 2) // Rotate image by 90 degrees relative to the progress bar
        }
    }

    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        createCircularPath()
        setProgress(to: progress)
    }

    private func updatePath() {
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: bounds.midX, y: bounds.midY), radius: (bounds.width - lineWidth) / 2, startAngle: -.pi / 2, endAngle: .pi * 3 / 2, clockwise: true)
        circleLayer.path = circlePath.cgPath
        progressLayer.path = circlePath.cgPath
    }
}

