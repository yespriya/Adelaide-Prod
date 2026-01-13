import UIKit

class MessageTableViewCell: UITableViewCell {
    @IBOutlet var likesAndCommentsView: UIView!
    
    @IBOutlet weak var feedbackView: UIView!
    @IBOutlet var likeButton: UIButton!
    @IBOutlet var dislikeButton: UIButton!
    @IBOutlet var loadingImageView: UIImageView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var bgView: UIView!
    
    @IBOutlet var copyButton: UIButton!
    @IBOutlet var speakButton: UIButton!
    
    @IBOutlet var chipsViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet var chipsView: ChipsView!
    @IBOutlet weak var senderIconImageView: UIImageView!
    @IBOutlet weak var receiverIconImageView: UIImageView!
    @IBOutlet var receiverTrailing: NSLayoutConstraint!
    @IBOutlet var senderLeading: NSLayoutConstraint!
    @IBOutlet var likeAndCommentsViewHeightConstraint: NSLayoutConstraint!
    
    var dataLoading = Bool()
    var lastMessage = Bool()
    var showLikeView = false
    var commentButtonTappedHandler: (() -> Void)?
    var submitButtonTappedHandler: (() -> Void)?
    var cancelButtonTappedHandler: (() -> Void)?
    var copyButtonTappedHandler: (() -> Void)?
    var speakButtonTappedHandler: (() -> Void)?
    var shareButtonTappedHandler: (() -> Void)?
    var reGenerateButtonTappedHandler: (() -> Void)?
    var dislikeMoreButtonTappedHandler: ((String) -> Void)?
    var closeButtonTappedHandler: (() -> Void)?
    var dislikeButtonTappedHandler: (() -> Void)?
    var likeButtonTappedHandler: (() -> Void)?






    override func awakeFromNib() {
        super.awakeFromNib()
        // Customize cell appearance
        contentView.layer.cornerRadius = 8 // Rounded corners for aesthetic
        bgView.layer.cornerRadius = 8 // Rounded corners for the background
        configureUI()
    }
    
    @IBAction func likeTapped(_ sender: Any) {
        likeButtonTappedHandler?()
    }
    
    @IBAction func closeTapped(_ sender: Any) {
        closeButtonTappedHandler?()
    }
    
    @IBAction func dislikeTapped(_ sender: Any) {
        dislikeButtonTappedHandler?()
    }
    @IBAction func commentTapped(_ sender: Any) {
        commentButtonTappedHandler?()
    }
    @IBAction func speakTapped(_ sender: Any) {
        speakButtonTappedHandler?()
    }
    @IBAction func copyTapped(_ sender: Any) {
        copyButtonTappedHandler?()
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        cancelButtonTappedHandler?()
    }
    @IBAction func submitTapped(_ sender: Any) {
        submitButtonTappedHandler?()
    }
    @IBAction func shareTapped(_ sender: Any) {
        shareButtonTappedHandler?()
    }
    @IBAction func reGenerateTapped(_ sender: Any) {
        reGenerateButtonTappedHandler?()
    }
    
    func configureUI()
    {
        chipsViewHeightConstraint.constant = 0
        chipsView.layer.shadowRadius = 10
        chipsView.layer.shadowOpacity = 0.6
        chipsView.layer.shadowOffset = CGSize(width: 3, height: 1)
        chipsView.layer.shadowColor = UIColor.gray.cgColor
        chipsView.layer.masksToBounds = false
    }
    func configure(with message: Message, idx: Int)
    {
        if idx == 0 {
            likesAndCommentsView.isHidden = true
        } else {
            likesAndCommentsView.isHidden = false
        }
        let disLikeImage = message.isDisLiked ? UIImage(named: "chat-disliked") : UIImage(named: "chat-dislike")
        let likeImage = message.isLiked ? UIImage(named: "chat-liked") : UIImage(named: "chat-like")
        dislikeButton.setImage(disLikeImage, for: .normal)
        likeButton.setImage(likeImage, for: .normal)
        
        chipsViewHeightConstraint.constant = message.isDislikePopupOpened ? 220 : 0
        if idx != 0 {
            likesAndCommentsView.isHidden = dataLoading
        }
        chipsView.chips = ["Shouldn't have used memory", "Don't like the style","Didn't fully follow the instructions","more"]
        // Set up the callback for chip taps
        chipsView.chipTapped = { [weak self] chipName in
            // Call the dislikeMoreButtonTappedHandler with the chipName
            self?.dislikeMoreButtonTappedHandler?(chipName)
        }
        senderIconImageView.isHidden = !message.isSender
        receiverIconImageView.isHidden = message.isSender
        
        let userImg =  UserDefaults.standard.string(forKey: "ProfileImg")
        if let imageUrl = URL(string: userImg ?? "NA") {
            self.senderIconImageView.sd_setImage(with: imageUrl, completed: nil)
                }
        loadingImageView.loadGif(asset: "chat-loading")
       
        if(message.isLoading)
        {
            loadingImageView.isHidden = false
            bgView.isHidden = true
            senderLeading.isActive = false
            receiverTrailing.isActive = true
        }
        else
        {
            loadingImageView.isHidden = true
            bgView.isHidden = false
            if message.isSender {
                // Sender message, set white background for message
                likesAndCommentsView.isHidden = true
                likeAndCommentsViewHeightConstraint.constant = 0
                bgView.backgroundColor = .white
                messageLabel.textAlignment = .right
                messageLabel.textColor = UIColor(named: "Label1")
                senderLeading.isActive = true
                receiverTrailing.isActive = false
                messageLabel.text = message.text
            } else
            {
                // Set the HTML text to the label
                if idx != 0 {
                    likesAndCommentsView.isHidden = !showLikeView
                }
                messageLabel.attributedText = htmlToAttributedString(html: message.text,fontSize: 14)
                likeAndCommentsViewHeightConstraint.constant = 25
                // Receiver message, set green background for message
                bgView.backgroundColor = UIColor(named: "ChatGreen")
                senderLeading.isActive = false
                receiverTrailing.isActive = true// Adjust alpha as needed
                messageLabel.textAlignment = .left
                messageLabel.textColor = .white
             //   bgView.isHidden = true
            }
        }
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
    
}
    



