// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "NuatisFinance",
    platforms: [
        .macOS(.v14)
    ],
    products: [
        .executable(
            name: "NuatisFinanceApp",
            targets: ["NuatisFinanceApp"]
        )
    ],
    targets: [
        .executableTarget(
            name: "NuatisFinanceApp",
            path: "Sources/NuatisFinanceApp",
            resources: [
                .copy("FinanceApp/Resources")
            ]
        ),

        .testTarget(
            name: "NuatisFinanceTests",
            dependencies: ["NuatisFinanceApp"],
            path: "Tests/NuatisFinanceTests"
        )
    ]
)
