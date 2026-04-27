# RunEnvironment

`RunEnvironment` is a lightweight Swift Package for runtime environment detection.

It provides a small typed API to distinguish `debug`, `testFlight`, and `appStore`
runtime contexts, plus convenience helpers for review-time checks and conditional execution.

<p align="center">
  <a href="https://swift.org"><img src="https://img.shields.io/badge/Swift-5.6+-F05138?logo=swift&logoColor=white" alt="Swift 5.6+"></a>
  <a href="https://developer.apple.com/ios/"><img src="https://img.shields.io/badge/iOS-9.0+-CAFC63?logo=apple" alt="iOS 9.0+"></a>
  <a href="https://developer.apple.com/macos/"><img src="https://img.shields.io/badge/macOS-10.13+-CAFC63?logo=apple" alt="macOS 10.13+"></a>
  <a href="https://developer.apple.com/tvos/"><img src="https://img.shields.io/badge/tvOS-9.0+-CAFC63?logo=apple" alt="tvOS 9.0+"></a>
  <a href="https://developer.apple.com/watchos/"><img src="https://img.shields.io/badge/watchOS-2.0+-CAFC63?logo=apple" alt="watchOS 2.0+"></a>
</p>

## Usage

```swift
import RunEnvironment

switch RunEnvironment.current {
case .debug:
    print("Development")
case .testFlight:
    print("TestFlight beta")
case .appStore:
    print("Production")
}

if RunEnvironment.current == .production {
    enableAnalytics()
}

RunEnvironment.current
    .onTestFlight {
        enableBetaLogging()
    }
    .onAppStore {
        enableFullAnalytics()
    }

if RunEnvironment.current.underReview {
    captureReviewerActions()
}

RunEnvironment.current.onReview {
    captureReviewerActions()
}
```

## Installation

Add the package to your `Package.swift` dependencies:

```swift
.package(url: "https://github.com/inekipelov/swift-run-environment.git", from: "0.2.0")
```

Then add `RunEnvironment` to your target dependencies:

```swift
.target(
    name: "YourTarget",
    dependencies: [
        "RunEnvironment"
    ]
)
```
