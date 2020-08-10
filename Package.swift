// swift-tools-version:4.2

import PackageDescription

let package = Package(
    name: "PublicHolidays",
    products: [
        .library(name: "PublicHolidays", targets: ["PublicHolidays"]),
    ],
    dependencies: [
        // Handy Swift features that didn't make it into the Swift standard library.
        .package(url: "https://github.com/Flinesoft/HandySwift.git", from: "3.2.0"),

        // Micro version of the Moya network abstraction layer written in Swift.
        .package(url: "https://github.com/Flinesoft/Microya.git", from: "0.1.1"),
    ],
    targets: [
        .target(name: "PublicHolidays", dependencies: ["HandySwift", "Microya"]),
        .testTarget(name: "PublicHolidaysTests", dependencies: ["PublicHolidays"]),
    ]
)
