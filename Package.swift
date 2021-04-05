// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "GameKitService.swift",
    platforms: [ .iOS(SupportedPlatform.IOSVersion.v13),
                 .macOS(SupportedPlatform.MacOSVersion.v10_15),
                 .tvOS(SupportedPlatform.TVOSVersion.v13),
                 .watchOS(SupportedPlatform.WatchOSVersion.v6)
    ],
    products: [
        .library(
            name: "GameKitService",
            targets: ["GameKitService"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "GameKitService",
            dependencies: []),
        .testTarget(
            name: "GameKitServiceTests",
            dependencies: ["GameKitService"]),
    ]
)
