//
//  Copyright © 2017 Vlas Voloshin. All rights reserved.
//

import UIKit

@objc(RALAlertState)
public enum AlertState: Int {
    case willPresent = 0
    case didPresent
    case willDismiss
    case didDismiss
}

public typealias AlertStateHandler = (UIAlertController, AlertState) -> Void
