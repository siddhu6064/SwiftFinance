// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "SwiftFinance",
    platforms: [
        .macOS(.v14)
    ],
    products: [
        .executable(name: "SwiftFinanceApp", targets: ["SwiftFinanceApp"])
    ],
    targets: [
        .executableTarget(
            name: "SwiftFinanceApp",
            path: "Sources/SwiftFinanceApp",
            resources: [
                .copy("FinanceApp/Resources")
            ]
        )
    ]
)
