// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Keychain-Storage",
    products: [
        .library(
            name: "KeychainStorage",
            targets: ["KeychainStorage"]),
        .library(
            name: "Sample",
            targets: ["Sample"]),
    ],
    
    dependencies: [
    ],
    
    targets: [
        .target(
            name: "KeychainStorage",
            dependencies: []),
        .testTarget(name: "KeychainStorageTests",
                    dependencies: ["KeychainStorage"]),
        .target(
            name: "Sample",
            dependencies: ["KeychainStorage"]),
    ]
)
