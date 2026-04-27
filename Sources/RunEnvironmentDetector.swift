//
//  RunEnvironmentDetector.swift
//

import Foundation
#if canImport(Security)
import Security
#endif

/// A strategy for resolving the app runtime environment.
public protocol RunEnvironmentDetector {
    /// The runtime environment resolved by this detector.
    var runEnvironment: RunEnvironment { get }
}

struct BundleEnvironmentDetector: RunEnvironmentDetector {
    let bundle: Bundle

    var runEnvironment: RunEnvironment {
#if DEBUG
        return .debug
#elseif targetEnvironment(simulator)
        return .debug
#else
        if bundle.isMacOSTestFlightSigned {
            return .testFlight
        }

        if let url = bundle.appStoreReceiptURL {
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

private extension Bundle {
    /// Detects whether a macOS app bundle is signed as a TestFlight build.
    ///
    /// Reference:
    /// https://gist.github.com/lukaskubanek/cbfcab29c0c93e0e9e0a16ab09586996
    var isMacOSTestFlightSigned: Bool {
#if os(macOS) && canImport(Security)
        // Build a static-code object for this bundle so Security can evaluate
        // signing requirements against the app's existing signature on disk.
        var code: SecStaticCode?
        guard SecStaticCodeCreateWithPath(bundleURL as CFURL, [], &code) == errSecSuccess,
              let code else {
            return false
        }

        // Requirement checks for Apple's TestFlight-specific leaf-certificate
        // extension OID: 1.2.840.113635.100.6.1.25.1.
        var requirement: SecRequirement?
        guard SecRequirementCreateWithString(
            "anchor apple generic and certificate leaf[field.1.2.840.113635.100.6.1.25.1]" as CFString,
            [],
            &requirement
        ) == errSecSuccess,
        let requirement else {
            return false
        }

        // Signature is considered TestFlight when the bundle satisfies
        // the requirement above under default validation flags.
        return SecStaticCodeCheckValidity(code, [], requirement) == errSecSuccess
#else
        // This check is macOS-specific by design; other platforms use
        // receipt/provisioning heuristics in RunEnvironment.current.
        return false
#endif
    }
}
