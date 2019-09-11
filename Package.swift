// swift-tools-version:5.0

import PackageDescription

let package = Package(
    name: "StatefulViewController",
    platforms: [
        .macOS(.v10_12),
        .iOS(.v11),
        .tvOS(.v11),
        .watchOS(.v3)
    ],
    products: [
        .library(name: "StatefulViewController", targets: ["StatefulViewController"])
    ],
    dependencies: [
    ],
    targets: [
        .target(name: "StatefulViewController", dependencies: [], path: "StatefulViewController/"),
        .testTarget(name: "StatefulViewControllerTests", dependencies: [], path: "StatefulViewControllerTests/")
    ],
    swiftLanguageVersions: [.v5]
)
