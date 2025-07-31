//
//  RunEnvironment.swift
//

import Foundation

/// A type representing the current runtime environment of an application.
///
/// ## Usage
///
/// ```swift
/// switch RunEnvironment.current {
/// case .debug:
///     print("Running in development")
/// case .testFlight:
///     print("Running in TestFlight")
/// case .appStore:
///     print("Running in App Store")
/// }
/// ```
///
public enum RunEnvironment: String, CaseIterable {
    /// Development environment used during debugging and development.
    ///
    /// This case is returned when:
    /// - The app is compiled with `DEBUG` flag
    /// - The app is running in the iOS Simulator
    /// - No App Store receipt is found
    case debug
    
    /// TestFlight environment for beta testing.
    ///
    /// This case is returned when:
    /// - App Store receipt contains "sandboxreceipt"
    /// - An embedded provisioning profile is detected
    case testFlight
    
    /// Production App Store environment.
    ///
    /// This case is returned for apps distributed through the App Store
    /// that don't match debug or TestFlight criteria.
    case appStore
    
    // MARK: - Aliases
    
    /// Alias for debug environment, commonly used in Xcode development.
    ///
    /// Provides a semantic alias for `.debug` that makes code more readable
    /// when checking for Xcode development environment.
    ///
    /// ```swift
    /// if RunEnvironment.current == .xcode {
    ///     // Development-specific code
    /// }
    /// ```
    public static var xcode: RunEnvironment { .debug }
    
    /// Alias for TestFlight environment, representing the sandbox environment.
    ///
    /// Provides a semantic alias for `.testFlight` that emphasizes the
    /// sandboxed nature of TestFlight builds.
    /// - Warning:
    /// This alias is not same as Notification Environment `sandbox`
    ///
    /// ```swift
    /// if RunEnvironment.current == .sandbox {
    ///     // TestFlight-specific code
    /// }
    /// ```
    public static var sandbox: RunEnvironment { .testFlight }
    
    /// Alias for App Store environment, representing the production environment.
    ///
    /// Provides a semantic alias for `.appStore` that emphasizes the
    /// production nature of App Store builds.
    ///
    /// ```swift
    /// if RunEnvironment.current == .production {
    ///     // Production-specific code
    /// }
    /// ```
    public static var production: RunEnvironment { .appStore }
    
    // MARK: - Current Environment Detection
    
    /// The currently detected runtime environment.
    ///
    /// This computed property automatically determines the current environment
    /// using a combination of compile-time flags, runtime checks, and system APIs.
    ///
    /// ## Platform Considerations
    ///
    /// On macOS 15.0+, iOS 18.0+, watchOS 11.0+, and tvOS 18.0+,
    /// App Store receipt URL may not be available, so detection relies
    /// primarily on provisioning profile analysis.
    ///
    /// ## Examples
    ///
    /// ```swift
    /// // Basic usage
    /// let env = RunEnvironment.current
    /// print("Current environment: \(env)")
    ///
    /// // Conditional behavior
    /// switch RunEnvironment.current {
    /// case .debug:
    ///     enableDebugLogging()
    /// case .testFlight:
    ///     enableAnalytics(level: .basic)
    /// case .appStore:
    ///     enableAnalytics(level: .full)
    /// }
    /// ```
    ///
    /// - Returns: The detected `RunEnvironment` for the current runtime context
    public static var current: RunEnvironment {
#if DEBUG
        return .debug
#elseif targetEnvironment(simulator)
        return .debug
#else
        let bundle = Bundle.main
        if #available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, *) {
            // Note: App Store receipt URL is not available on these platform versions
        } else {
            guard let url = bundle.appStoreReceiptURL else {
                return .debug
            }
            let filename = url.lastPathComponent.lowercased()
            if filename == "sandboxreceipt" || filename.contains("sandboxreceipt") {
                return .testFlight
            }
        }
        
        if bundle.path(forResource: "embedded", ofType: "mobileprovision") != nil {
            return .testFlight
        }
        
        return .appStore
#endif
    }
}

// MARK: - CustomStringConvertible

extension RunEnvironment: CustomStringConvertible {
    /// A textual representation of the run environment.
    ///
    /// Returns the raw string value of the environment case,
    /// suitable for logging, debugging, and display purposes.
    ///
    /// ## Examples
    ///
    /// ```swift
    /// print(RunEnvironment.debug.description)     // "debug"
    /// print(RunEnvironment.testFlight.description) // "testFlight"
    /// print(RunEnvironment.appStore.description)   // "appStore"
    /// ```
    ///
    /// - Returns: The string representation of the environment
    public var description: String { rawValue }
}

// MARK: - Reactive like methods
extension RunEnvironment {
    @discardableResult
    public func onDebug(_ closure: () throws -> Void) rethrows -> RunEnvironment {
        if self == .debug {
            try closure()
        }
        return self
    }
    @discardableResult
    public func onDebug(_ closure: (RunEnvironment) throws -> Void) rethrows -> RunEnvironment {
        if self == .debug {
            try closure(self)
        }
        return self
    }

    @discardableResult
    public func onTestFlight(_ closure: () throws -> Void) rethrows -> RunEnvironment {
        if self == .testFlight {
            try closure()
        }
        return self
    }
    @discardableResult
    public func onTestFlight(_ closure: (RunEnvironment) throws -> Void) rethrows -> RunEnvironment {
        if self == .testFlight {
            try closure(self)
        }
        return self
    }

    @discardableResult
    public func onAppStore(_ closure: () throws -> Void) rethrows -> RunEnvironment {
        if self == .appStore {
            try closure()
        }
        return self
    }
    @discardableResult
    public func onAppStore(_ closure: (RunEnvironment) throws -> Void) rethrows -> RunEnvironment {
        if self == .appStore {
            try closure(self)
        }
        return self
    }
}

// MARK: - Reviewing
extension RunEnvironment {
    /// Indicates if the app is currently under review. This is determined by specific environment variables that are set during the app review process.
    ///
    /// [LinkedIn Original Post](https://www.linkedin.com/posts/ihormalovanyi_xcode-iosdeveloper-swift-activity-7350928940967821313-ISJm?utm_source=share&utm_medium=member_desktop&rcm=ACoAAB5wItMB9qxBB_nU7GXf73JvMnHmnZJd49M)
    public var underReview: Bool {
        let processInfo = ProcessInfo.processInfo
        let environment = processInfo.environment
        
        // Check for specific review-time environment variables
        return environment["CFNETWORK_DIAGNOSTICS"] != nil ||
               environment["CFNETWORK_HAR_LOGGING"] != nil
    }

    /// Executes the provided closure if the app is currently under review.
    /// This allows you to conditionally run code that should only execute during the app review process.
    ///
    /// ## Examples
    /// ```swift
    /// RunEnvironment.current.onReview {
    ///     // Code to execute during app review
    ///     print("App is under review")
    /// }
    /// ```
    ///
    /// - Parameter closure: The closure to execute if the app is under review
    /// - Throws: Rethrows any error thrown by the closure
    @discardableResult
    public func onReview(_ closure: () throws -> Void) rethrows -> RunEnvironment {
        if underReview {
            try closure()
        }
        return self
    }
    @discardableResult
    public func onReview(_ closure: (RunEnvironment) throws -> Void) rethrows -> RunEnvironment {
        if underReview {
            try closure(self)
        }
        return self
    }
}

public func ~=(witness: KeyPath<RunEnvironment, Bool>, value: RunEnvironment) -> Bool {
    return value[keyPath: witness]
}
