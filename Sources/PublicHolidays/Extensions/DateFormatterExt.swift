import Foundation

extension DateFormatter {
    /// Returns a date formatter which only formats the day, dropping the time.
    static func dateOnly(timeZone: TimeZone) -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = timeZone
        return dateFormatter
    }
}
