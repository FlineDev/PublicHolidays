import Foundation

/// A public holiday.
public class PublicHoliday: Codable {
    /// The localized name of the public holiday.
    public let localName: String

    /// The date of the public holiday.
    public let date: Date

    /// Initializes a new public holiday.
    public init(localName: String, date: Date) {
        self.localName = localName
        self.date = date
    }
}

extension PublicHoliday: CustomStringConvertible {
    /// The printable description of the public holiday.
    public var description: String {
        #"PublicHoliday(localName: "\#(localName)", date: "\#(DateFormatter.dateOnly.string(from: date))")"#
    }
}

extension PublicHoliday: Equatable {
    public static func == (lhs: PublicHoliday, rhs: PublicHoliday) -> Bool {
        lhs.date == rhs.date && lhs.localName == rhs.localName
    }
}
