import Foundation

public class SubTerritory: Codable, CustomStringConvertible {
    private enum CodingKeys: String, CodingKey {
        case isoCode, additionalPublicHolidays
    }

    public let isoCode: String
    public let additionalPublicHolidays: [PublicHoliday]

    var country: Country?

    public init(isoCode: String, additionalPublicHolidays: [PublicHoliday]) {
        self.isoCode = isoCode
        self.additionalPublicHolidays = additionalPublicHolidays
    }

    var fullIsoCode: String {
        "\(country!.isoCode)-\(isoCode)"
    }

    var allPublicHolidays: [PublicHoliday] {
        (country!.publicHolidays + additionalPublicHolidays).sorted { $0.date < $1.date }
    }

    public var description: String {
        "isoCode: \(isoCode), additionalPublicHolidays: \(additionalPublicHolidays), country: \(String(describing: country))"
    }
}
