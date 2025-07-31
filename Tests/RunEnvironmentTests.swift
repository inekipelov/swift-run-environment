//
//  RunEnvironmentTests.swift
//
import XCTest
@testable import RunEnvironment

final class RunEnvironmentTests: XCTestCase {
    
    // MARK: - Basic Enum Tests
    
    func testCaseIterable() {
        let allCases = RunEnvironment.allCases
        XCTAssertEqual(allCases.count, 3)
        XCTAssertTrue(allCases.contains(.debug))
        XCTAssertTrue(allCases.contains(.testFlight))
        XCTAssertTrue(allCases.contains(.appStore))
    }
    
    func testRawValues() {
        XCTAssertEqual(RunEnvironment.debug.rawValue, "debug")
        XCTAssertEqual(RunEnvironment.testFlight.rawValue, "testFlight")
        XCTAssertEqual(RunEnvironment.appStore.rawValue, "appStore")
    }
    
    func testDescription() {
        XCTAssertEqual(RunEnvironment.debug.description, "debug")
        XCTAssertEqual(RunEnvironment.testFlight.description, "testFlight")
        XCTAssertEqual(RunEnvironment.appStore.description, "appStore")
    }
    
    // MARK: - Alias Tests
    
    func testAliases() {
        XCTAssertEqual(RunEnvironment.xcode, .debug)
        XCTAssertEqual(RunEnvironment.sandbox, .testFlight)
        XCTAssertEqual(RunEnvironment.production, .appStore)
    }
    
    // MARK: - Current Environment Tests
    
    func testCurrentEnvironmentIsNotNil() {
        // Verify that current returns a valid value
        let current = RunEnvironment.current
        XCTAssertTrue(RunEnvironment.allCases.contains(current))
    }
    
    func testCurrentEnvironmentConsistency() {
        // Verify that current returns the same value on repeated calls
        let first = RunEnvironment.current
        let second = RunEnvironment.current
        XCTAssertEqual(first, second)
    }
    
    // MARK: - String Conversion Tests
    
    func testStringConvertibility() {
        let debugString = String(describing: RunEnvironment.debug)
        let testFlightString = String(describing: RunEnvironment.testFlight)
        let appStoreString = String(describing: RunEnvironment.appStore)
        
        XCTAssertEqual(debugString, "debug")
        XCTAssertEqual(testFlightString, "testFlight")
        XCTAssertEqual(appStoreString, "appStore")
    }
    
    // MARK: - Equality Tests
    
    func testEquality() {
        XCTAssertEqual(RunEnvironment.debug, RunEnvironment.debug)
        XCTAssertEqual(RunEnvironment.testFlight, RunEnvironment.testFlight)
        XCTAssertEqual(RunEnvironment.appStore, RunEnvironment.appStore)
        
        XCTAssertNotEqual(RunEnvironment.debug, RunEnvironment.testFlight)
        XCTAssertNotEqual(RunEnvironment.testFlight, RunEnvironment.appStore)
        XCTAssertNotEqual(RunEnvironment.debug, RunEnvironment.appStore)
    }
    
    // MARK: - Switch Statement Tests
    
    func testSwitchStatementCompleteness() {
        // Verify that switch statement handles all cases
        for environment in RunEnvironment.allCases {
            var result: String
            switch environment {
            case .debug:
                result = "development"
            case .testFlight:
                result = "beta"
            case .appStore:
                result = "production"
            }
            XCTAssertFalse(result.isEmpty)
        }
    }
    
    // MARK: - Review Pattern Matching Tests
    
    func testReviewPatternMatching() {
        // Create test environment with mock environment variables
        let environments: [RunEnvironment] = [.debug, .testFlight, .appStore]

        // Test basic pattern matching
        for environment in environments {
            switch environment {
            case let value where \.underReview ~= value:
                // This case will match if underReview returns true
                XCTAssertTrue(environment.underReview)
            case \.underReview:
                XCTAssertTrue(environment.underReview)
            default:
                // This case will match if underReview returns false
                XCTAssertFalse(environment.underReview)
            }
        }
    }
    
    func testReviewPatternWithWhereClause() {
        let environments: [RunEnvironment] = [.debug, .testFlight, .appStore]
        
        for environment in environments {
            var matchedSpecificCase = false
            
            switch environment {
            case .debug where \.underReview ~= environment:
                matchedSpecificCase = true
                XCTAssertEqual(environment, .debug)
                XCTAssertTrue(environment.underReview)
            case .testFlight where \.underReview ~= environment:
                matchedSpecificCase = true
                XCTAssertEqual(environment, .testFlight)
                XCTAssertTrue(environment.underReview)
            case .appStore where \.underReview ~= environment:
                matchedSpecificCase = true
                XCTAssertEqual(environment, .appStore)
                XCTAssertTrue(environment.underReview)
            default:
                // Case when not under review or doesn't match specific environment
                break
            }
            
            // If we matched a specific case, the environment should be under review
            if matchedSpecificCase {
                XCTAssertTrue(environment.underReview)
            }
        }
    }
    
    // MARK: - Reactive Methods Tests
    
