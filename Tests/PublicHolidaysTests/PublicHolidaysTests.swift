@testable import PublicHolidays
import XCTest

class PublicHolidaysTests: XCTestCase {
  func testAvailableCountries() {
    XCTAssertEqual(
      [
        "AD", "AL", "AR", "AT", "AU", "AX", "BB", "BE", "BG", "BJ", "BO", "BR", "BS", "BW", "BY", "BZ", "CA", "CH",
        "CL", "CN", "CO", "CR", "CU", "CY", "CZ", "DE", "DK", "DO", "EC", "EE", "EG", "ES", "FI", "FO", "FR", "GA",
        "GB", "GD", "GL", "GM", "GR", "GT", "GY", "HN", "HR", "HT", "HU", "ID", "IE", "IM", "IS", "IT", "JE", "JM",
        "JP", "LI", "LS", "LT", "LU", "LV", "MA", "MC", "MD", "MG", "MK", "MN", "MT", "MX", "MZ", "NA", "NE", "NI",
        "NL", "NO", "NZ", "PA", "PE", "PL", "PR", "PT", "PY", "RO", "RS", "RU", "SE", "SI", "SJ", "SK", "SM", "SR",
        "SV", "TN", "TR", "UA", "US", "UY", "VA", "VE", "VN", "ZA", "ZW",
      ],
      PublicHolidays.availableCountries()
    )
  }

  func testAvailableSubTerritories() throws {
    XCTAssertEqual(
      [
        "AL", "AZ", "CO", "CT", "DC", "GA", "IA", "ID", "IL", "IN", "KS", "KY", "LA", "MA", "MD", "ME", "MO", "MS",
        "MT", "NC", "NE", "NH", "NJ", "NM", "NY", "OH", "OK", "PA", "RI", "SC", "TN", "UT", "VA", "WV",
      ],
      try PublicHolidays.availableSubTerritories(countryCode: "US")
    )

    XCTAssertEqual(
      ["BB", "BE", "BW", "BY", "HB", "HE", "HH", "MV", "NI", "NW", "RP", "SH", "SL", "SN", "ST", "TH"],
      try PublicHolidays.availableSubTerritories(countryCode: "DE")
    )

    XCTAssertEqual(
      ["ACT", "NSW", "NT", "QLD", "SA", "TAS", "VIC", "WA"],
      try PublicHolidays.availableSubTerritories(countryCode: "AU")
    )

    XCTAssertEqual(
      ["ENG", "NIR", "SCT", "WLS"],
      try PublicHolidays.availableSubTerritories(countryCode: "GB")
    )

    XCTAssertEqual(
      ["57", "A", "BL", "GP", "MF", "MQ"],
      try PublicHolidays.availableSubTerritories(countryCode: "FR")
    )

    XCTAssertEqual(
      [],
      try PublicHolidays.availableSubTerritories(countryCode: "JP")
    )

    XCTAssertThrowsError(try PublicHolidays.availableSubTerritories(countryCode: "ZZ"))
  }

  func testAll() throws {
    XCTAssertEqual(
      [
        PublicHoliday(localName: "Neujahr", date: "2020-01-01"),
        PublicHoliday(localName: "Karfreitag", date: "2020-04-10"),
        PublicHoliday(localName: "Ostermontag", date: "2020-04-13"),
        PublicHoliday(localName: "Tag der Arbeit", date: "2020-05-01"),
        PublicHoliday(localName: "Christi Himmelfahrt", date: "2020-05-21"),
        PublicHoliday(localName: "Pfingstmontag", date: "2020-06-01"),
        PublicHoliday(localName: "Tag der Deutschen Einheit", date: "2020-10-03"),
        PublicHoliday(localName: "Erster Weihnachtstag", date: "2020-12-25"),
        PublicHoliday(localName: "Zweiter Weihnachtstag", date: "2020-12-26"),
      ],
      try PublicHolidays.all(countryCode: "DE").filter { $0.date.year() == 2020 }
    )

    XCTAssertEqual(
      [
        PublicHoliday(localName: "Neujahr", date: "2020-01-01"),
        PublicHoliday(localName: "Heilige Drei Könige", date: "2020-01-06"),
        PublicHoliday(localName: "Internationaler Frauentag", date: "2020-03-08"),
        PublicHoliday(localName: "Karfreitag", date: "2020-04-10"),
        PublicHoliday(localName: "Ostermontag", date: "2020-04-13"),
        PublicHoliday(localName: "Tag der Arbeit", date: "2020-05-01"),
        PublicHoliday(localName: "Tag der Befreiung", date: "2020-05-08"),
        PublicHoliday(localName: "Christi Himmelfahrt", date: "2020-05-21"),
        PublicHoliday(localName: "Pfingstmontag", date: "2020-06-01"),
        PublicHoliday(localName: "Fronleichnam", date: "2020-06-11"),
        PublicHoliday(localName: "Mariä Himmelfahrt", date: "2020-08-15"),
        PublicHoliday(localName: "Weltkindertag", date: "2020-09-20"),
        PublicHoliday(localName: "Tag der Deutschen Einheit", date: "2020-10-03"),
        PublicHoliday(localName: "Reformationstag", date: "2020-10-31"),
        PublicHoliday(localName: "Allerheiligen", date: "2020-11-01"),
        PublicHoliday(localName: "Buß- und Bettag", date: "2020-11-18"),
        PublicHoliday(localName: "Erster Weihnachtstag", date: "2020-12-25"),
        PublicHoliday(localName: "Zweiter Weihnachtstag", date: "2020-12-26"),
      ],
      try PublicHolidays.all(countryCode: "DE", subTerritoryCode: "BW").filter { $0.date.year() == 2020 }
    )

    XCTAssertThrowsError(try PublicHolidays.all(countryCode: "ZZ"))
    XCTAssertThrowsError(try PublicHolidays.all(countryCode: "DE", subTerritoryCode: "ZZ"))
  }

