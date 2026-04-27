import Testing
@testable import RunEnvironment

@Suite("RunEnvironment Review")
struct RunEnvironmentReviewTests {
    @Test("Pattern matching with underReview key path")
    func reviewPatternMatching() {
        let environments: [RunEnvironment] = [.debug, .testFlight, .appStore]

        for environment in environments {
            switch environment {
            case let value where \.underReview ~= value:
                #expect(environment.underReview)
            case \.underReview:
                #expect(environment.underReview)
            default:
                #expect(!environment.underReview)
            }
        }
    }

    @Test("Pattern matching with where clause")
    func reviewPatternWithWhereClause() {
        let environments: [RunEnvironment] = [.debug, .testFlight, .appStore]

        for environment in environments {
            var matchedSpecificCase = false

            switch environment {
            case .debug where \.underReview ~= environment:
                matchedSpecificCase = true
                #expect(environment == .debug)
                #expect(environment.underReview)
            case .testFlight where \.underReview ~= environment:
                matchedSpecificCase = true
                #expect(environment == .testFlight)
                #expect(environment.underReview)
            case .appStore where \.underReview ~= environment:
                matchedSpecificCase = true
                #expect(environment == .appStore)
                #expect(environment.underReview)
            default:
                break
            }

            if matchedSpecificCase {
                #expect(environment.underReview)
            }
        }
    }

    @Test("onReview executes conditionally")
    func onReviewMethod() {
        var wasExecuted = false
        let environment = RunEnvironment.current

        let result = environment.onReview {
            wasExecuted = true
        }

        #expect(result == environment)
        #expect(wasExecuted == environment.underReview)
    }

    @Test("onReview with parameter")
    func onReviewMethodWithParameter() {
        var receivedEnvironment: RunEnvironment?
        let environment = RunEnvironment.current

        environment.onReview { env in
            receivedEnvironment = env
        }

        if environment.underReview {
            #expect(receivedEnvironment == environment)
        } else {
            #expect(receivedEnvironment == nil)
        }
    }
}
