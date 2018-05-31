import XCTest
@testable import AsyncCache

final class AsyncCacheTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(AsyncCache().text, "Hello, World!")
    }


    static var allTests = [
        ("testExample", testExample),
    ]
}
