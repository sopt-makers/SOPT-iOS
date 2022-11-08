//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by sejin on 2022/10/02.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: "Presentation",
    product: .staticFramework,
    dependencies: [
        .Project.Domain,
        .Project.DSKit
    ],
    hasTest: true
)
