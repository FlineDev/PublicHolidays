import Foundation

public class PublicHoliday: Codable, CustomStringConvertible {
    public let localName: String
    public let date: Date

    public init(localName: String, date: Date) {
        self.localName = localName
        self.date = date
    }

    public var description: String {
        "localName: \(localName), date: \(date)"
    }
}
