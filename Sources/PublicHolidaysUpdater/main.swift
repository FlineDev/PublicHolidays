import ArgumentParser
import Foundation
import PublicHolidays

struct Import: ParsableCommand {
    private static let yearsToFetch: ClosedRange<Int> = 2020...2025

    @Option(name: .shortAndLong, help: "Provide the path to the countries JSON data files directory.")
    var countriesFilePath: String

    func run() throws { // swiftlint:disable:this function_body_length
        print("Fetching list of all available countries")
        let availableCountryResponses = try NagerDateClient.availableCountries.request(type: [AvailableCountryResponse].self).get()

        for availableCountry in availableCountryResponses {
            print("Fetching public holidays for years \(Import.yearsToFetch) in '\(availableCountry.key)'")
            let publicHolidayResponses: [PublicHolidayResponse] = try Import.yearsToFetch.reduce(into: []) { responses, yearToFetch in
                let responsesOfYearToFetch: [PublicHolidayResponse] = try NagerDateClient.publicHolidays(
                    year: yearToFetch,
                    countryCode: availableCountry.key
                ).request(type: [PublicHolidayResponse].self).get()

                return responses.append(contentsOf: responsesOfYearToFetch)
            }

            let countrywidePublicHolidayResponses: [PublicHolidayResponse] = publicHolidayResponses.filter { $0.counties == nil || $0.counties!.isEmpty }
            let countrywidePublicHolidays = countrywidePublicHolidayResponses.map { PublicHoliday(localName: $0.localName, date: $0.date) }

            let territorialPublicHolidayResponses: [PublicHolidayResponse] = publicHolidayResponses.filter { $0.counties != nil && !$0.counties!.isEmpty }

            var subTerritoryCodes: Set<String> = []
            for response in publicHolidayResponses {
                if let countyCodes = response.counties {
                    countyCodes.forEach { subTerritoryCodes.insert(String($0.split(separator: "-").last!)) }
                }
            }

            let subTerritories: [SubTerritory] = subTerritoryCodes.sorted().map {
                let additionalPublicHolidays = territorialPublicHolidayResponses
                    .filter { $0.counties!.contains { $0.hasSuffix($0) } }
                    .map { PublicHoliday(localName: $0.localName, date: $0.date) }
                return SubTerritory(isoCode: $0, additionalPublicHolidays: additionalPublicHolidays)
            }

            print("Downloaded public holidays for country '\(availableCountry.key)'")
            let country = Country(
                isoCode: availableCountry.key,
                publicHolidays: countrywidePublicHolidays,
                subTerritories: subTerritories
            )

            let jsonEncoder = JSONEncoder()
            jsonEncoder.outputFormatting = .prettyPrinted
            jsonEncoder.dateEncodingStrategy = .formatted(DateFormatter.dateOnly)
            let countryData: Data = try jsonEncoder.encode(country)
            let countryFileUrl = URL(fileURLWithPath: countriesFilePath).appendingPathComponent("\(country.isoCode).json")

            print("Fetched data: \(String(data: countryData, encoding: .utf8)!)")
            if !FileManager.default.fileExists(atPath: countryFileUrl.deletingLastPathComponent().path) {
                try FileManager.default.createDirectory(
                    atPath: countryFileUrl.deletingLastPathComponent().path,
                    withIntermediateDirectories: true,
                    attributes: nil
                )
            }

            if !FileManager.default.fileExists(atPath: countryFileUrl.path) {
                FileManager.default.createFile(atPath: countryFileUrl.path, contents: nil, attributes: nil)
            }

            try countryData.write(to: countryFileUrl)
            print("Public Holidays for \(country.isoCode) updated successfully!")
        }
    }
}

Import.main()
