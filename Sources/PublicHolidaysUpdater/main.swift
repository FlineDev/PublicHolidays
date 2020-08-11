import ArgumentParser
import Foundation
import PublicHolidays

struct Import: ParsableCommand {
    @Option(name: .shortAndLong, help: "Provide the path to the countries JSON data file.")
    var countriesFilePath: String

    @Option(name: .shortAndLong, help: "Provide the ISO country code to start updating from.")
    var offset: String?

    func run() throws {
        if !FileManager.default.fileExists(atPath: countriesFilePath) {
            let emptyCountriesData = try JSONEncoder().encode([Country]())
            FileManager.default.createFile(atPath: countriesFilePath, contents: emptyCountriesData, attributes: [:])
        }

        let countriesFileData = try Data(contentsOf: URL(fileURLWithPath: countriesFilePath))
        var countries = try JSONDecoder().decode([Country].self, from: countriesFileData)

        print("Found \(countries.count) countries in JSON file. Start updating ...")
        updateCountries(countries: &countries)

        let updatedCountriesData = try JSONEncoder().encode(countries)
        try updatedCountriesData.write(to: URL(fileURLWithPath: countriesFilePath))
    }

    private func updateCountries(countries: inout [Country]) {
        // TODO: [cg_2020-08-11] not yet implemented
    }
}

Import.main()
