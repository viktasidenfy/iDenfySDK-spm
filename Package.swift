// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let version = "7.9.0"

enum Checksums {
    static let iDenfyInternalLoggerChecksum = "0dbce96493b23e686672d0cd7176c36167ec9d51ad7fc7b5a70c58c18fb0ce55"
    static let idenfyviewsChecksum = "2b5e31c3a35dbeb87ced64d2958926f8c82a6dc5df556963766178ce4fa68750"
    static let iDenfySDKChecksum = "f4d3a57176062b11834f0ce65710429479190a6ea86470e1879426310c3d7a64"
    static let idenfycoreChecksum = "e662ec7cb8c5c9db08789a0298176cf91e2c5ae9a256ef05aea771901eead701"
    static let idenfyNFCReadingChecksum = "4c6ed6ffddbe30e69919074cde3dcdb02525c50db29d31820c445d875bd000b9"
    static let openSSLChecksum = "78e51ff6c0f7c33d590176fe1ffa8470d5a7384de1318c7ad91f2519c5ee5e9d"
}

let package = Package(
    name: "iDenfySDK",
    platforms: [.iOS(.v11)],
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
        .package(url: "https://github.com/airbnb/lottie-spm.git", "4.2.0"..<"4.2.1"),
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
        //IdenfyNFCReading
        .target(
            name: "idenfyNFCReadingTarget",
            dependencies: [.target(name: "idenfyNFCReadingWrapper",
                                   condition: .when(platforms: [.iOS]))],
            path: "SwiftPM-PlatformExclude/idenfyNFCReadingWrap"
        ),
        .target(
            name: "idenfyNFCReadingWrapper",
            dependencies: [
                .target(
                    name: "idenfyNFCReading",
                    condition: .when(platforms: [.iOS])
                ),
                .target(name: "OpenSSL",
                        condition: .when(platforms: [.iOS])),
            ],
            path: "idenfyNFCReadingWrapper"
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
                .target(name: "idenfyNFCReadingTarget",
                        condition: .when(platforms: [.iOS])),
                .target(name: "idenfyviewsTarget",
                        condition: .when(platforms: [.iOS])),
            ],
            path: "iDenfySDKWrapper"
        ),
        // Binaries
        .binaryTarget(name: "iDenfyInternalLogger",
                      url: "https://s3.eu-west-1.amazonaws.com/sdk.builds/ios-sdk/\(version)/spm/IdenfySDK/iDenfyInternalLogger.zip", checksum: Checksums.iDenfyInternalLoggerChecksum),
        .binaryTarget(name: "idenfyviews",
                      url: "https://s3.eu-west-1.amazonaws.com/sdk.builds/ios-sdk/\(version)/spm/IdenfySDK/idenfyviews.zip", checksum: Checksums.idenfyviewsChecksum),
        .binaryTarget(name: "iDenfySDK",
                      url: "https://s3.eu-west-1.amazonaws.com/sdk.builds/ios-sdk/\(version)/spm/IdenfySDK/iDenfySDK.zip", checksum: Checksums.iDenfySDKChecksum),
        .binaryTarget(name: "idenfycore",
                      url: "https://s3.eu-west-1.amazonaws.com/sdk.builds/ios-sdk/\(version)/spm/IdenfySDK/idenfycore.zip", checksum: Checksums.idenfycoreChecksum),
        .binaryTarget(name: "idenfyNFCReading",
                      url: "https://s3.eu-west-1.amazonaws.com/sdk.builds/ios-sdk/\(version)/spm/IdenfySDK/idenfyNFCReading.zip", checksum: Checksums.idenfyNFCReadingChecksum),
        .binaryTarget(name: "OpenSSL",
                      url: "https://s3.eu-west-1.amazonaws.com/sdk.builds/ios-sdk/\(version)/spm/IdenfySDK/OpenSSL.zip", checksum: Checksums.openSSLChecksum),
    ]
)
