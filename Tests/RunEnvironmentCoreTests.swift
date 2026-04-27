import Testing
@testable import RunEnvironment

@Suite("RunEnvironment Core")
struct RunEnvironmentCoreTests {
    @Test("CaseIterable contains all environments")
    func caseIterableContainsAllEnvironments() {
        let allCases = RunEnvironment.allCases
        #expect(allCases.count == 3)
        #expect(allCases.contains(.debug))
        #expect(allCases.contains(.testFlight))
        #expect(allCases.contains(.appStore))
    }

    @Test("Raw values")
    func rawValues() {
        #expect(RunEnvironment.debug.rawValue == "debug")
        #expect(RunEnvironment.testFlight.rawValue == "testFlight")
        #expect(RunEnvironment.appStore.rawValue == "appStore")
    }

    @Test("Description values")
    func description() {
        #expect(RunEnvironment.debug.description == "debug")
        #expect(RunEnvironment.testFlight.description == "testFlight")
        #expect(RunEnvironment.appStore.description == "appStore")
    }

    @Test("Aliases")
    func aliases() {
        #expect(RunEnvironment.xcode == .debug)
        #expect(RunEnvironment.sandbox == .testFlight)
        #expect(RunEnvironment.production == .appStore)
    }

    @Test("Current environment is valid")
    func currentEnvironmentIsValid() {
        let current = RunEnvironment.current
        #expect(RunEnvironment.allCases.contains(current))
    }

    @Test("Current environment is consistent")
    func currentEnvironmentIsConsistent() {
        #expect(RunEnvironment.current == RunEnvironment.current)
    }

    @Test("String(describing:) mirrors raw value")
    func stringConvertibility() {
        #expect(String(describing: RunEnvironment.debug) == "debug")
        #expect(String(describing: RunEnvironment.testFlight) == "testFlight")
        #expect(String(describing: RunEnvironment.appStore) == "appStore")
    }

    @Test("Equality")
    func equality() {
        #expect(RunEnvironment.debug == .debug)
        #expect(RunEnvironment.testFlight == .testFlight)
        #expect(RunEnvironment.appStore == .appStore)

        #expect(RunEnvironment.debug != .testFlight)
        #expect(RunEnvironment.testFlight != .appStore)
        #expect(RunEnvironment.debug != .appStore)
    }

    @Test("Switch handles all enum cases")
    func switchCompleteness() {
        for environment in RunEnvironment.allCases {
            let result: String
            switch environment {
            case .debug:
                result = "development"
            case .testFlight:
                result = "beta"
            case .appStore:
                result = "production"
            }
            #expect(!result.isEmpty)
        }
    }
}
