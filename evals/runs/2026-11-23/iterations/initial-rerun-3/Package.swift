// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "NotificationSettings",
    platforms: [.macOS(.v14), .iOS(.v17)],
    products: [
        .library(name: "NotificationSettings", targets: ["NotificationSettings"])
    ],
    targets: [
        .target(name: "NotificationSettings"),
        .testTarget(name: "NotificationSettingsTests", dependencies: ["NotificationSettings"])
    ]
)
