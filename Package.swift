// swift-tools-version:5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "swift-run-environment",
    platforms: [
        .macOS(.v10_13),
        .iOS(.v9),
        .tvOS(.v9),
        .watchOS(.v2)
    ],
    products: [
        .library(name: "RunEnvironment", targets: ["RunEnvironment"]),
    ],
    targets: [
        .target(name: "RunEnvironment", dependencies: [], path: "Sources"),
        .testTarget(name: "RunEnvironmentTests", dependencies: ["RunEnvironment"], path: "Tests"),
    ]
)
