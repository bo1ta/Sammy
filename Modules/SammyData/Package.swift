// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SammyData",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(
            name: "SammyData",
            targets: ["SammyData"]),
    ],
    dependencies: [
        .package(name: "Models", path: "../Models"),
        .package(name: "Storage", path: "../Storage"),
        .package(name: "Networking", path: "../Networking"),
        .package(url: "https://github.com/hmlongco/Factory", exact: "2.4.11"),
    ],
    targets: [
        .target(
            name: "SammyData", dependencies: [
                "Storage", "Models", "Networking", "Factory"
            ]),
        .testTarget(
            name: "SammyDataTests",
            dependencies: ["SammyData"]
        ),
    ]
)
