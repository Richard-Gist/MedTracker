// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MedTracker",
    platforms: [
        .macOS(.v10_15),
    ],
    products: [
        .executable(name: "MedTrackerWin", targets: ["MedTrackerWin"]),
        .executable(name: "MedTrackerLinux", targets: ["MedTrackerLinux"]),
        .executable(name: "MedTrackerCLI", targets: ["MedTrackerCLI"]),
    ],
    dependencies: [
        .package(path: "Vendor/swift-win32"),
        .package(url: "https://github.com/AparokshaUI/adwaita-swift", from: "0.1.0"),
        .package(url: "https://github.com/swhitty/FlyingFox.git", from: "0.14.0"),
    ],
    targets: [
        .target(
            name: "MedTrackerCore",
            dependencies: []
        ),
        .executableTarget(
            name: "MedTrackerWin",
            dependencies: [
                "MedTrackerCore",
                .product(name: "SwiftWin32", package: "swift-win32", condition: .when(platforms: [.windows])),
            ],
            path: "Sources/MedTrackerWin"
        ),
        .executableTarget(
            name: "MedTrackerLinux",
            dependencies: [
                "MedTrackerCore",
                .product(name: "Adwaita", package: "adwaita-swift", condition: .when(platforms: [.linux, .macOS])),
            ],
            path: "Sources/MedTrackerLinux",
            swiftSettings: [
                .unsafeFlags(["-parse-as-library"])
            ]
        ),
        .executableTarget(
            name: "MedTrackerCLI",
            dependencies: ["MedTrackerCore"],
            path: "Sources/MedTrackerCLI"
        ),
        .executableTarget(
            name: "MedTrackerServer",
            dependencies: [
                "MedTrackerCore",
                .product(name: "FlyingFox", package: "FlyingFox")
            ],
            path: "Sources/MedTrackerServer"
        ),
    ]
)
