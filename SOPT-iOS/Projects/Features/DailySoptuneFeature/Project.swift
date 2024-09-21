//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by Jae Hyun Lee on 9/21/24.
//

import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.makeModule(
    name: "DailySoptuneFeature",
    targets: [.unitTest, .staticFramework, .demo, .interface],
    interfaceDependencies: [
        .Features.BaseFeatureDependency
    ]
)

