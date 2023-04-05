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
    name: "Core",
    targets: [.unitTest, .dynamicFramework, .demo],
    internalDependencies: [
        .Modules.thirdPartyLibs
    ]
)
