// swift-tools-version: 5.10.0

import PackageDescription

#if TUIST
import ProjectDescription

let xcconfigPath: ProjectDescription.Path = .relativeToRoot("xcconfigs/targets/iOS-Framework.xcconfig")
let packageSettings = PackageSettings(
    productTypes: [
        "SnapKit": .framework,
        "Moya": .framework,
        "Then": .framework,
        "Kingfisher": .framework,
        "FLEX": .framework,
        "Inject": .framework,
        "Quick": .framework,
        "Nimble": .framework,
        "Lottie": .framework,
        "AmplitudeSwift": .framework,
    ],
    baseSettings: .settings(
        configurations: [
            .debug(name: "Development", xcconfig: xcconfigPath),
            .debug(name: "Test", xcconfig: xcconfigPath),
            .release(name: "QA", xcconfig: xcconfigPath),
            .release(name: "PROD", xcconfig: xcconfigPath),
        ]
    )
)
#endif

let package = Package(
    name: "ExternalDependencies",
    platforms: [
        .iOS("16.0")
    ],
    dependencies: [
        .package(url: "https://github.com/SnapKit/SnapKit.git", from: "5.0.0"),
        .package(url: "https://github.com/Moya/Moya.git", from: "15.0.0"),
        .package(url: "https://github.com/devxoul/Then", from: "2.0.0"),
        .package(url: "https://github.com/onevcat/Kingfisher.git", from: "8.0.0"),
        .package(url: "https://github.com/FLEXTool/FLEX.git", from: "4.3.0"),
        .package(url: "https://github.com/krzysztofzablocki/Inject.git", from: "1.2.4"),
        .package(url: "https://github.com/Quick/Quick.git", from: "7.0.0"),
        .package(url: "https://github.com/Quick/Nimble.git", from: "12.0.0"),
        .package(url: "https://github.com/airbnb/lottie-ios", from: "4.5.0"),
        .package(url: "https://github.com/amplitude/Amplitude-Swift", from: "1.11.10"),
    ]
)
