import XCTest
import CPlusPlusLibrary
import gha_setup_swift

final class gha_setup_swiftTests: XCTestCase {
  func test() throws {
    XCTAssertEqual(forty_two(), 42)
    XCTAssertEqual(fortyTwo(), 42)
  }
}
