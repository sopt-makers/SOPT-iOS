//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by sejin on 2022/10/02.
//

import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.makeModule(
    name: "ThirdPartyLibs",
    targets: [.dynamicFramework],
    externalDependencies: [
        .SPM.Alamofire,
        .SPM.SnapKit,
        .SPM.Kingfisher,
        .SPM.Then,
        .SPM.Moya,
        .SPM.CombineMoya,
        .SPM.lottie,
        .SPM.Amplitude,
        .SPM.FirebaseCore,
        .SPM.FirebaseRemoteConfig,
        .SPM.FirebaseCrashlytics,
        .SPM.FirebaseAnalytics
    ]
)
