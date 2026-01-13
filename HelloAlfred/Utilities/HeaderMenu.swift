import UIKit

protocol HeaderMenuViewDelegate {
    func ShowProfile()
    func ShowSOS()
    func ShowHelp()
    func ShowNotifications()
}
var menuIndex = 0;
let profileViewModel = ProfileViewModel()

class HeaderMenuView: UIView
{
    
    @IBOutlet var profileImgView: MyImageView!
    private let nibName = "HeaderMenu"

    
    
    
    required init?(coder: NSCoder) {
        
        
        super.init(coder: coder)
    }
    
    var delegate: HeaderMenuViewDelegate?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        commonInit(nibName)
        getUserProfileImgApiCall()
    }
    
    func getUserProfileImgApiCall()
    {
        profileViewModel.fetchUserDetails()
        profileViewModel.profileFetchSuccess = {
            // Get the image URL from the ViewModel
            let profileURL = profileViewModel.profileDetailsRes?.data?.profile_url ?? "Invalid img"
            UserDefaults.standard.set(profileURL, forKey: "ProfileImg")
            let urlString = UserDefaults.standard.string(forKey: "ProfileImg")
                if(urlString != "NA")
            {
                  if let imageUrl = URL(string: urlString ?? "") {
                        // Add loading indicator to the UIImageView
                        let loadingIndicator = UIActivityIndicatorView(style: .medium)
                        loadingIndicator.center = self.profileImgView.center
                        self.profileImgView.addSubview(loadingIndicator)
                        loadingIndicator.startAnimating()
                        
                        // Load the image asynchronously using SDWebImage
                        self.profileImgView.sd_setImage(with: imageUrl) { [weak self] (_, _, _, _) in
                            // Stop and remove loading indicator once image is loaded
                            loadingIndicator.stopAnimating()
                            loadingIndicator.removeFromSuperview()
                        }
                    }
            } else {
                // Handle invalid or missing URL
                                
                if(profileViewModel.profileDetailsRes?.data?.gender == "Male")
                {
                    self.profileImgView.image = UIImage(named: "user-male")
                }
                else
                {
                    self.profileImgView.image = UIImage(named: "user-female")
                }
            }
        }

    }
    
    @IBAction func menuButtonsPressed(_ sender: UIButton)
    {
        menuIndex = sender.tag
        switch sender.tag
        {
            case 0:
                self.delegate?.ShowProfile()
            case 1:
                self.delegate?.ShowSOS()
            case 2:
                self.delegate?.ShowHelp()
            case 3:
                self.delegate?.ShowNotifications()
            default:
                self.delegate?.ShowProfile()
        }
    }

    
    
}


