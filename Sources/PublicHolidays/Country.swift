import Foundation

public class Country: Codable {
   public let isoCode: String
   public let publicHolidays: [PublicHoliday]
   public let subTerritories: [SubTerritory]

   public init(
      isoCode: String,
      publicHolidays: [PublicHoliday],
      subTerritories: [SubTerritory]
   ) {
      self.isoCode = isoCode
      self.publicHolidays = publicHolidays
      self.subTerritories = subTerritories
      subTerritories.forEach { $0.country = self }
   }

   public required init(
      from decoder: Decoder
   ) throws {
      let values = try decoder.container(keyedBy: CodingKeys.self)

      isoCode = try values.decode(String.self, forKey: .isoCode)
      publicHolidays = try values.decode([PublicHoliday].self, forKey: .publicHolidays)

      subTerritories = try values.decode([SubTerritory].self, forKey: .subTerritories)
      subTerritories.forEach { $0.country = self }
   }
}

extension Country: CustomStringConvertible {
   public var description: String {
      #"Country(isoCode: "\#(isoCode)", publicHolidays: \#(publicHolidays), subTerritories: \#(subTerritories))"#
   }
}

extension Country: Equatable {
   public static func == (lhs: Country, rhs: Country) -> Bool {
      lhs.isoCode == rhs.isoCode
   }
}
