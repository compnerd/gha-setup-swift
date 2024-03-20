// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "gha-setup-swift",
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "gha-setup-swift",
            targets: ["gha-setup-swift"]),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
          name: "gha-setup-swift", dependencies: ["CPlusPlusLibrary", "CLibrary"]),

        .target(name: "CLibrary"),
        .target(name: "CPlusPlusLibrary", dependencies: ["CLibrary"]),

        .testTarget(
            name: "gha-setup-swiftTests",
            dependencies: ["gha-setup-swift", "CPlusPlusLibrary"]),
    ]
)
