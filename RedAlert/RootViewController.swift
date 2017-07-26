//
//  Copyright © 2017 Vlas Voloshin. All rights reserved.
//

import UIKit

final class RootViewController: UIViewController {

    weak var delegate: RootViewControllerDelegate?

    var statusBarStyle: UIStatusBarStyle = .default {
        didSet {
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return self.statusBarStyle
    }

    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        guard let alertController = self.presentedViewController as? UIAlertController else {
            super.dismiss(animated: flag, completion: completion)
            return
        }

        self.delegate?.rootViewController(self, willDismiss: alertController)

        super.dismiss(animated: flag) {
            completion?()
            self.delegate?.rootViewController(self, didDismiss: alertController)
        }
    }

}

protocol RootViewControllerDelegate: class {
    func rootViewController(_ viewController: RootViewController, willDismiss alertController: UIAlertController)
    func rootViewController(_ viewController: RootViewController, didDismiss alertController: UIAlertController)
}
