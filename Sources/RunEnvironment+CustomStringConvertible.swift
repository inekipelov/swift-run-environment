//
//  RunEnvironment+CustomStringConvertible.swift
//

import Foundation

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
