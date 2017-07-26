//
//  Copyright © 2017 Vlas Voloshin. All rights reserved.
//

import UIKit

final class WindowManager {

    let window: UIWindow = {
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.backgroundColor = .clear
        window.windowLevel = UIWindowLevelAlert
        return window
    }()
    let rootViewController: RootViewController

    init(viewController: RootViewController) {
        self.rootViewController = viewController

        self.window.rootViewController = self.rootViewController
    }

    // MARK: Window management

    private weak var lastKeyWindow: UIWindow?

    func showAlertWindow() {
        guard self.window.isHidden else {
            return
        }

        self.rootViewController.statusBarStyle = UIApplication.shared.statusBarStyle
        self.lastKeyWindow = UIApplication.shared.keyWindow

        self.window.makeKeyAndVisible()
    }

    func hideAlertWindow() {
        self.window.isHidden = true
        self.lastKeyWindow?.makeKeyAndVisible()
        self.lastKeyWindow = nil
    }

}
