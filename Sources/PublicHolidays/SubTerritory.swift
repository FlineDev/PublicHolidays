import Foundation

public class SubTerritory: Codable {
   private enum CodingKeys: String, CodingKey {
      case isoCode, additionalPublicHolidays
   }

   /// The ISO code of the sub territory. Can be of length 2 or 3. Might also contain numbers.
   public let isoCode: String

   /// Additional public holidays for the sub territory on top of the ones for the country.
   public let additionalPublicHolidays: [PublicHoliday]

   var country: Country?

   var fullIsoCode: String {
      "\(self.country!.isoCode)-\(self.isoCode)"
   }

   var allPublicHolidays: [PublicHoliday] {
      (self.country!.publicHolidays + self.additionalPublicHolidays).sorted { $0.date < $1.date }
   }

   /// Initializes a new sub territory.
   public init(
      isoCode: String,
      additionalPublicHolidays: [PublicHoliday]
   ) {
      self.isoCode = isoCode
      self.additionalPublicHolidays = additionalPublicHolidays
   }
}

extension SubTerritory: CustomStringConvertible {
   /// The printable description of the sub territory.
   public var description: String {
      #"SubTerritory(isoCode: "\#(self.isoCode)", additionalPublicHolidays: \#(self.additionalPublicHolidays), country: \#(self.country?.description ?? "nil"))"#
   }
}

extension SubTerritory: Equatable {
   public static func == (lhs: SubTerritory, rhs: SubTerritory) -> Bool {
      lhs.country == rhs.country && lhs.isoCode == rhs.isoCode
   }
}
