//
//  AppDelegate.swift
//  WeatherApp
//
//  Created by tamu on 23/03/23.
//

import UIKit
import IQKeyboardManagerSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        makeViewAndSetupAppearance()
        
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.toolbarDoneBarButtonItemText = NSLocalizedString("Done", comment: "")
        return true
    }

}

extension AppDelegate {
    func makeViewAndSetupAppearance() {
        window = UIWindow(frame: UIScreen.main.bounds)
        let mainVC = MainViewController(nibName:"MainViewController", bundle:nil)
        let navVC = UINavigationController(rootViewController: mainVC)
        window?.rootViewController = navVC
        window?.makeKeyAndVisible()
    }
}
