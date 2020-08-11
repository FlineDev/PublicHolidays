import Foundation

public struct SubTerritory: Codable {
    public let localName: String
    public let isoCode: String
    public let country: Country
    public let additionalPublicHolidays: [PublicHoliday]

    var fullIsoCode: String {
        "\(country.isoCode)-\(isoCode)"
    }

    var allPublicHolidays: [PublicHoliday] {
        (country.publicHolidays + additionalPublicHolidays).sorted { $0.date < $1.date }
    }
}
