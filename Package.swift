// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
	name: "SwiftyServer",
    platforms: [
       .macOS(.v10_14)
    ],
	products: [
		.executable(name: "ExampleServer", targets: ["ExampleServer"]),
		.library(name: "SwiftyServer", targets: ["SwiftyServer"])
	],
	dependencies: [
		.package(url: "https://github.com/apple/swift-nio", from: "2.0.0"),
		.package(url: "https://github.com/apple/swift-log", from: "1.0.0"),
		.package(url: "https://github.com/apple/swift-metrics.git", from: "1.0.0"),
		.package(url: "https://github.com/krzyzanowskim/CryptoSwift", from: "1.0.0"),
//		.package(url: "https://github.com/vapor/mysql-nio", .branch("master"))
		.package(url: "https://github.com/IBM-Swift/SwiftKueryMySQL.git", from: "2.0.0")
	],
	targets: [
		.target(name: "SwiftyServer", dependencies: ["NIO", "NIOHTTP1", "NIOConcurrencyHelpers", "SwiftKueryMySQL", "Logging", "Metrics"]),
		.target(name: "ExampleServer", dependencies: ["SwiftyServer", "CryptoSwift"])
	]
)
