// Generated using Sourcery 1.0.3 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

@testable import PublicHolidaysTests
import XCTest

// swiftlint:disable line_length file_length

extension PublicHolidaysTests {
    static var allTests: [(String, (PublicHolidaysTests) -> () throws -> Void)] = [
        ("testAvailableCountries", testAvailableCountries),
        ("testAvailableSubTerritories", testAvailableSubTerritories),
        ("testAll", testAll),
        ("testContains", testContains)
    ]
}

XCTMain([
    testCase(PublicHolidaysTests.allTests)
])
