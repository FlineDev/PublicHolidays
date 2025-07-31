import ArgumentParser
import Foundation
import Microya
import PublicHolidays

struct Import: ParsableCommand {
   func run() throws {
      let countriesFilePath = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
         .appendingPathComponent("Sources/PublicHolidays/JsonData").path

      print("Fetching list of all available countries")
      let apiProvider = ApiProvider<NagerDateClient>()
      let availableCountryResponses =
         try apiProvider.performRequestAndWait(on: .availableCountries, decodeBodyTo: [AvailableCountryResponse].self)
         .get()

      for availableCountry in availableCountryResponses {
         print("Fetching public holidays for years \(PublicHolidays.supportedYears) in '\(availableCountry.key)'")
         let publicHolidayResponses: [PublicHolidayResponse] = try PublicHolidays.supportedYears.reduce(into: []) {
            responses,
            yearToFetch in
            let responsesOfYearToFetch: [PublicHolidayResponse] =
               try apiProvider.performRequestAndWait(
                  on: .publicHolidays(
                     year: yearToFetch,
                     countryCode: availableCountry.key
                  ),
                  decodeBodyTo: [PublicHolidayResponse].self
               )
               .get()

            return responses.append(contentsOf: responsesOfYearToFetch)
         }

         let countrywidePublicHolidayResponses: [PublicHolidayResponse] = publicHolidayResponses.filter {
            $0.counties == nil || $0.counties!.isEmpty
         }
         let countrywidePublicHolidays = countrywidePublicHolidayResponses.map {
            PublicHoliday(localName: $0.localName, date: $0.date)
         }

         let territorialPublicHolidayResponses: [PublicHolidayResponse] = publicHolidayResponses.filter {
            $0.counties != nil && !$0.counties!.isEmpty
         }

         var subTerritoryCodes: Set<String> = []
         for response in publicHolidayResponses {
            if let countyCodes = response.counties {
               countyCodes.forEach { subTerritoryCodes.insert(String($0.split(separator: "-").last!)) }
            }
         }

         let subTerritories: [SubTerritory] = subTerritoryCodes.sorted()
            .map {
               let additionalPublicHolidays =
                  territorialPublicHolidayResponses
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
         jsonEncoder.dateEncodingStrategy = .formatted(DateFormatter.dateOnlyGMT)
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
         print("Successfully saved updated public holidays for \(country.isoCode) at: \(countryFileUrl.path)")
      }
   }
}

Import.main()
