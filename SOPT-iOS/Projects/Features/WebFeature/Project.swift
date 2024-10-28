//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by 장석우 on 10/28/24.
//

import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.makeModule(
    name: "WebFeature",
    targets: [.dynamicFramework, .demo, .unitTest],
    internalDependencies: [
        .Features.BaseFeatureDependency
    ]
)