    func testOnDebugMethod() {
        var wasExecuted = false
        
        // Test with debug environment
        let debugResult = RunEnvironment.debug.onDebug {
            wasExecuted = true
        }
        XCTAssertTrue(wasExecuted)
        XCTAssertEqual(debugResult, .debug)
        
        // Reset and test with non-debug environment
        wasExecuted = false
        let testFlightResult = RunEnvironment.testFlight.onDebug {
            wasExecuted = true
        }
        XCTAssertFalse(wasExecuted)
        XCTAssertEqual(testFlightResult, .testFlight)
    }
    
    func testOnDebugMethodWithParameter() {
        var receivedEnvironment: RunEnvironment?
        
        // Test with debug environment
        RunEnvironment.debug.onDebug { env in
            receivedEnvironment = env
        }
        XCTAssertEqual(receivedEnvironment, .debug)
        
        // Reset and test with non-debug environment
        receivedEnvironment = nil
        RunEnvironment.appStore.onDebug { env in
            receivedEnvironment = env
        }
        XCTAssertNil(receivedEnvironment)
    }
    
    func testOnTestFlightMethod() {
        var wasExecuted = false
        
        // Test with TestFlight environment
        let testFlightResult = RunEnvironment.testFlight.onTestFlight {
            wasExecuted = true
        }
        XCTAssertTrue(wasExecuted)
        XCTAssertEqual(testFlightResult, .testFlight)
        
        // Reset and test with non-TestFlight environment
        wasExecuted = false
        let debugResult = RunEnvironment.debug.onTestFlight {
            wasExecuted = true
        }
        XCTAssertFalse(wasExecuted)
        XCTAssertEqual(debugResult, .debug)
    }
    
    func testOnTestFlightMethodWithParameter() {
        var receivedEnvironment: RunEnvironment?
        
        // Test with TestFlight environment
        RunEnvironment.testFlight.onTestFlight { env in
            receivedEnvironment = env
        }
        XCTAssertEqual(receivedEnvironment, .testFlight)
        
        // Reset and test with non-TestFlight environment
        receivedEnvironment = nil
        RunEnvironment.debug.onTestFlight { env in
            receivedEnvironment = env
        }
        XCTAssertNil(receivedEnvironment)
    }
    
    func testOnAppStoreMethod() {
        var wasExecuted = false
        
        // Test with App Store environment
        let appStoreResult = RunEnvironment.appStore.onAppStore {
            wasExecuted = true
        }
        XCTAssertTrue(wasExecuted)
        XCTAssertEqual(appStoreResult, .appStore)
        
        // Reset and test with non-App Store environment
        wasExecuted = false
        let debugResult = RunEnvironment.debug.onAppStore {
            wasExecuted = true
        }
        XCTAssertFalse(wasExecuted)
        XCTAssertEqual(debugResult, .debug)
    }
    
    func testOnAppStoreMethodWithParameter() {
        var receivedEnvironment: RunEnvironment?
        
        // Test with App Store environment
        RunEnvironment.appStore.onAppStore { env in
            receivedEnvironment = env
        }
        XCTAssertEqual(receivedEnvironment, .appStore)
        
        // Reset and test with non-App Store environment
        receivedEnvironment = nil
        RunEnvironment.testFlight.onAppStore { env in
            receivedEnvironment = env
        }
        XCTAssertNil(receivedEnvironment)
    }
    
    func testOnReviewMethod() {
        var wasExecuted = false
        let environment = RunEnvironment.current
        
        let result = environment.onReview {
            wasExecuted = true
        }
        
        XCTAssertEqual(result, environment)
        XCTAssertEqual(wasExecuted, environment.underReview)
    }
    
    func testOnReviewMethodWithParameter() {
        var receivedEnvironment: RunEnvironment?
        let environment = RunEnvironment.current
        
        environment.onReview { env in
            receivedEnvironment = env
        }
        
        if environment.underReview {
            XCTAssertEqual(receivedEnvironment, environment)
        } else {
            XCTAssertNil(receivedEnvironment)
        }
    }
    
    func testChainedReactiveMethods() {
        var debugExecuted = false
        var testFlightExecuted = false
        var appStoreExecuted = false
        
        // Test chaining on debug environment
        let result = RunEnvironment.debug
            .onDebug { debugExecuted = true }
            .onTestFlight { testFlightExecuted = true }
            .onAppStore { appStoreExecuted = true }
        
        XCTAssertEqual(result, .debug)
        XCTAssertTrue(debugExecuted)
        XCTAssertFalse(testFlightExecuted)
        XCTAssertFalse(appStoreExecuted)
    }
    
    func testReactiveMethodsWithThrowingClosures() throws {
        enum TestError: Error {
            case testError
        }
        
        var wasExecuted = false
        
        // Test that throwing closures work correctly
        RunEnvironment.debug.onDebug {
            wasExecuted = true
            // Don't throw in this test
        }
        XCTAssertTrue(wasExecuted)
        
        // Test that errors are properly rethrown
        XCTAssertThrowsError(
            try RunEnvironment.debug.onDebug {
                throw TestError.testError
            }
        ) { error in
            XCTAssertTrue(error is TestError)
        }
    }
}
