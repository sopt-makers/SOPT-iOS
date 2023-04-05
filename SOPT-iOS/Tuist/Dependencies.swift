//
//  Dependencies.swift
//  Config
//
//  Created by sejin on 2022/10/02.
//

import ProjectDescription
import ProjectDescriptionHelpers

import ConfigPlugin

let spm = SwiftPackageManagerDependencies([
    .remote(url: "https://github.com/SnapKit/SnapKit.git", requirement: .upToNextMinor(from: "5.0.0")),
    .remote(url: "https://github.com/Moya/Moya.git", requirement: .upToNextMajor(from: "15.0.0")),
    .remote(url: "https://github.com/devxoul/Then", requirement: .upToNextMajor(from: "2")),
    .remote(url: "https://github.com/onevcat/Kingfisher.git", requirement: .upToNextMajor(from: "7.0.0")),
    .remote(url: "https://github.com/FLEXTool/FLEX.git", requirement: .upToNextMajor(from: "4.3.0")),
    .remote(url: "https://github.com/krzysztofzablocki/Inject.git", requirement: .upToNextMajor(from: "1.0.5")),
    .remote(url: "https://github.com/Quick/Quick.git", requirement: .upToNextMajor(from: "5.0.0")),
    .remote(url: "https://github.com/Quick/Nimble.git", requirement: .upToNextMajor(from: "10.0.0")),
    .remote(url: "https://github.com/airbnb/lottie-ios", requirement: .upToNextMajor(from: "3.0.0"))
], baseSettings: Settings.settings(
    configurations: XCConfig.framework
))

let dependencies = Dependencies(
    carthage: [],
    swiftPackageManager: spm,
    platforms: [.iOS]
)
