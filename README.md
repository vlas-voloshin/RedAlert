# Red Alert

[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage) [![CocoaPods](https://img.shields.io/cocoapods/v/RedAlert.svg?maxAge=604800)]() [![CocoaPods](https://img.shields.io/cocoapods/p/RedAlert.svg?maxAge=2592000)]() [![CocoaPods](https://img.shields.io/cocoapods/l/RedAlert.svg?maxAge=2592000)]()

Red Alert is a small Swift library for iOS apps which provides a way to present `UIAlertController`-based alerts in an "app-global" fashion, similarly to the now-deprecated `UIAlertView`.

### Disclaimer
Presenting alerts globally is generally not recommended. Ideally, each alert should be presented in the context of the view controller it's originated from. However, some apps that have been structured with `UIAlertView` in mind would need significant refactoring to fully transition to view controller-based alerts. If such refactoring is not immediately feasible, Red Alert can provide a temporary solution that allows moving away from `UIAlertView` API wihout addressing the structural problem at the same time.

## How it works
Red Alert manages a temporary overlay window with an empty view controller. Alert controllers are presented from that view controller. If multiple alerts are requested, they're queued up. Once the last alert is dismissed, the window is automatically destroyed. This approach is similar to the implementation of backwards-compatible presentation of `UIAlertView` instances in newer iOS releases.

## Requirements
- Xcode 8.3+ (written in Swift 3.2, compatible with 3.1)
- iOS 8.0+
- Compatible with Objective-C

## Installation

### Carthage

1. Add the following line to your `Cartfile`:

    ```
    github "vlas-voloshin/RedAlert"
    ```
    
1. Follow the instructions outlined in [Carthage documentation](https://github.com/Carthage/Carthage/blob/master/README.md) to build and integrate the library into your app.

### CocoaPods

1. Add the following line to your `Podfile`:

	```
	pod 'RedAlert'
	```
	
2. Execute `pod install`.

### Manual

1. Download and copy the repository source files into your project, or add it as a submodule to your git repository.
1. Drag&drop `RedAlert.xcodeproj` into your project or workspace in Xcode.
1. In "General" tab of Project Settings → `Your Target`, you might find that Xcode has added a missing framework item in "Embedded Binaries". Delete it for now.
1. Still in "General" tab, add `RedAlert.framework` to "Embedded Binaries". This should also add it to "Linked Frameworks and Libraries". 

## Usage

First off, import `RedAlert` module in the source file where you're planning to use it. Then choose one of the presentation methods:

### Easiest
Create and configure your `UIAlertController` instance and call `presentGlobally()` extension method (`-ral_presentGlobally` in Objective-C) on it.

### More advanced
Instead of calling `presentGlobally()` (`-ral_presentGlobally`) on the alert, call `presentGlobally(animated:, stateHandler:)` (`ral_presentGloballyAnimated:withStateHandler:`) to specify whether the presentation should be animated, and pass an optional closure for notifications about the alert states.

### Most flexible
While extension methods use a singleton instance of an `AlertPresenter` (`RALAlertPresenter`) class that manages the temporary window and presents the alerts, you can also create your own instances of it. Initialise it with the preferred window level, retain it for the lifetime of your alerts, and use its `present(_:, animated:, stateHandler:)` method to present alert controllers.

## License

This library is available under the MIT license. See the `LICENSE` file for more info.
