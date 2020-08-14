import Foundation

public class Country: Codable, CustomStringConvertible {
    public let isoCode: String
    public let publicHolidays: [PublicHoliday]
    public let subTerritories: [SubTerritory]

    public init(isoCode: String, subTerritories: [SubTerritory], publicHolidays: [PublicHoliday]) {
        self.isoCode = isoCode
        self.publicHolidays = publicHolidays
        self.subTerritories = subTerritories
        subTerritories.forEach { $0.country = self }
    }

    public var description: String {
        "isoCode: \(isoCode), publicHolidays: \(publicHolidays), subTerritories: \(subTerritories)"
    }
}
