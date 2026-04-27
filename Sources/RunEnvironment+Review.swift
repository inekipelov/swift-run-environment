//
//  RunEnvironment+Review.swift
//

import Foundation

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

    /// Executes the provided closure with the current environment when the app is under review.
    ///
    /// - Parameter closure: The closure to execute if the app is under review.
    /// - Throws: Rethrows any error thrown by the closure.
    /// - Returns: The current `RunEnvironment` for chaining.
    @discardableResult
    public func onReview(_ closure: (RunEnvironment) throws -> Void) rethrows -> RunEnvironment {
        if underReview {
            try closure(self)
        }
        return self
    }
}
