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
    name: "TestCore",
    targets: [.dynamicFramework],
    internalDependencies: [
        .core,
        .sdk(name: "XCTest", type: .framework, status: .required)
    ]
)
