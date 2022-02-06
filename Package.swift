  // swift-tools-version:5.5
import PackageDescription

let package = Package(
  name: "TodoListServer",
  platforms: [
    .macOS(.v10_15)
  ],
  dependencies: [
    // 💧 A server-side Swift web framework.
    .package(url: "https://github.com/vapor/vapor.git", from: "4.0.0"),
    .package(url: "https://github.com/vapor/fluent.git", from: "4.0.0"),
    .package(url: "https://github.com/vapor/fluent-postgres-driver.git", from: "2.0.0"),
    .package(url: "https://github.com/vapor/leaf.git", from: "4.0.0"),
    .package(name: "HTMLKit", url: "https://github.com/vapor-community/HTMLKit.git", from: "2.4.3"),
    .package(name: "HTMLKitComponents", url: "https://github.com/vapor-community/HTMLKit-Components.git", branch: "main"),
    .package(name: "HTMLKitVaporProvider", url: "https://github.com/vapor-community/htmlkit-vapor-provider.git", from: "1.2.1"),
  ],
  targets: [
    .target(
      name: "App",
      dependencies: [
        .product(name: "Fluent", package: "fluent"),
        .product(name: "FluentPostgresDriver", package: "fluent-postgres-driver"),
        .product(name: "Leaf", package: "leaf"),
        .product(name: "Vapor", package: "vapor"),
        .product(name: "HTMLKit", package: "HTMLKit"),
        .product(name: "HTMLKitComponents", package: "HTMLKitComponents"),
        .product(name: "HTMLKitVaporProvider", package: "HTMLKitVaporProvider"),
      ],
      swiftSettings: [
        // Enable better optimizations when building in Release configuration. Despite the use of
        // the `.unsafeFlags` construct required by SwiftPM, this flag is recommended for Release
        // builds. See <https://github.com/swift-server/guides/blob/main/docs/building.md#building-for-production> for details.
        .unsafeFlags(["-cross-module-optimization"], .when(configuration: .release))
      ]
    ),
    .executableTarget(name: "Run", dependencies: [.target(name: "App")]),
    .testTarget(name: "AppTests", dependencies: [
      .target(name: "App"),
      .product(name: "XCTVapor", package: "vapor"),
    ])
  ]
)
