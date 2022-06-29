// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "FlowStackLayout",
    platforms: [.iOS(.v16), .macCatalyst(.v16), .macOS(.v13), .tvOS(.v16), .watchOS(.v9)],
    products: [
        .library(
            name: "FlowStackLayout",
            targets: ["FlowStackLayout"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "FlowStackLayout",
            dependencies: [])
    ]
)
