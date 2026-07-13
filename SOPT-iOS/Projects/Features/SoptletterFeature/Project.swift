//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by yungu0010 on 05/11/26.
//

import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.makeModule(
    name: "SoptletterFeature",
    targets: [.unitTest, .staticFramework, .demo, .interface],
    internalDependencies: [
        .Features.Web.Feature
    ],
    interfaceDependencies: [
        .Features.BaseFeatureDependency
    ]
)
