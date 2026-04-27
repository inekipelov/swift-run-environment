import Testing
@testable import RunEnvironment

@Suite("RunEnvironment Reactive")
struct RunEnvironmentReactiveTests {
    @Test("onDebug executes only for debug")
    func onDebugMethod() {
        var wasExecuted = false
        let debugResult = RunEnvironment.debug.onDebug {
            wasExecuted = true
        }
        #expect(wasExecuted)
        #expect(debugResult == .debug)

        wasExecuted = false
        let testFlightResult = RunEnvironment.testFlight.onDebug {
            wasExecuted = true
        }
        #expect(!wasExecuted)
        #expect(testFlightResult == .testFlight)
    }

    @Test("onDebug with parameter")
    func onDebugMethodWithParameter() {
        var receivedEnvironment: RunEnvironment?

        RunEnvironment.debug.onDebug { env in
            receivedEnvironment = env
        }
        #expect(receivedEnvironment == .debug)

        receivedEnvironment = nil
        RunEnvironment.appStore.onDebug { env in
            receivedEnvironment = env
        }
        #expect(receivedEnvironment == nil)
    }

    @Test("onTestFlight executes only for TestFlight")
    func onTestFlightMethod() {
        var wasExecuted = false

        let testFlightResult = RunEnvironment.testFlight.onTestFlight {
            wasExecuted = true
        }
        #expect(wasExecuted)
        #expect(testFlightResult == .testFlight)

        wasExecuted = false
        let debugResult = RunEnvironment.debug.onTestFlight {
            wasExecuted = true
        }
        #expect(!wasExecuted)
        #expect(debugResult == .debug)
    }

    @Test("onTestFlight with parameter")
    func onTestFlightMethodWithParameter() {
        var receivedEnvironment: RunEnvironment?

        RunEnvironment.testFlight.onTestFlight { env in
            receivedEnvironment = env
        }
        #expect(receivedEnvironment == .testFlight)

        receivedEnvironment = nil
        RunEnvironment.debug.onTestFlight { env in
            receivedEnvironment = env
        }
        #expect(receivedEnvironment == nil)
    }

    @Test("onAppStore executes only for App Store")
    func onAppStoreMethod() {
        var wasExecuted = false

        let appStoreResult = RunEnvironment.appStore.onAppStore {
            wasExecuted = true
        }
        #expect(wasExecuted)
        #expect(appStoreResult == .appStore)

        wasExecuted = false
        let debugResult = RunEnvironment.debug.onAppStore {
            wasExecuted = true
        }
        #expect(!wasExecuted)
        #expect(debugResult == .debug)
    }

    @Test("onAppStore with parameter")
    func onAppStoreMethodWithParameter() {
        var receivedEnvironment: RunEnvironment?

        RunEnvironment.appStore.onAppStore { env in
            receivedEnvironment = env
        }
        #expect(receivedEnvironment == .appStore)

        receivedEnvironment = nil
        RunEnvironment.testFlight.onAppStore { env in
            receivedEnvironment = env
        }
        #expect(receivedEnvironment == nil)
    }

    @Test("Reactive methods can chain")
    func chainedReactiveMethods() {
        var debugExecuted = false
        var testFlightExecuted = false
        var appStoreExecuted = false

        let result = RunEnvironment.debug
            .onDebug { debugExecuted = true }
            .onTestFlight { testFlightExecuted = true }
            .onAppStore { appStoreExecuted = true }

        #expect(result == .debug)
        #expect(debugExecuted)
        #expect(!testFlightExecuted)
        #expect(!appStoreExecuted)
    }

    @Test("Reactive methods rethrow errors")
    func reactiveMethodsWithThrowingClosures() {
        enum TestError: Error {
            case testError
        }

        var wasExecuted = false

        RunEnvironment.debug.onDebug {
            wasExecuted = true
        }
        #expect(wasExecuted)

        #expect(throws: TestError.self) {
            try RunEnvironment.debug.onDebug {
                throw TestError.testError
            }
        }
    }
}
