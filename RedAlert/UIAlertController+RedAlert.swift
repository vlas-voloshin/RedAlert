//
//  Copyright © 2017 Vlas Voloshin. All rights reserved.
//

import UIKit

public extension UIAlertController {

    /// Convenience method that presents the receiver using a singleton instance of `AlertPresenter`.
    /// - parameter animated: Flag that determines whether the alert should be presented with an animation.
    /// - parameter stateHandler: Block invoked during presentation and dismissal of the alert. Arguments passed in this block are:
    ///     - Alert controller being presented or dismissed,
    ///     - `AlertState` value that determines the event. See its documentation for more details.
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
