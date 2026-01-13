import Foundation
import UIKit
import SideMenu

extension UIViewController: SideMenuDelegate,BottomMenuViewDelegate {
    
    func sideMenuControllerSelected(menu: SideMenuItem) {
        switch menu {
        case .myProfile:
           
            navigateTo(viewController: ProfileViewController.self, withIdentifier: "ProfileViewController")
        case .chatWithUs, .goals, .doctors, .schedules, .bookAppointments, .integrations:
            showAlert("These features are coming soon")
        case .historyTranscript:
            getProfileCompletionStatusApiCall(isChat: false) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let details):
                    if details.data == nil {
                        navigateTo(viewController: HistoryTranscriptSummaryViewController.self, withIdentifier: "HistoryTranscriptSummaryViewController")
                    } else {
                        if details.data?.redirection_key == "history_chat" {
                            self.showAlertWithHandler(message: details.message ?? "", okActionTitle: "Complete Now", enableCancel: true) {_ in
                               
                                self.navigateTo(viewController: HistoryChatViewController.self, withIdentifier: "HistoryChatViewController")
                            }
                        } else if details.data?.redirection_key == "profile" {
                            self.showAlertWithHandler(message: details.message ?? "", okActionTitle: "Complete Now", enableCancel: true) {_ in
                                self.navigateTo(viewController: ProfileViewController.self, withIdentifier: "ProfileViewController")
                            }
                        } else {
                            self.showAlert("Invalid Redirection key")
                        }
                    }
                case .failure(let error):
                    print("Error fetching profile completion data: \(error.localizedDescription)")
                }
            }
        case .behavioralChat:
           
            navigateTo(viewController: BehaviouralChatViewController.self, withIdentifier: "BehaviouralChatViewController")
        case .historyChat:
            getProfileCompletionStatusApiCall(isChat: true) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let details):
                    if details.data == nil {
                        
                        navigateTo(viewController: HistoryChatViewController.self, withIdentifier: "HistoryChatViewController")
                    } else if details.data?.redirection_key == "list_of_symptoms" {
                        self.showAlertWithHandler(message: details.message ?? "", okActionTitle: "Complete Now", enableCancel: true) {_ in
                          
                            self.navigateTo(viewController: ListOfSymptomsViewController.self, withIdentifier: "ListOfSymptomsViewController")
                        }
                    } else {
                        self.showAlertWithHandler(message: details.message ?? "", okActionTitle: "View Profile", enableCancel: true) {_ in
                            let storyboard = UIStoryboard(name: "Main", bundle: .main)
                            let popup = storyboard.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
                            popup.modalPresentationStyle = .overCurrentContext
                            self.present(popup, animated: true, completion: nil)
                        }
                    }
                case .failure(let error):
                    print("Error fetching profile completion data: \(error.localizedDescription)")
                }
            }
        default:
            print("Unhandled menu item selected.")
        }
    }
    
    func ShowChatView() {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        let popup = storyboard.instantiateViewController(withIdentifier: "EducationalChatViewController") as! EducationalChatViewController
        popup.modalPresentationStyle = .fullScreen
        self.present(popup, animated: true, completion: nil)
    }
    
    func ShowSideMenu() {
        let leftMenu = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "SideMenuViewController") as! SideMenuViewController
        let sideMenuNavController = SideMenuNavigationController(rootViewController: leftMenu)
        leftMenu.delegate = self
        
        sideMenuNavController.settings.menuWidth = 280
        sideMenuNavController.settings.presentationStyle = .menuSlideIn
        sideMenuNavController.settings.presentationStyle.backgroundColor = .black
        sideMenuNavController.settings.enableSwipeToDismissGesture = false
        
        SideMenuManager.default.leftMenuNavigationController = sideMenuNavController
        
        present(SideMenuManager.default.leftMenuNavigationController!, animated: true, completion: nil)
    }
    
    func ShowHomeView() {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        let popup = storyboard.instantiateViewController(withIdentifier: "DashboardViewController") as! DashboardViewController
        popup.modalPresentationStyle = .fullScreen
        present(popup, animated: false, completion: nil)
        
        
    }
    
    func ShowHealthCareView() {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        let popup = storyboard.instantiateViewController(withIdentifier: "DashboardLifeStyleViewController") as! DashboardLifeStyleViewController
        popup.modalPresentationStyle = .fullScreen
        present(popup, animated: false, completion: nil)
      
    }
    
    func ShowLifeStyleView() {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        let popup = storyboard.instantiateViewController(withIdentifier: "DashboardLifeStyleGoalsViewController") as! DashboardLifeStyleGoalsViewController
        popup.modalPresentationStyle = .fullScreen
        present(popup, animated: false, completion: nil)
    }
    
    func ShowSettingsView() {
        showAlert("These features are coming soon")
    }
    
    func getProfileCompletionStatusApiCall(isChat: Bool, completion: @escaping (Result<ProfileCompletionModel, Error>) -> Void) {
        let profileViewModel = ProfileViewModel()

        self.activityIndicator(self.view, startAnimate: true)
        let params: [String: Any] = isChat ? ["history_chat": true] : ["history_trans": true]
        
        profileViewModel.fetchProfileCompletionStatus(params: params)
        
        profileViewModel.profileCompletionFetchSuccess = { [weak self] in
            guard let self = self else { return }
            self.activityIndicator(self.view, startAnimate: false)
            if let data = profileViewModel.profileCompletionRes {
                completion(.success(data))
            } else {
                // Handle the case where data is nil
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data available"])))
            }
        }
        
        profileViewModel.errorMessageAlert = { [weak self]  in
            guard let self = self else { return }
            self.activityIndicator(self.view, startAnimate: false)
            if let data = profileViewModel.errorMessage {
                completion(.failure(data as! Error))
            } else {
                // Handle the case where data is nil
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data available"])))
            }        }
    }
}

