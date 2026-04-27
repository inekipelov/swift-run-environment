//
//  RunEnvironment+PatternMatching.swift
//

import Foundation

/// Supports pattern matching with `KeyPath<RunEnvironment, Bool>` inside `switch` statements.
///
/// Example:
/// ```swift
/// switch RunEnvironment.current {
/// case \.underReview:
///     print("Under review")
/// default:
///     break
/// }
/// ```
///
/// - Parameters:
///   - witness: A boolean key path used as the pattern.
///   - value: The value being matched.
/// - Returns: `true` when the key-path value is `true`.
public func ~=(witness: KeyPath<RunEnvironment, Bool>, value: RunEnvironment) -> Bool {
    value[keyPath: witness]
}
