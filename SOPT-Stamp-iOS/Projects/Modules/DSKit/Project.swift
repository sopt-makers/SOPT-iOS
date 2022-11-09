//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by 양수빈 on 2022/10/13.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: "DSKit",
    product: .staticFramework,
    dependencies: [
        .Project.Core
    ],
    resources: ["Resources/**"]
)
