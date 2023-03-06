// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "KeychainRoll",
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "iOS-Keychain-Storage",
            targets: ["iOS-Keychain-Storage"]),
    ],
    dependencies: [

    ],
    targets: [
        .target(
            name: "iOS-Keychain-Storage",
            dependencies: []),
    ]
)
