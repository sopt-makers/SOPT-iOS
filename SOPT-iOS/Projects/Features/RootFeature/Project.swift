//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by 김영인 on 2023/03/15.
//

import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.makeModule(
    name: "RootFeature",
    targets: [.unitTest, .staticFramework, .demo],
    internalDependencies: [
        .Features.Main.Feature,
        .Features.Spalsh.Feature,
        .Features.Auth.Feature,
        .Features.Setting.Feature,
        .Features.Stamp.Feature,
        .Features.Attendance.Feature,
        .Features.Notice.Feature
    ]
)
