//
//  Copyright © 2017 Vlas Voloshin. All rights reserved.
//

import UIKit

@objc(RALAlertPresenter)
public final class AlertPresenter: NSObject, RootViewControllerDelegate {

    @objc(sharedInstance)
    public static let shared = AlertPresenter(windowLevel: UIWindowLevelAlert)

    public init(windowLevel: UIWindowLevel) {
        self.windowManager = WindowManager(viewController: self.rootViewController, windowLevel: windowLevel)

        super.init()

        self.rootViewController.delegate = self
    }

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
