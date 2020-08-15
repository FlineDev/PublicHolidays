import Foundation

extension DateFormatter {
    /// Returns a date formatter with GMT timezone which only formats the day, dropping the time.
    public static var dateOnly: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = TimeZone(identifier: "GMT")
        return dateFormatter
    }
}
