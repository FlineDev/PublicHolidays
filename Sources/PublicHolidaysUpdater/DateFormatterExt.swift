import Foundation

extension DateFormatter {
    static var dateOnly: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = TimeZone(identifier: "GMT")
        return dateFormatter
    }
}
