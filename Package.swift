// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "TuganeDesign",
    platforms: [.macOS(.v14)],
    products: [
        .library(name: "TuganeDesign", targets: ["TuganeDesign"])
    ],
    targets: [
        .target(name: "TuganeDesign")
    ]
)
