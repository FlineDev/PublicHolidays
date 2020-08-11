import Foundation

public struct Country: Codable {
    public let localName: String
    public let isoCode: String
    public let subTerritories: [SubTerritory]
    public let publicHolidays: [PublicHoliday]
}
