//
//  Project.swift
//  Manifests
//
//  Created by Jae Hyun Lee on 11/19/24.
//

import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.makeModule(
    name: "HomeFeature",
    targets: [.unitTest, .staticFramework, .demo, .interface],
    interfaceDependencies: [
        .Features.Web.Feature
    ]
)