  func testContains() throws {
    let gmtPlusOne = TimeZone(secondsFromGMT: Int(TimeInterval.hours(1).seconds))!
    let gmtPlusFiveAndAHalf = TimeZone(secondsFromGMT: Int(TimeInterval.hours(5.5).seconds))!
    let gmtMinusSix = TimeZone(secondsFromGMT: Int(TimeInterval.hours(-6).seconds))!

    XCTAssertTrue(
      try PublicHolidays.contains(date: "2020-10-03T00:00:00-06:00", countryCode: "DE", timeZone: gmtPlusOne)
    )
    XCTAssertTrue(try PublicHolidays.contains(date: "2020-10-03T00:00:00Z", countryCode: "DE", timeZone: gmtPlusOne))
    XCTAssertTrue(
      try PublicHolidays.contains(date: "2020-10-03T00:00:00+01:00", countryCode: "DE", timeZone: gmtPlusOne)
    )
    XCTAssertFalse(
      try PublicHolidays.contains(date: "2020-10-03T00:00:00+05:30", countryCode: "DE", timeZone: gmtPlusOne)
    )

    XCTAssertFalse(
      try PublicHolidays.contains(date: "2020-10-03T23:59:59-06:00", countryCode: "DE", timeZone: gmtPlusOne)
    )
    XCTAssertFalse(try PublicHolidays.contains(date: "2020-10-03T23:59:59Z", countryCode: "DE", timeZone: gmtPlusOne))
    XCTAssertTrue(
      try PublicHolidays.contains(date: "2020-10-03T23:59:59+01:00", countryCode: "DE", timeZone: gmtPlusOne)
    )
    XCTAssertTrue(
      try PublicHolidays.contains(date: "2020-10-03T23:59:59+05:30", countryCode: "DE", timeZone: gmtPlusOne)
    )

    XCTAssertTrue(
      try PublicHolidays.contains(date: "2020-10-03T00:00:00-06:00", countryCode: "DE", timeZone: gmtPlusFiveAndAHalf)
    )
    XCTAssertTrue(
      try PublicHolidays.contains(date: "2020-10-03T00:00:00Z", countryCode: "DE", timeZone: gmtPlusFiveAndAHalf)
    )
    XCTAssertTrue(
      try PublicHolidays.contains(date: "2020-10-03T00:00:00+01:00", countryCode: "DE", timeZone: gmtPlusFiveAndAHalf)
    )
    XCTAssertTrue(
      try PublicHolidays.contains(date: "2020-10-03T00:00:00+05:30", countryCode: "DE", timeZone: gmtPlusFiveAndAHalf)
    )

    XCTAssertFalse(
      try PublicHolidays.contains(date: "2020-10-03T23:59:59-06:00", countryCode: "DE", timeZone: gmtPlusFiveAndAHalf)
    )
    XCTAssertFalse(
      try PublicHolidays.contains(date: "2020-10-03T23:59:59Z", countryCode: "DE", timeZone: gmtPlusFiveAndAHalf)
    )
    XCTAssertFalse(
      try PublicHolidays.contains(date: "2020-10-03T23:59:59+01:00", countryCode: "DE", timeZone: gmtPlusFiveAndAHalf)
    )
    XCTAssertTrue(
      try PublicHolidays.contains(date: "2020-10-03T23:59:59+05:30", countryCode: "DE", timeZone: gmtPlusFiveAndAHalf)
    )

    XCTAssertTrue(
      try PublicHolidays.contains(date: "2020-10-03T00:00:00-06:00", countryCode: "DE", timeZone: gmtMinusSix)
    )
    XCTAssertFalse(try PublicHolidays.contains(date: "2020-10-03T00:00:00Z", countryCode: "DE", timeZone: gmtMinusSix))
    XCTAssertFalse(
      try PublicHolidays.contains(date: "2020-10-03T00:00:00+01:00", countryCode: "DE", timeZone: gmtMinusSix)
    )
    XCTAssertFalse(
      try PublicHolidays.contains(date: "2020-10-03T00:00:00+05:30", countryCode: "DE", timeZone: gmtMinusSix)
    )

    XCTAssertTrue(
      try PublicHolidays.contains(date: "2020-10-03T23:59:59-06:00", countryCode: "DE", timeZone: gmtMinusSix)
    )
    XCTAssertTrue(try PublicHolidays.contains(date: "2020-10-03T23:59:59Z", countryCode: "DE", timeZone: gmtMinusSix))
    XCTAssertTrue(
      try PublicHolidays.contains(date: "2020-10-03T23:59:59+01:00", countryCode: "DE", timeZone: gmtMinusSix)
    )
    XCTAssertTrue(
      try PublicHolidays.contains(date: "2020-10-03T23:59:59+05:30", countryCode: "DE", timeZone: gmtMinusSix)
    )

    XCTAssertThrowsError(
      try PublicHolidays.contains(date: "2019-12-31T23:59:59+01:00", countryCode: "DE", timeZone: gmtPlusOne)
    )
    XCTAssertThrowsError(
      try PublicHolidays.contains(date: "2019-12-31T23:59:59+05:30", countryCode: "DE", timeZone: gmtPlusFiveAndAHalf)
    )
    XCTAssertThrowsError(
      try PublicHolidays.contains(date: "2019-12-31T23:59:59-06:00", countryCode: "DE", timeZone: gmtMinusSix)
    )

    XCTAssertNoThrow(
      try PublicHolidays.contains(date: "2020-01-01T00:00:00+01:00", countryCode: "DE", timeZone: gmtPlusOne)
    )
    XCTAssertNoThrow(
      try PublicHolidays.contains(date: "2020-01-01T00:00:00+05:30", countryCode: "DE", timeZone: gmtPlusFiveAndAHalf)
    )
    XCTAssertNoThrow(
      try PublicHolidays.contains(date: "2020-01-01T00:00:00-06:00", countryCode: "DE", timeZone: gmtMinusSix)
    )

    XCTAssertNoThrow(
      try PublicHolidays.contains(date: "2029-12-31T23:59:59+01:00", countryCode: "DE", timeZone: gmtPlusOne)
    )
    XCTAssertNoThrow(
      try PublicHolidays.contains(date: "2029-12-31T23:59:59+05:30", countryCode: "DE", timeZone: gmtPlusFiveAndAHalf)
    )
    XCTAssertNoThrow(
      try PublicHolidays.contains(date: "2029-12-31T23:59:59-06:00", countryCode: "DE", timeZone: gmtMinusSix)
    )

    XCTAssertThrowsError(
      try PublicHolidays.contains(date: "2030-01-01T00:00:00+01:00", countryCode: "DE", timeZone: gmtPlusOne)
    )
    XCTAssertThrowsError(
      try PublicHolidays.contains(date: "2030-01-01T00:00:00+05:30", countryCode: "DE", timeZone: gmtPlusFiveAndAHalf)
    )
    XCTAssertThrowsError(
      try PublicHolidays.contains(date: "2030-01-01T00:00:00-06:00", countryCode: "DE", timeZone: gmtMinusSix)
    )
  }
}

extension Date: ExpressibleByStringLiteral {
  public init(
    stringLiteral value: String
  ) {
    switch value.count {
    case 10:
      self = DateFormatter.dateOnly(timeZone: Calendar.current.timeZone).date(from: value)!

    default:
      self = ISO8601DateFormatter().date(from: value)!
    }
  }
}
