// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Formatter",
    platforms: [.macOS(.v13)],
    products: [
        .plugin(name: "Formatter", targets: ["Formatter"])
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/apple/swift-format", from: "0.50700.1")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        .plugin(
            name: "Formatter",
            capability: .command(
                intent: .sourceCodeFormatting(),
                permissions: [.writeToPackageDirectory(reason: "Apply formatting")]),
            dependencies: [.product(name: "swift-format", package: "swift-format")]
        )
    ]
)
