import UIKit

protocol BottomMenuViewDelegate {
    func ShowHomeView()
    func ShowSideMenu()
    func ShowHealthCareView()
    func ShowLifeStyleView()
    func ShowSettingsView()
    func ShowChatView()


}
var senderCalled = 0;

class BottomMenuView: UIView
{
    private let nibName = "BottomMenu"

    @IBOutlet var contentView: Myview!
    @IBOutlet var sideMenuImage: UIImageView!
    
    @IBOutlet var homeImage: UIImageView!
    
    @IBOutlet var healthImage: UIImageView!
    
    @IBOutlet var lifeStyleImage: UIImageView!
    
    @IBOutlet var settingsImage: UIImageView!

    
    required init?(coder: NSCoder) {
        
        super.init(coder: coder)
    }
    
    var delegate: BottomMenuViewDelegate?
    
    override func awakeFromNib() 
    {
        super.awakeFromNib()
        commonInit(nibName)
        debugPrint("selected sender \(senderCalled)");
        contentView.layer.cornerRadius = 30
        contentView.layer.shadowRadius = 20
        contentView.layer.shadowOpacity = 0.4
        contentView.layer.shadowOffset = CGSize(width: 3, height: 1)
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.masksToBounds = false
        updateIcons()

    }
    
    func updateIcons()
    {
        switch senderCalled
        {
            case 1:
                homeImage.image = UIImage(named: "home-selected")
                healthImage.image = UIImage(named: "healthcare-unselected")
                lifeStyleImage.image = UIImage(named: "lifestyle-unselected")
                settingsImage.image = UIImage(named: "settings-unselected")
//                senderCalled = 0
            case 2:
                homeImage.image = UIImage(named: "home-unselected")
                healthImage.image = UIImage(named: "healthcare-selected")
                lifeStyleImage.image = UIImage(named: "lifestyle-unselected")
                settingsImage.image = UIImage(named: "settings-unselected")
//                senderCalled = 0
            case 3:
                homeImage.image = UIImage(named: "home-unselected")
                healthImage.image = UIImage(named: "healthcare-unselected")
                lifeStyleImage.image = UIImage(named: "lifestyle-selected")
                settingsImage.image = UIImage(named: "settings-unselected")
//                senderCalled = 0
            case 4:
                homeImage.image = UIImage(named: "home-unselected")
                healthImage.image = UIImage(named: "healthcare-unselected")
                lifeStyleImage.image = UIImage(named: "lifestyle-unselected")
                settingsImage.image = UIImage(named: "settings-selected")
//                senderCalled = 0
            default:
                homeImage.image = UIImage(named: "home-selected")
                healthImage.image = UIImage(named: "healthcare-unselected")
                lifeStyleImage.image = UIImage(named: "lifestyle-unselected")
                settingsImage.image = UIImage(named: "settings-unselected")
        }
    }
    
    @IBAction func menuButtonsPressed(_ sender: UIButton)
    {
        senderCalled = sender.tag
        switch sender.tag
        {
            case 0:
                self.delegate?.ShowSideMenu()
            case 1:
                self.delegate?.ShowHomeView()
            case 2:
                self.delegate?.ShowHealthCareView()
            case 3:
                self.delegate?.ShowLifeStyleView()
            case 4:
                self.delegate?.ShowSettingsView()
            case 5:
                self.delegate?.ShowChatView()
            default:
                self.delegate?.ShowHomeView()
        }
    }
//    func ShowChatView() {
//             let storyboard = UIStoryboard(name: "Main", bundle: .main)
//             let popup = storyboard.instantiateViewController(withIdentifier: "EducationalChatViewController") as! EducationalChatViewController
//        popup.modalPresentationStyle = .fullScreen
//
//      //  let navController:UINavigationController = UINavigationController.init(rootViewController: popup)
//        self.present(popup, animated: true, completion: nil)
//    }
//    
//   
//    
//    func ShowSideMenu() {
//        let sideMenuNavController: SideMenuNavigationController = SideMenuNavigationController.init(rootViewController: self.leftMenu)
//        leftMenu.delegate = self
//        let menuWidth = 260.00
//        sideMenuNavController.menuWidth = menuWidth
//        sideMenuNavController.view.clipsToBounds = true
//        sideMenuNavController.isNavigationBarHidden = true
//        SideMenuManager.default.leftMenuNavigationController = sideMenuNavController
//        SideMenuManager.default.menuPresentMode = .menuSlideIn
//        SideMenuManager.default.menuAnimationBackgroundColor = .black
//        SideMenuManager.default.menuFadeStatusBar = false
//        SideMenuManager.default.menuAnimationFadeStrength = 0.4
//        SideMenuManager.default.menuEnableSwipeGestures = false
//        SideMenuManager.default.menuWidth = 280
//        present(SideMenuManager.default.leftMenuNavigationController!, animated: true, completion: nil)
//    }
//    func ShowHomeView() {
//        
//
//    }
//    func ShowHealthCareView() {
//        let storyboard = UIStoryboard(name: "Main", bundle: .main)
//             let popup = storyboard.instantiateViewController(withIdentifier: "DashboardLifeStyleViewController") as!
//        DashboardLifeStyleViewController
//     
//        popup.modalPresentationStyle = .fullScreen
//             present(popup, animated: false, completion: nil)
//    }
//    
//    func ShowLifeStyleView() {
//        let storyboard = UIStoryboard(name: "Main", bundle: .main)
//             let popup = storyboard.instantiateViewController(withIdentifier: "DashboardLifeStyleGoalsViewController") as!
//        DashboardLifeStyleGoalsViewController
//     
//        popup.modalPresentationStyle = .fullScreen
//             present(popup, animated: false, completion: nil)
//    }
//    
//    func ShowSettingsView() {
//        showAlert("These features are coming soon")
//
//    }
    
    
}


