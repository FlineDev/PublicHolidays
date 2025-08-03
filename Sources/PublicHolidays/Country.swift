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

      self.isoCode = try values.decode(String.self, forKey: .isoCode)
      self.publicHolidays = try values.decode([PublicHoliday].self, forKey: .publicHolidays)

      self.subTerritories = try values.decode([SubTerritory].self, forKey: .subTerritories)
      self.subTerritories.forEach { $0.country = self }
   }
}

extension Country: CustomStringConvertible {
   public var description: String {
      #"Country(isoCode: "\#(self.isoCode)", publicHolidays: \#(self.publicHolidays), subTerritories: \#(self.subTerritories))"#
   }
}

extension Country: Equatable {
   public static func == (lhs: Country, rhs: Country) -> Bool {
      lhs.isoCode == rhs.isoCode
   }
}
