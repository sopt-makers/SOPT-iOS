//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by sejin on 2023/06/12.
//

import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.makeModule(
    name: "NotificationFeature",
    targets: [.unitTest, .staticFramework, .demo, .interface],
    internalDependencies: [
    ],
    interfaceDependencies: [
        .Features.BaseFeatureDependency
    ]
)
