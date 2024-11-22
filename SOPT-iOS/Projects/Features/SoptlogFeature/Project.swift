//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by 강윤서 on 11/22/24.
//

import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.makeModule(
    name: "SoptlogFeature",
    targets: [.unitTest, .staticFramework, .demo, .interface],
    interfaceDependencies: [
        .Features.Web.Feature
    ]
)
