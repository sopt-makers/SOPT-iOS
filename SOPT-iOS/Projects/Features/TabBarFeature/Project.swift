//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by yungu0010 on 02/20/25.
//

import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.makeModule(
    name: "TabBarFeature",
    targets: [.unitTest, .staticFramework, .demo, .interface],
    interfaceDependencies: [
        .Features.Web.Feature
    ]
)
