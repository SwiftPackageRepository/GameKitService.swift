import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(GameKitService_swiftTests.allTests),
    ]
}
#endif
