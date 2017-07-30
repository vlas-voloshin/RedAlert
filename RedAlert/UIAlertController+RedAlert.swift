//
//  Copyright © 2017 Vlas Voloshin. All rights reserved.
//

import UIKit

public extension UIAlertController {

    /// Convenience method that presents the receiver using a singleton instance of `AlertPresenter`.
    @objc(ral_presentGloballyAnimated:withStateHandler:)
    func presentGlobally(animated: Bool, stateHandler: AlertStateHandler? = nil) {
        AlertPresenter.shared.present(self, animated: animated, stateHandler: stateHandler)
    }

    /// Convenience method that presents the receiver with an animation using a singleton instance of `AlertPresenter`.
    @objc(ral_presentGlobally)
    func presentGlobally() {
        self.presentGlobally(animated: true, stateHandler: nil)
    }

}
