//
//  Dependency-SPM.swift
//  Config
//
//  Created by sejin on 2022/10/02.
//

import ProjectDescription

public extension TargetDependency {
    enum SPM {}
    enum Carthage {}
}

public extension TargetDependency.SPM {
    static let SnapKit = TargetDependency.external(name: "SnapKit")
    static let Then = TargetDependency.external(name: "Then")
    static let Kingfisher = TargetDependency.external(name: "Kingfisher")
    static let Moya = TargetDependency.external(name: "Moya")
    static let CombineMoya = TargetDependency.external(name: "CombineMoya")
    static let FLEX = TargetDependency.external(name: "FLEX")
    static let Inject = TargetDependency.external(name: "Inject")
    static let Nimble = TargetDependency.external(name: "Nimble")
    static let Quick = TargetDependency.external(name: "Quick")
    static let lottie = TargetDependency.external(name: "Lottie")
}

public extension TargetDependency.Carthage {
    static let Sentry = TargetDependency.external(name: "Sentry")
}
