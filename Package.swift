// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MedTracker",
    dependencies: [
        .package(url: "https://github.com/swhitty/FlyingFox.git", from: "0.14.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .executableTarget(
            name: "MedTracker",
            dependencies: [
                .product(name: "FlyingFox", package: "FlyingFox")
            ]
        ),
    ]
)
