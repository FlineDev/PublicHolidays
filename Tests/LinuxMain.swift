// Generated using Sourcery 1.0.3 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

import XCTest

@testable import PublicHolidaysTests

extension PublicHolidaysTests {
   static var allTests: [(String, (PublicHolidaysTests) -> () throws -> Void)] = [
      ("testAvailableCountries", testAvailableCountries),
      ("testAvailableSubTerritories", testAvailableSubTerritories),
      ("testAll", testAll),
      ("testContains", testContains),
   ]
}

XCTMain([
   testCase(PublicHolidaysTests.allTests)
])
