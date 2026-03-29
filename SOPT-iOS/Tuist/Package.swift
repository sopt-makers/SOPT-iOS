// swift-tools-version: 5.10.0

import PackageDescription

#if TUIST
import ProjectDescription

let xcconfigPath: ProjectDescription.Path = .relativeToRoot("xcconfigs/targets/iOS-Framework.xcconfig")
let packageSettings = PackageSettings(
    productTypes: [
        "Alamofire": .framework,
        "GoogleSignIn": .framework,
        "GTMAppAuth": .framework,
        "AppAuth": .framework,
        "GULEnvironment": .framework,
        "GULLogger": .framework,
        "GULNSData": .framework,
        "GULNetwork": .framework,
        "GULUserDefaults": .framework,
        "GULReachability": .framework,
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
        .package(url: "https://github.com/Alamofire/Alamofire", from: "5.10.0"),
        .package(url: "https://github.com/SnapKit/SnapKit.git", from: "5.0.0"),
        .package(url: "https://github.com/Moya/Moya.git", from: "15.0.0"),
        .package(url: "https://github.com/devxoul/Then", from: "2.0.0"),
        .package(url: "https://github.com/onevcat/Kingfisher.git", from: "8.0.0"),
        .package(url: "https://github.com/airbnb/lottie-ios", from: "4.5.0"),
        .package(url: "https://github.com/amplitude/Amplitude-Swift", from: "1.11.10"),
        .package(url: "https://github.com/firebase/firebase-ios-sdk.git", from: "11.12.0"),
        .package(url: "https://github.com/google/GoogleSignIn-iOS.git", from: "9.0.0"),        
    ]
)
