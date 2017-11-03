//
//  Copyright © 2017 Vlas Voloshin. All rights reserved.
//

import UIKit

/// Presents alerts (instances of UIAlertController) in a separate overlay window managed automatically.
/// - note: The easiest way to use this class is via the singleton property `shared`, but it can also be instantiated manually. In this case, however, such instance needs to be retained for the lifetime of the alert.
@objc(RALAlertPresenter)
public final class AlertPresenter: NSObject, RootViewControllerDelegate {

    /// Singleton alert presenter instance. Alerts presented using this instance appear at the "alert" window level.
    @objc(sharedInstance)
    public static let shared = AlertPresenter(windowLevel: UIWindowLevelAlert)

    /// Initializes an instance of an alert presenter with the specified window level. Alerts presented using this instance would appear at this window level.
    @objc
    public init(windowLevel: UIWindowLevel) {
        self.windowManager = WindowManager(viewController: self.rootViewController, windowLevel: windowLevel)

        super.init()

        self.rootViewController.delegate = self
    }

    /// Presents an alert controller in an overlay window. The window is shown while the alert is presented, and destroyed once the alert is dismissed.
    /// - note: If this method is called while the receiver is already displaying another alert, the new one is queued to be presented once the current one is dismissed.
    /// - parameter alertController: Alert controller to present.
    /// - parameter animated: Flag that determines whether the alert should be presented with an animation.
    /// - parameter stateHandler: Block invoked during presentation and dismissal of the alert. Arguments passed in this block are:
    ///     - Alert controller being presented or dismissed,
    ///     - `AlertState` value that determines the event. See its documentation for more details.
    @objc(presentAlert:animated:withStateHandler:)
    public func present(_ alertController: UIAlertController, animated: Bool, stateHandler: AlertStateHandler? = nil) {
        let item = AlertItem(controller: alertController, shouldAnimate: animated, handler: stateHandler)
        self.queue.append(item)

        self.serviceQueueIfPossible(showingWindow: true)
    }

    // MARK: Implementation

    private struct AlertItem {
        let controller: UIAlertController
        let shouldAnimate: Bool
        let handler: AlertStateHandler?
    }

    private let rootViewController = RootViewController()
    private let windowManager: WindowManager

    private var queue = [AlertItem]()
    private var servicedItem: AlertItem?

    @discardableResult
    private func serviceQueueIfPossible(showingWindow shouldShowWindow: Bool) -> Bool {
        guard self.servicedItem == nil else {
            // Already servicing an alert
            return false
        }
        guard self.queue.isEmpty == false else {
            // Queue is empty, can't service
            return false
        }

        if shouldShowWindow {
            self.windowManager.showAlertWindow()
        }

        let item = self.queue.removeFirst()
        self.servicedItem = item

        item.handler?(item.controller, .willPresent)
        self.rootViewController.present(item.controller, animated: item.shouldAnimate) {
            item.handler?(item.controller, .didPresent)
        }

        return true
    }

    // MARK: RootViewControllerDelegate

    func rootViewController(_ viewController: RootViewController, willDismiss alertController: UIAlertController) {
        if let item = self.servicedItem {
            item.handler?(alertController, .willDismiss)
        } else {
            assertionFailure("Alert controller is being dismissed, but alert presenter is not servicing any... This indicates invalid state.")
        }
    }

    func rootViewController(_ viewController: RootViewController, didDismiss alertController: UIAlertController) {
        if let item = self.servicedItem {
            item.handler?(alertController, .didDismiss)
            self.servicedItem = nil

            if self.serviceQueueIfPossible(showingWindow: false) == false {
                // No more items in the queue - hide the window
                self.windowManager.hideAlertWindow()
            }
        } else {
            assertionFailure("Alert controller has been dismissed, but alert presenter is not servicing any... This indicates invalid state.")
        }
    }

}
