//
//  Copyright © 2017 Vlas Voloshin. All rights reserved.
//

import UIKit

/// Helper class that allows displaying and destroying an emphemeral overlay window that hosts the specified view controller.
final internal class WindowManager {

    let rootViewController: RootViewController
    let windowLevel: UIWindowLevel

    init(viewController: RootViewController, windowLevel: UIWindowLevel) {
        self.rootViewController = viewController
        self.windowLevel = windowLevel
    }

    // MARK: Window management

    private var alertWindow: UIWindow?
    private weak var lastKeyWindow: UIWindow?

    func showAlertWindow() {
        guard self.alertWindow == nil else {
            return
        }

        let alertWindow = WindowManager.makeAlertWindow(with: self.rootViewController, at: self.windowLevel)
        self.alertWindow = alertWindow

        self.lastKeyWindow = UIApplication.shared.keyWindow
        self.rootViewController.statusBarStyle = UIApplication.shared.statusBarStyle
        self.rootViewController.isStatusBarHidden = UIApplication.shared.isStatusBarHidden

        alertWindow.makeKeyAndVisible()
    }

    func hideAlertWindow() {
        guard let alertWindow = self.alertWindow else {
            return
        }

        alertWindow.isHidden = true
        self.alertWindow = nil

        let newKeyWindow = self.lastKeyWindow ?? UIApplication.shared.windows.first
        newKeyWindow?.makeKeyAndVisible()
        self.lastKeyWindow = nil
    }

    private static func makeAlertWindow(with viewController: UIViewController, at windowLevel: UIWindowLevel) -> UIWindow {
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.backgroundColor = .clear
        window.windowLevel = windowLevel
        window.rootViewController = viewController

        window.accessibilityIdentifier = "RALGlobalAlertWindow"

        return window
    }

}
