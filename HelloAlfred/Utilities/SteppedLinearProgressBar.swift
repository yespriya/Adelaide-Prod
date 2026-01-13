import UIKit

enum ProgressState: Int {
    case current
    case completed
    case incomplete
    case waiting
}

@IBDesignable
class SteppedLinearProgressBar: UIView {
    
    @IBInspectable var completedColor: UIColor = .green
    @IBInspectable var incompleteColor: UIColor = .blue
    @IBInspectable var barLineColor: UIColor = .gray
    @IBInspectable var lineWidth: CGFloat = 5
    @IBInspectable var spacing: CGFloat = 0
    
    @IBInspectable var completedImage: UIImage?
    @IBInspectable var incompleteImage: UIImage?
    @IBInspectable var waitingImage: UIImage?
    @IBInspectable var completedGifName: String? // Gif file name without the extension
    @IBInspectable var incompleteGifName: String?
    
    var progressStates: [ProgressState] = []
    
    private let startEndGap: CGFloat = 12
    
    override func draw(_ rect: CGRect) {
        self.subviews.forEach { $0.removeFromSuperview() }
        
        guard progressStates.count > 1 else { return }
        
        let context = UIGraphicsGetCurrentContext()
        let totalWidth = rect.width - 2 * startEndGap
        let segmentWidth = (totalWidth - spacing * CGFloat(progressStates.count - 1)) / CGFloat(progressStates.count - 1)
        
        for (index, state) in progressStates.enumerated() {
            let startX = startEndGap + CGFloat(index) * (segmentWidth + spacing)
            let endX = startX + segmentWidth
            
            let startPoint = CGPoint(x: startX, y: rect.height / 2)
            let endPoint = CGPoint(x: endX, y: rect.height / 2)
            
            // Draw the line for all states, including .current
            if index < progressStates.count - 1 {
                drawLine(context: context, from: startPoint, to: endPoint, state: state)
            }
            
            // Draw the image after the line
            drawImage(for: state, at: startPoint)
        }
        
        // Draw the remaining line after the last image if it's not `.current`
        if let context = context, progressStates.last != .current {
            let remainingStartX = startEndGap + CGFloat(progressStates.count - 1) * (segmentWidth + spacing)
            let remainingEndX = rect.width - startEndGap
            let remainingStartPoint = CGPoint(x: remainingStartX, y: rect.height / 2)
            let remainingEndPoint = CGPoint(x: remainingEndX, y: rect.height / 2)
            drawLine(context: context, from: remainingStartPoint, to: remainingEndPoint, state: .waiting)
        }
    }




    
    private func drawLine(context: CGContext?, from start: CGPoint, to end: CGPoint, state: ProgressState) {
        let lineColor: UIColor
        switch state {
        case .completed:
            lineColor = completedColor
        case .incomplete:
            lineColor = UIColor.yellow
        case .waiting,.current:
            lineColor = barLineColor
        }
        
        context?.setStrokeColor(lineColor.cgColor)
        context?.setLineWidth(lineWidth)
        context?.move(to: start)
        context?.addLine(to: end)
        context?.strokePath()
    }
    
    private func drawImage(for state: ProgressState, at point: CGPoint) {
        let imageSize = state == .current ? CGSize(width: 40, height: 40) : CGSize(width: 20, height: 20)
        let imageRect = CGRect(x: point.x - imageSize.width / 2, y: point.y - imageSize.height / 2, width: imageSize.width, height: imageSize.height)

        switch state {
        case .current:
            if let gifName = completedGifName {
                showGif(named: gifName, in: imageRect)
            } else {
                completedImage?.draw(in: imageRect)
            }
        case .completed:
                completedImage?.draw(in: imageRect)
        case .incomplete:
                incompleteImage?.draw(in: imageRect)
        case .waiting:
                waitingImage?.draw(in: imageRect)

        }
    }
    
    private func showGif(named gifName: String, in rect: CGRect) {
        let imageView = UIImageView(frame: rect)
        imageView.loadGif(asset: gifName)
        self.addSubview(imageView)
       
    }
}


