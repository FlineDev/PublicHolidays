import Foundation
import HandySwift

enum PublicHolidaysError: Error {
   case unavailableCountryCode(String)
   case unavailableSubTerritoryCode(String)
   case dateOutsideOfSupportedRange
}

/// The main API to use for fetching public holiday.
public enum PublicHolidays {
   /// The gregorian calendar years supported with public holidays data.
   public static let supportedYears: ClosedRange<Int> = 2020...2029

   private static var jsonDataDirUrl = URL(fileURLWithPath: Bundle.module.resourcePath!)
      .appendingPathComponent("JsonData")

   /// Returns the ISO codes of all countries that have available public holildays data.
   /// - NOTE:Even if this responds with a non-empty list of sub territories, the list is not guaranteed to be complete.
   public static func availableCountries() -> [String] {
      try! FileManager.default.contentsOfDirectory(atPath: jsonDataDirUrl.path)
         .map { URL(fileURLWithPath: $0).deletingPathExtension().lastPathComponent }
         .sorted()
   }

   /// Returns a list of ISO sub territory codes (2/3 numbers/characters) for the given country code.
   public static func availableSubTerritories(countryCode: String) throws -> [String] {
      try loadCountry(countryCode: countryCode, timeZone: Calendar.current.timeZone).subTerritories.map { $0.isoCode }
   }

   /// Returns a sorted list of all public holidays for the given country or sub territory (optional).
   /// - NOTE: Always uses current calendars time zone.
   public static func all(
      countryCode: String,
      subTerritoryCode: String? = nil,
      timeZone: TimeZone = Calendar.current.timeZone
   ) throws -> [PublicHoliday] {
      let country = try loadCountry(countryCode: countryCode, timeZone: timeZone)

      if let subTerritoryCode = subTerritoryCode {
         guard let subTerritory = country.subTerritories.first(where: { $0.isoCode == subTerritoryCode }) else {
            throw PublicHolidaysError.unavailableSubTerritoryCode(subTerritoryCode)
         }

         return subTerritory.allPublicHolidays
      } else {
         return country.publicHolidays
      }
   }

   /// Returns `true` if the given date is on a public holiday for the given country (and sub territory).
   /// - NOTE: Always uses current calendars time zone. u
   public static func contains(
      date: Date,
      countryCode: String,
      subTerritoryCode: String? = nil,
      timeZone: TimeZone = Calendar.current.timeZone
   ) throws -> Bool {
      guard supportedYears.contains(date.year(timeZone: timeZone)) else {
         throw PublicHolidaysError.dateOutsideOfSupportedRange
      }
      let publicHolidaysAtLocation = try all(
         countryCode: countryCode,
         subTerritoryCode: subTerritoryCode,
         timeZone: timeZone
      )

      guard
         let firstPublicHolidayEndingAfterDate = publicHolidaysAtLocation.first(where: {
            $0.date.addingTimeInterval(.days(1)) > date
         })
      else {
         return false
      }
      return firstPublicHolidayEndingAfterDate.date <= date
   }

   private static func loadCountry(countryCode: String, timeZone: TimeZone) throws -> Country {
      guard
         let countryData = FileManager.default.contents(
            atPath: jsonDataDirUrl.appendingPathComponent("\(countryCode).json").path
         )
      else {
         throw PublicHolidaysError.unavailableCountryCode(countryCode)
      }

      return try jsonDecoder(timeZone: timeZone).decode(Country.self, from: countryData)
   }

   private static func jsonDecoder(timeZone: TimeZone) -> JSONDecoder {
      let jsonDecoder = JSONDecoder()
      jsonDecoder.dateDecodingStrategy = .formatted(DateFormatter.dateOnly(timeZone: timeZone))
      return jsonDecoder
   }
}
