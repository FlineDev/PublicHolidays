import Foundation

struct PublicHolidayResponse: Decodable {
    let date: Date
    let localName: String
    let countryCode: String
    let counties: [String]?
}
