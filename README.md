# RunEnvironment

[![Swift Version](https://img.shields.io/badge/Swift-5.6+-orange.svg)](https://swift.org/)
[![SPM](https://img.shields.io/badge/SPM-compatible-brightgreen.svg)](https://swift.org/package-manager/)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![Swift Tests](https://github.com/inekipelov/swift-run-environment/actions/workflows/swift.yml/badge.svg)](https://github.com/inekipelov/swift-run-environment/actions/workflows/swift.yml)  
[![iOS](https://img.shields.io/badge/iOS-9.0+-blue.svg)](https://developer.apple.com/ios/)
[![macOS](https://img.shields.io/badge/macOS-10.13+-white.svg)](https://developer.apple.com/macos/)
[![tvOS](https://img.shields.io/badge/tvOS-9.0+-black.svg)](https://developer.apple.com/tvos/)
[![watchOS](https://img.shields.io/badge/watchOS-2.0+-orange.svg)](https://developer.apple.com/watchos/)

Runtime environment detection for Swift apps.

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

// Aliases
if RunEnvironment.current == .production {
    enableAnalytics()
}
```

## Installation

```swift
dependencies: [
    .package(url: "https://github.com/inekipelov/swift-run-environment.git", from: "0.1.0")
]
```