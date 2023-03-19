//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by 양수빈 on 2022/10/13.
//

import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.makeModule(
    name: "DSKit",
    targets: [.unitTest, .demo, .dynamicFramework],
    internalDependencies: [
        .core
    ],
    hasResources: true
)
