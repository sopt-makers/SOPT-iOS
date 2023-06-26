//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by 김영인 on 2023/03/15.
//

import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.makeModule(
    name: "MainFeature",
    targets: [.unitTest, .staticFramework, .demo, .interface],
    interfaceDependencies: [
        .Features.BaseFeatureDependency
    ]
)
