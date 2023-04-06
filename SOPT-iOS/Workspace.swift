//
//  Workspace.swift
//  ProjectDescriptionHelpers
//
//  Created by sejin on 2022/10/02.
//

import ProjectDescription
import EnvPlugin

let workspace = Workspace(
    name: Environment.workspaceName,
    projects: [
        "Projects/**"
    ]
)
