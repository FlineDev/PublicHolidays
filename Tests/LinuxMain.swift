// Generated using Sourcery 1.0.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

@testable import PublicHolidaysTests
@testable import Utility
import XCTest

// swiftlint:disable line_length file_length

extension PublicHolidaysTests {
    static var allTests: [(String, (PublicHolidaysTests) -> () throws -> Void)] = [
        ("testAvailableCountries", testAvailableCountries),
        ("testAvailableSubTerritories", testAvailableSubTerritories),
        ("testPublicHolidays", testPublicHolidays)
    ]
}

XCTMain([
    testCase(PublicHolidaysTests.allTests)
])
