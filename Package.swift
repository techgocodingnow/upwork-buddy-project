// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "UpworkBuddy",
    platforms: [
        .macOS(.v14)
    ],
    products: [
        .executable(name: "UpworkBuddy", targets: ["UpworkBuddy"])
    ],
    targets: [
        .executableTarget(
            name: "UpworkBuddy",
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
