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
        // Просто проверяем, что current возвращает какое-то значение
        let current = RunEnvironment.current
        XCTAssertTrue(RunEnvironment.allCases.contains(current))
    }
    
    func testCurrentEnvironmentConsistency() {
        // Проверяем, что current возвращает одинаковое значение при повторных вызовах
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
        // Проверяем, что switch statement обрабатывает все случаи
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
}
