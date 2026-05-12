// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "UpworkBuddy",
    defaultLocalization: "en",
    platforms: [
        .macOS(.v14)
    ],
    products: [
        .executable(name: "UpworkBuddy", targets: ["UpworkBuddy"])
    ],
    dependencies: [
        .package(url: "https://github.com/sparkle-project/Sparkle", from: "2.6.0"),
        .package(url: "https://github.com/twostraws/Vortex", from: "1.0.0")
    ],
    targets: [
        .executableTarget(
            name: "UpworkBuddy",
            dependencies: [
                .product(name: "Sparkle", package: "Sparkle"),
                .product(name: "Vortex", package: "Vortex")
            ],
            path: "Sources/UpworkBuddy",
            exclude: ["Resources/Config.example.plist", "Resources/AppIcon.iconset", "Info.plist"],
            resources: [
                .process("Resources")
            ],
            swiftSettings: [
                .enableUpcomingFeature("StrictConcurrency")
            ]
        ),
        .testTarget(
            name: "UpworkBuddyTests",
            dependencies: ["UpworkBuddy"],
            path: "Tests/UpworkBuddyTests"
        )
    ]
)
