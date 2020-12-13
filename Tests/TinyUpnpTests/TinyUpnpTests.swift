import XCTest
@testable import TinyUpnp

final class TinyUpnpTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(TinyUpnp().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
