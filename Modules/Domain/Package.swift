// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Domain",
    platforms: [
        .iOS(.v17),
    ],
    products: [
        .library(
            name: "Domain",
            targets: ["Domain"]),
    ],
    dependencies: [
        .package(name: "Models", path: "../Models"),
        .package(name: "Storage", path: "../Storage"),
        .package(name: "Networking", path: "../Networking"),
        .package(url: "https://github.com/hmlongco/Factory", exact: "2.5.3"),
    ],
    targets: [
        .target(
            name: "Domain", dependencies: [
                "Storage", "Models", "Networking", "Factory",
            ]),
        .testTarget(
            name: "DomainTests",
            dependencies: ["Domain"]),
    ])
