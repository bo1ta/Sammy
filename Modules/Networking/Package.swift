// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Networking",
    platforms: [.iOS(.v17), .macOS(.v13)],
    products: [
        .library(
            name: "Networking",
            targets: ["Networking"]),
    ],
    dependencies: [.package(name: "Models", path: "../Models")],
    targets: [
        .target(
            name: "Networking",
            dependencies: [
                .product(name: "Models", package: "Models"),
            ]),
        .testTarget(
            name: "NetworkingTests",
            dependencies: ["Networking"],
            resources: [
                .process("Supporting Files"),
            ]),
    ])
