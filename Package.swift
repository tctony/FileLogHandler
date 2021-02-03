// swift-tools-version:5.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "FileLogHandler",
    products: [
        .library(
            name: "FileLogHandler",
            targets: ["FileLogHandler"]),
    ],
    dependencies: [
        .package(url: "https://github.com/tctony/SwiftLogFormatter", .exact("0.1.0")),
    ],
    targets: [
        .target(
            name: "FileLogHandler",
            dependencies: [
                .product(name: "LogFormatter", package: "SwiftLogFormatter"),
            ]),
        .testTarget(
            name: "FileLogHandlerTests",
            dependencies: ["FileLogHandler"]),
    ]
)
