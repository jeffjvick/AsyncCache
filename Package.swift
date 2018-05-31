// swift-tools-version:4.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AsyncCache",
    products: [
        .library(name: "AsyncCache", targets: ["AsyncCache"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "AsyncCache",
            dependencies: []),
        .testTarget(
            name: "AsyncCacheTests",
            dependencies: ["AsyncCache"]),
    ]
)
