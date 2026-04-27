//
//  RunEnvironment+Reactive.swift
//

import Foundation

extension RunEnvironment {
    /// Executes a closure only when the environment is `.debug`.
    ///
    /// - Parameter closure: Closure executed for debug builds.
    /// - Returns: The current `RunEnvironment` for chaining.
    /// - Throws: Rethrows any error from `closure`.
    @discardableResult
    public func onDebug(_ closure: () throws -> Void) rethrows -> RunEnvironment {
        if self == .debug {
            try closure()
        }
        return self
    }

    /// Executes a closure with the current environment only when it is `.debug`.
    ///
    /// - Parameter closure: Closure executed for debug builds.
    /// - Returns: The current `RunEnvironment` for chaining.
    /// - Throws: Rethrows any error from `closure`.
    @discardableResult
    public func onDebug(_ closure: (RunEnvironment) throws -> Void) rethrows -> RunEnvironment {
        if self == .debug {
            try closure(self)
        }
        return self
    }

    /// Executes a closure only when the environment is `.testFlight`.
    ///
    /// - Parameter closure: Closure executed for TestFlight builds.
    /// - Returns: The current `RunEnvironment` for chaining.
    /// - Throws: Rethrows any error from `closure`.
    @discardableResult
    public func onTestFlight(_ closure: () throws -> Void) rethrows -> RunEnvironment {
        if self == .testFlight {
            try closure()
        }
        return self
    }

    /// Executes a closure with the current environment only when it is `.testFlight`.
    ///
    /// - Parameter closure: Closure executed for TestFlight builds.
    /// - Returns: The current `RunEnvironment` for chaining.
    /// - Throws: Rethrows any error from `closure`.
    @discardableResult
    public func onTestFlight(_ closure: (RunEnvironment) throws -> Void) rethrows -> RunEnvironment {
        if self == .testFlight {
            try closure(self)
        }
        return self
    }

    /// Executes a closure only when the environment is `.appStore`.
    ///
    /// - Parameter closure: Closure executed for App Store builds.
    /// - Returns: The current `RunEnvironment` for chaining.
    /// - Throws: Rethrows any error from `closure`.
    @discardableResult
    public func onAppStore(_ closure: () throws -> Void) rethrows -> RunEnvironment {
        if self == .appStore {
            try closure()
        }
        return self
    }

    /// Executes a closure with the current environment only when it is `.appStore`.
    ///
    /// - Parameter closure: Closure executed for App Store builds.
    /// - Returns: The current `RunEnvironment` for chaining.
    /// - Throws: Rethrows any error from `closure`.
    @discardableResult
    public func onAppStore(_ closure: (RunEnvironment) throws -> Void) rethrows -> RunEnvironment {
        if self == .appStore {
            try closure(self)
        }
        return self
    }
}
