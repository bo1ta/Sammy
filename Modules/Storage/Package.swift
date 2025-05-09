// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Storage",
    platforms: [.iOS(.v17)],
    products: [
        .library(
            name: "Storage",
            targets: ["Storage"]),
    ],
    dependencies: [
        .package(url: "https://bitbucket.org/iam_apps/principle/src/master/Principle/", .upToNextMajor(from: "1.5.0")),
        .package(url: "https://github.com/hmlongco/Factory", exact: "2.4.11"),
        .package(name: "Models", path: "../Models"),
    ],
    targets: [
        .target(
            name: "Storage",
            dependencies: [
                "Principle",
                "Factory",
                .product(name: "Models", package: "Models"),
            ]),
        .testTarget(name: "StorageTests", dependencies: ["Storage"]),
    ])
