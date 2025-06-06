//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by Melt on 06/06/25.
//

import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.makeModule(
    name: "LegacyAuthFeature",
    targets: [.unitTest, .staticFramework, .demo, .interface],
    internalDependencies: [
    ],
    interfaceDependencies: [  
    ]
)
