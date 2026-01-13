//
//  AppDelegate.swift
//  HelloAlfred
//
//  Created by admin on 26/02/24.
//

import UIKit
import FirebaseCore
import IQKeyboardManagerSwift
import Highcharts

@main
class AppDelegate: UIResponder, UIApplicationDelegate
{
    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        // Override point for customization after application launch.
        FirebaseApp.configure()
        if UserDefaults.standard.bool(forKey: "IS_LOGGED_IN") {
            gotoHome()
        } else {
            gotoOnboardingScreen()
        }
        IQKeyboardManager.shared.isEnabled = true
        HIChartView.preload()
        return true
    }
    
    
    //when token expired redirects to login
    func redirectToLogin(errorMsg: String?) {
        let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewcontroller: SignInViewController = storyboard.instantiateViewController(withIdentifier: "SignInViewController") as! SignInViewController
        viewcontroller.modalTransitionStyle = .crossDissolve
        viewcontroller.clearStoredData()
        let navController:UINavigationController = UINavigationController.init(rootViewController: viewcontroller)
        
        window?.rootViewController = navController
        window?.makeKeyAndVisible()
        self.displayLoginPopUpAdmin(vc: viewcontroller, errorMsg: errorMsg ?? "You are not authorized!")
    }
    func gotoHome() {
        let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewcontroller: DashboardViewController = storyboard.instantiateViewController(withIdentifier: "DashboardViewController") as! DashboardViewController
        viewcontroller.modalTransitionStyle = .crossDissolve
        let navController:UINavigationController = UINavigationController.init(rootViewController: viewcontroller)
        window?.rootViewController = navController
        // window?.makeKeyAndVisible()
    }
    
    func gotoOnboardingScreen()
    {
        if UserDefaults.standard.bool(forKey: "IS_APP_OPENED") {
            let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let viewcontroller: SignInViewController = storyboard.instantiateViewController(withIdentifier: "SignInViewController") as! SignInViewController
            viewcontroller.modalTransitionStyle = .crossDissolve
            
            let navController:UINavigationController = UINavigationController.init(rootViewController: viewcontroller)
            
            window?.rootViewController = navController
            window?.makeKeyAndVisible()
        } else {
            let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let viewcontroller: AppIntroViewController = storyboard.instantiateViewController(withIdentifier: "AppIntroViewController") as! AppIntroViewController
            viewcontroller.modalTransitionStyle = .crossDissolve
            let navController:UINavigationController = UINavigationController.init(rootViewController: viewcontroller)
            window?.rootViewController = navController
            window?.makeKeyAndVisible()
        }
        
        
    }
    func displayLoginPopUpAdmin(vc: UIViewController, errorMsg: String) {

        let alert = UIAlertController(title: "", message: errorMsg, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { _ in
            vc.dismiss(animated: true)
        }))
        vc.present(alert, animated: true, completion: nil)
        return
        
    }
}

