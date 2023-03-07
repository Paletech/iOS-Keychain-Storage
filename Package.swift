// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Keychain-Storage",
    products: [
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
