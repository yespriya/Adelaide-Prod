//
//  ProfileViewController.swift
//  HelloAlfred
//
//  Created by admin on 09/04/24.
//

import UIKit

class ProfileViewController: UIViewController {
    
    
    @IBOutlet var insuranceNumberLabel: UILabel!
    @IBOutlet var insuranceLabel: UILabel!
    @IBOutlet var nationalityLabel: UILabel!
    @IBOutlet var mobileLabel: UILabel!
    @IBOutlet var ssnLabel: UILabel!
    @IBOutlet var genderLabel: UILabel!
    @IBOutlet var ageLabel: UILabel!
    @IBOutlet var dobLabel: UILabel!
    @IBOutlet var universityLabel: UILabel!
    @IBOutlet var residentTypeLabel: UILabel!
    @IBOutlet var bloodTypeLabel: UILabel!
    @IBOutlet var weightLabel: UILabel!
    @IBOutlet var heightLabel: UILabel!
    @IBOutlet var subscriptionTypeLabel: UILabel!
    @IBOutlet var userProfileImg: UIImageView!
    @IBOutlet var emailLabel: UILabel!
    @IBOutlet var userNameLabel: UILabel!
    let viewModel=ProfileViewModel()
    @IBOutlet weak var progressView: UIProgressView!
       @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var progressLabelLeadingConstraint: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()
        getUserProfileApiCall()
    
    }
    
    @IBAction func settingsClicked(_ sender: Any)
    {
        showAlert("This feature will be available soon.")
    }
    @IBAction func logoutClicked(_ sender: Any) {
        clearStoredData()
        navigateTo(viewController: SignInViewController.self, withIdentifier: "SignInViewController")
    }
    
    @IBAction func dismiss(_ sender: Any) {
      
        navigateTo(viewController: DashboardViewController.self, withIdentifier: "DashboardViewController")
    }
    
    
    @IBAction func infoBMITapped(_ sender: Any) {
        showBMIAlert()
    }
    @IBAction func changePasswordTapped(_ sender: Any) {
        
        navigateTo(viewController: ChangePasswordViewController.self, withIdentifier: "ChangePasswordViewController")
    }
    
    @IBAction func editProfileTapped(_ sender: Any)
    {
        let userData = UserProfileData(data: (viewModel.profileDetailsRes?.data))
        
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        let popup = storyboard.instantiateViewController(withIdentifier: "ProfileEditViewController") as! ProfileEditViewController
        popup.userData = userData
        popup.modalPresentationStyle = .overCurrentContext
        present(popup, animated: true, completion: nil)
    }
    func setUpUI()
    {
        var userData = viewModel.profileDetailsRes?.data
        insuranceLabel.text = userData?.insurance_policy_no
        nationalityLabel.text = userData?.nationality
        mobileLabel.text = userData?.mobile
        ssnLabel.text = userData?.ssn == "" ? "NA" : maskAllButLastThreeDigits(of: userData?.ssn ?? "")
        genderLabel.text = userData?.gender == "" ? "NA" : userData?.gender
        ageLabel.text = "\(userData!.age!)"
        dobLabel.text = userData?.dob == "" ? "NA" : userData?.dob
        residentTypeLabel.text = userData?.rtype
        universityLabel.text = userData?.education == "" ? "NA" : userData?.education
        bloodTypeLabel.text = userData?.bloodtype == "" ? "NA" : userData?.bloodtype
        if let feet = userData?.feet, feet != "NA" {
            if let inch = userData?.inch, inch != "NA"{
                heightLabel.text = feet + "." + inch + " ft"
            }
        } else {
            heightLabel.text = "NA"
        }
        if let weight = userData?.weight, weight != "NA" {
            weightLabel.text = weight + " Kg"
        } else {
            weightLabel.text = "NA"
        }
//        weightLabel.text = "\(userData!.weight!) uiii" + (userData!.weight!) != "NA" ? "lbs" : ""
//        heightLabel.text = (userData!.height!) + (userData!.height!) != "NA" ? "ft" : ""
        subscriptionTypeLabel.text = userData?.subscription == "" ? "NA" : userData?.subscription
        emailLabel.text = userData?.email == "" ? "NA" : userData?.email
        userNameLabel.text = userData?.username == "" ? "NA" : userData?.username
        self.updateProgress(value: Float(((userData?.profile_percentage!)! )/100))
        if let profilePercentage = userData?.profile_percentage {
            let floatVal = Float(profilePercentage) / 100.0
            updateProgress(value: floatVal)
        } else {
            print("profile_percentage is nil")
        }
        
        if(userData?.profile_url != "NA")
        {
            
            if let imageUrl = URL(string: userData?.profile_url ?? "") {
                  // Add loading indicator to the UIImageView
                  let loadingIndicator = UIActivityIndicatorView(style: .medium)
                  loadingIndicator.center = self.userProfileImg.center
                  self.userProfileImg.addSubview(loadingIndicator)
                  loadingIndicator.startAnimating()
                  
                  // Load the image asynchronously using SDWebImage
                  self.userProfileImg.sd_setImage(with: imageUrl) { [weak self] (_, _, _, _) in
                      // Stop and remove loading indicator once image is loaded
                      loadingIndicator.stopAnimating()
                      loadingIndicator.removeFromSuperview()
                  }
              }
        }
        else {
            if(viewModel.profileDetailsRes?.data?.gender == "Male")
            {
                self.userProfileImg.image = UIImage(named: "user-male")
            }
            else
            {
                self.userProfileImg.image = UIImage(named: "user-female")
            }
        }
        
    }
    
    func showBMIAlert() {
            let customAlertView = CustomAlertView(message: "BMI will be automaticaly changed, when height and weight are changed")
            customAlertView.frame = view.bounds
            view.addSubview(customAlertView)
        }
    func maskAllButLastThreeDigits(of input: String) -> String {
        // Find all the digits in the string
        let digits = input.filter { $0.isNumber }
        
        // If there are less than or equal to 3 digits, no need to mask
        if digits.count <= 3 {
            return input
        }
        
        // Get the last three digits
        let lastThreeDigits = digits.suffix(3)
        
        // Variable to keep track of the number of digits masked
        var digitsMasked = 0
        
        // Traverse the input string and replace digits with "*"
        let maskedString = input.map { character -> String in
            if character.isNumber {
                if digitsMasked < digits.count - 3 {
                    digitsMasked += 1
                    return "*"
                } else {
                    return String(character)
                }
            } else {
                return String(character)
            }
        }.joined()
        
        return maskedString
    }

       // Function to update progress
       func updateProgress(value: Float) {
           print("value  \(value)")
           progressView.progress = value
           progressLabel.text = "\(Int(value * 100))%"
           
           // Update label position
           updateLabelPosition(progress: value)
       }
    // Function to update the label position
        func updateLabelPosition(progress: Float) {
            let progressWidth = progressView.bounds.width
            let progressX = CGFloat(progress ) * progressWidth
            
            if(progress >= 0.98)
            {
                // Update the leading constraint to position the label
                progressLabelLeadingConstraint.constant = (progressX - (progressLabel.bounds.width / 2)) - 16
            }
            else
            {
                // Update the leading constraint to position the label
                progressLabelLeadingConstraint.constant = (progressX - (progressLabel.bounds.width / 2))
            }
           
            
            // Ensure the label position is updated smoothly
            UIView.animate(withDuration: 0.1) {
                self.view.layoutIfNeeded()
            }
        }
    func getUserProfileApiCall()
    {
      
        viewModel.fetchUserDetails()
        viewModel.profileFetchSuccess = {
           print("success")
            self.setUpUI()
        }
        viewModel.loadingStatus =
        {
            if self.viewModel.isLoading {
                self.activityIndicator(self.view, startAnimate: true)
            } else {
                self.activityIndicator(self.view, startAnimate: false)
                UIApplication.shared.endIgnoringInteractionEvents()
            }
        }
        viewModel.errorMessageAlert = {
            self.showAlert(self.viewModel.errorMessage ?? "Error")
           
        }
    }

   

}
struct UserProfileData{
   var data: ProfileData?
}

class CustomAlertView: UIControl {
    let containerView = UIView()
    
    init(message: String) {
        super.init(frame: UIScreen.main.bounds)
        
        setupUI(message: message)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI(message: String) {
        backgroundColor = UIColor.black.withAlphaComponent(0.5) // Semi-transparent background
        addTarget(self, action: #selector(dismiss), for: .touchUpInside) // Dismiss when tapped outside
        
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 10
        addSubview(containerView)
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        containerView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        containerView.widthAnchor.constraint(equalToConstant: 250).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: 120).isActive = true
        
        let messageLabel = UILabel()
        messageLabel.text = message
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0
        containerView.addSubview(messageLabel)
        
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20).isActive = true
        messageLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20).isActive = true
        messageLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20).isActive = true
    }
    
    @objc private func dismiss() {
        removeFromSuperview()
    }
}
