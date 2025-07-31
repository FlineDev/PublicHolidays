import Difference
import XCTest

func XCTAssertEqual<T: Equatable>(_ received: T, _ expected: T, file: StaticString = #filePath, line: UInt = #line) {
   XCTAssertTrue(
      expected == received,
      "Found difference for \n" + diff(expected, received).joined(separator: ", "),
      file: file,
      line: line
   )
}
