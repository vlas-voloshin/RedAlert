//
//  Copyright © 2017 Vlas Voloshin. All rights reserved.
//

import UIKit

/// Empty view controller that acts as a root view controller of the alert overlay window, allows controlling the status bar style and hidden state, and provides delegate callbacks for modal view controller dismissal events. 
final internal class RootViewController: UIViewController {

    weak var delegate: RootViewControllerDelegate?

    var statusBarStyle: UIStatusBarStyle = .default {
        didSet {
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }

    var isStatusBarHidden: Bool = false {
        didSet {
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return self.statusBarStyle
    }

    override var prefersStatusBarHidden: Bool {
        return self.isStatusBarHidden
    }

    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        guard let alertController = self.presentedViewController as? UIAlertController else {
            super.dismiss(animated: flag, completion: completion)
            return
        }

        self.delegate?.rootViewController(self, willDismiss: alertController)

        super.dismiss(animated: flag) {
            // Provided completion block will invoke the alert action
            completion?()
            self.delegate?.rootViewController(self, didDismiss: alertController)
        }
    }

}

internal protocol RootViewControllerDelegate: class {
    func rootViewController(_ viewController: RootViewController, willDismiss alertController: UIAlertController)
    func rootViewController(_ viewController: RootViewController, didDismiss alertController: UIAlertController)
}
