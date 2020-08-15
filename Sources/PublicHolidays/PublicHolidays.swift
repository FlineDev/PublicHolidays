import Foundation

enum PublicHolidaysError: Error {
    case unavailableCountryCode(String)
    case unavailableSubTerritoryCode(String)
}

/// The main API to use for fetching public holiday.
public enum PublicHolidays {
    private static var jsonDataDirUrl = URL(fileURLWithPath: Bundle.module.resourcePath!).appendingPathComponent("JsonData")

    private static var jsonDecoder: JSONDecoder = {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .formatted(DateFormatter.dateOnly)
        return jsonDecoder
    }()

    /// Returns the ISO codes of all countries that have available public holildays data.
    /// - NOTE:Even if this responds with a non-empty list of sub territories, the list is not guaranteed to be complete.
    public static func availableCountries() throws -> [String] {
        try FileManager.default.contentsOfDirectory(atPath: jsonDataDirUrl.path)
            .map { URL(fileURLWithPath: $0).deletingPathExtension().lastPathComponent }
            .sorted()
    }

    /// Returns a list of ISO sub territory codes (2/3 numbers/characters) for the given country code.
    public static func availableSubTerritories(countryCode: String) throws -> [String] {
        try loadCountry(countryCode: countryCode).subTerritories.map { $0.isoCode }
    }

    /// Returns a sorted list of all public holidays for the given country or sub territory (optional).
    public static func publicHolidays(countryCode: String, subTerritoryCode: String? = nil) throws -> [PublicHoliday] {
        let country = try loadCountry(countryCode: countryCode)

        if let subTerritoryCode = subTerritoryCode {
            guard let subTerritory = country.subTerritories.first(where: { $0.isoCode == subTerritoryCode }) else {
                throw PublicHolidaysError.unavailableSubTerritoryCode(subTerritoryCode)
            }

            return subTerritory.allPublicHolidays
        } else {
            return country.publicHolidays
        }
    }

    private static func loadCountry(countryCode: String) throws -> Country {
        guard let countryData = FileManager.default.contents(atPath: jsonDataDirUrl.appendingPathComponent("\(countryCode).json").path) else {
            throw PublicHolidaysError.unavailableCountryCode(countryCode)
        }

        return try jsonDecoder.decode(Country.self, from: countryData)
    }
}
