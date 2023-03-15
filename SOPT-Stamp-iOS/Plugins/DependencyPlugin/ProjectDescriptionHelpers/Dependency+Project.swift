//
//  Dependency+Project.swift
//  ProjectDescriptionHelpers
//
//  Created by sejin on 2022/10/02.
//

import ProjectDescription

public extension Dep {
    struct Features {
        public struct Main {}
        public struct Spalsh {}
        public struct OnBoarding {}
        public struct Auth {}
        public struct Stamp {}
        public struct Attendance {}
        public struct Notice {}
    }
    
    struct Modules {}
}

// MARK: - Root

public extension Dep {
    static let data = Dep.project(target: "Data", path: .data)

    static let domain = Dep.project(target: "Domain", path: .domain)
    
    static let core = Dep.project(target: "Core", path: .core)
}

// MARK: - Modules

public extension Dep.Modules {
    static let dsKit = Dep.project(target: "DSKit", path: .relativeToModules("DSKit"))
    
    static let network = Dep.project(target: "Network", path: .relativeToModules("Network"))
    
    static let thirdPartyLibs = Dep.project(target: "ThirdPartyLibs", path: .relativeToModules("ThirdPartyLibs"))
}

// MARK: - Features

public extension Dep.Features {
    static func project(name: String, group: String) -> Dep { .project(target: "\(group)\(name)", path: .relativeToFeature("\(group)\(name)")) }
    
    static let BaseFeatureDependency = TargetDependency.project(target: "BaseFeatureDependency", path: .relativeToFeature("BaseFeatureDependency"))
    
    static let RootFeature = TargetDependency.project(target: "RootFeature", path: .relativeToFeature("RootFeature"))
}

public extension Dep.Features.Main {
    static let group = "Main"
    
    static let Feature = Dep.Features.project(name: "Feature", group: group)
    static let Interface = Dep.project(target: "\(group)FeatureInterface", path: .relativeToFeature("\(group)Feature"))
}

public extension Dep.Features.Spalsh {
    static let group = "Splash"
    
    static let Feature = Dep.Features.project(name: "Feature", group: group)
    static let Interface = Dep.project(target: "\(group)FeatureInterface", path: .relativeToFeature("\(group)Feature"))
}
