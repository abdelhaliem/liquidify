// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "liquidify",
    platforms: [
        .iOS("16.0"),
        .macOS("10.15"),
    ],
    products: [
        .library(
            name: "liquidify",
            targets: ["liquidify"]
        ),
    ],
    dependencies: [
        .package(name: "FlutterFramework", path: "../FlutterFramework"),
    ],
    targets: [
        .target(
            name: "liquidify",
            dependencies: [
                .product(name: "FlutterFramework", package: "FlutterFramework"),
            ],
            path: "Sources/liquidify"
        ),
    ]
)
