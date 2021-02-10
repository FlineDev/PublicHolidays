// swift-tools-version:5.3

import PackageDescription

let package = Package(
  name: "PublicHolidays",
  platforms: [.macOS(.v10_15)],
  products: [
    .library(name: "PublicHolidays", targets: ["PublicHolidays"]),
    .executable(name: "PublicHolidaysUpdater", targets: ["PublicHolidaysUpdater"]),
  ],
  dependencies: [
    // Simple way to identify what is different between 2 instances of any type. Must have for TDD.
    .package(name: "Difference", url: "https://github.com/krzysztofzablocki/Difference.git", .branch("master")),

    // Handy Swift features that didn't make it into the Swift standard library.
    .package(name: "HandySwift", url: "https://github.com/Flinesoft/HandySwift.git", from: "3.2.0"),

    // Micro version of the Moya network abstraction layer written in Swift.
    .package(name: "Microya", url: "https://github.com/Flinesoft/Microya.git", .branch("main")),

    // Straightforward, type-safe argument parsing for Swift
    .package(name: "swift-argument-parser", url: "https://github.com/apple/swift-argument-parser.git", from: "0.2.2"),
  ],
  targets: [
    .target(
      name: "PublicHolidays",
      dependencies: [
        "HandySwift"
      ],
      resources: [
        .copy("JsonData")
      ]
    ),
    .testTarget(
      name: "PublicHolidaysTests",
      dependencies: [
        "Difference",
        "PublicHolidays",
      ]
    ),
    .target(
      name: "PublicHolidaysUpdater",
      dependencies: [
        .product(name: "ArgumentParser", package: "swift-argument-parser"),
        "Microya",
        "PublicHolidays",
      ]
    ),
  ]
)
