// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let version = "9.0.4"

enum Checksums {
    static let iDenfyInternalLoggerChecksum = "4cb5543b81dafd68562c5202dd339034aa9d4b8b0fb65744e044b57976c009b1"
    static let idenfyviewsChecksum = "93a92a5f723f6f469575a1667c18b519535b4df5416f8a7548a5366bb06552b3"
    static let iDenfySDKChecksum = "e4dc910cef678e59de8f678673716627d0411b6971f31092d3034784539183cc"
    static let idenfycoreChecksum = "0fbf918ccd9f0b435ec7ddf33fce98b4485407c384a48884f2d053fa18f36445"
}

let package = Package(
    name: "iDenfySDK",
    platforms: [.iOS(.v13)],
    products: [
        .library(
            name: "iDenfySDK-Dynamic",
            type: .dynamic,
            targets: ["iDenfySDKTarget"]),
        .library(
            name: "iDenfySDK",
            targets: ["iDenfySDKTarget"]),
    ],
    dependencies: [
        .package(url: "https://github.com/airbnb/lottie-spm.git", from: "4.5.0"),
    ],
    targets: [
        //IdenfyViews
        .target(
            name: "idenfyviewsTarget",
            dependencies: [.target(name: "idenfyviewsWrapper",
                                   condition: .when(platforms: [.iOS]))],
            path: "SwiftPM-PlatformExclude/idenfyviewsWrap"
        ),
        .target(
            name: "idenfyviewsWrapper",
            dependencies: [
                .target(
                    name: "idenfyviews",
                    condition: .when(platforms: [.iOS])
                ),
                .target(name: "idenfycore",
                        condition: .when(platforms: [.iOS])),
                .product(name: "Lottie",
                         package: "lottie-spm",
                         condition: .when(platforms: [.iOS])),
            ],
            path: "idenfyviewsWrapper"
        ),
        //iDenfySDK
        .target(
            name: "iDenfySDKTarget",
            dependencies: [.target(name: "iDenfySDKWrapper",
                                   condition: .when(platforms: [.iOS]))],
            path: "SwiftPM-PlatformExclude/iDenfySDKWrap",
            cSettings: [
                .define("CLANG_MODULES_AUTOLINK", to: "YES")
            ]
        ),
        .target(
            name: "iDenfySDKWrapper",
            dependencies: [
                .target(
                    name: "iDenfySDK",
                    condition: .when(platforms: [.iOS])),
                .product(name: "Lottie",
                         package: "lottie-spm",
                         condition: .when(platforms: [.iOS])),
                .target(name: "idenfycore",
                        condition: .when(platforms: [.iOS])),
                .target(name: "iDenfyInternalLogger",
                        condition: .when(platforms: [.iOS])),
                .target(name: "idenfyviewsTarget",
                        condition: .when(platforms: [.iOS])),
            ],
            path: "iDenfySDKWrapper"
        ),
        // Binaries
        .binaryTarget(name: "iDenfyInternalLogger",
                      url: "https://s3.eu-west-1.amazonaws.com/prod-ivs-sdk.builds/ios-sdk/\(version)/spm/IdenfySDK/iDenfyInternalLogger.zip", checksum: Checksums.iDenfyInternalLoggerChecksum),
        .binaryTarget(name: "idenfyviews",
                      url: "https://s3.eu-west-1.amazonaws.com/prod-ivs-sdk.builds/ios-sdk/\(version)/spm/IdenfySDK/idenfyviews.zip", checksum: Checksums.idenfyviewsChecksum),
        .binaryTarget(name: "iDenfySDK",
                      url: "https://s3.eu-west-1.amazonaws.com/prod-ivs-sdk.builds/ios-sdk/\(version)/spm/IdenfySDK/iDenfySDK.zip", checksum: Checksums.iDenfySDKChecksum),
        .binaryTarget(name: "idenfycore",
                      url: "https://s3.eu-west-1.amazonaws.com/prod-ivs-sdk.builds/ios-sdk/\(version)/spm/IdenfySDK/idenfycore.zip", checksum: Checksums.idenfycoreChecksum),
    ]
)
