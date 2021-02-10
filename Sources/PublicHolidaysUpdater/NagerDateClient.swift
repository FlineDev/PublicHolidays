import Foundation
import Microya

/// Client for the API at https://date.nager.at/swagger/index.html
enum NagerDateClient {
  case publicHolidays(year: Int, countryCode: String)
  case availableCountries
}

struct NagerError: Decodable {
  let code: Int
  let message: String
}

extension NagerDateClient: Endpoint {
  typealias ClientErrorType = NagerError

  var decoder: JSONDecoder {
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .formatted(DateFormatter.dateOnlyGMT)
    return decoder
  }

  var baseUrl: URL {
    URL(string: "https://date.nager.at/Api/v2")!
  }

  var subpath: String {
    switch self {
    case let .publicHolidays(year, countryCode):
      return "/PublicHolidays/\(year)/\(countryCode)"

    case .availableCountries:
      return "/AvailableCountries"
    }
  }

  var method: HttpMethod {
    switch self {
    case .publicHolidays, .availableCountries:
      return .get
    }
  }
}
