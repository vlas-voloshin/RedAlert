//
//  Copyright © 2017 Vlas Voloshin. All rights reserved.
//

import UIKit

public extension UIAlertController {

    @objc(ral_presentGloballyAnimated:withStateHandler:)
    func presentGlobally(animated: Bool, stateHandler: AlertStateHandler? = nil) {
        AlertPresenter.shared.present(self, animated: animated, stateHandler: stateHandler)
    }

    @objc(ral_presentGlobally)
    func presentGlobally() {
        self.presentGlobally(animated: true, stateHandler: nil)
    }

}
