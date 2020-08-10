import Foundation
import Microya

/// Client for the API at https://date.nager.at/swagger/index.html
enum NagerDateClient {
    case publicHolidays(year: Int, countryCode: String)
}

extension NagerDateClient: JsonApi {
    var baseUrl: URL {
        URL(string: "https://date.nager.at/Api/v2")!
    }

    var path: String {
        switch self {
        case let .publicHolidays(year, countryCode):
            return "/PublicHolidays/\(year)/\(countryCode)"
        }
    }

    var method: Microya.Method {
        switch self {
        case .publicHolidays:
            return .get
        }
    }
}
