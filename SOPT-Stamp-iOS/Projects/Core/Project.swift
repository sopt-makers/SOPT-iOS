//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by sejin on 2022/10/02.
//

import ProjectDescription
import ProjectDescriptionHelpers
import UtilityPlugin

let project = Project.makeModule(
    name: "Core",
    product: .staticFramework,
    dependencies: [
        .Project.ThirdPartyLib
    ]
)
