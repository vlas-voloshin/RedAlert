//
//  Copyright © 2017 Vlas Voloshin. All rights reserved.
//

import UIKit

/// Enumeration values that determine the current state of an alert in the presenter.
@objc(RALAlertState)
public enum AlertState: Int {
    /// The alert is about to be presented.
    case willPresent = 0
    /// The alert has just been presented.
    case didPresent
    /// The alert is about to be dismissed. The action that triggered the dismissal will be invoked shortly after.
    case willDismiss
    /// The alert has been dismissed. The action that triggered the dismissal has already been invoked at this point.
    case didDismiss
}

public typealias AlertStateHandler = (UIAlertController, AlertState) -> Void
