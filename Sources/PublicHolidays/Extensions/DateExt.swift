import Foundation

extension Date {
   func year(timeZone: TimeZone = Calendar.current.timeZone) -> Int {
      var calendar = Calendar(identifier: .gregorian)
      calendar.timeZone = timeZone
      return calendar.dateComponents([.year], from: self).year!
   }
}
