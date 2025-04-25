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
        .Features.Stamp.Feature,
        .Features.Attendance.Feature,
        .Features.Notice.Feature,
        .Features.AppMyPage.Feature,
        .Features.Notification.Feature,
        .Features.Poke.Feature,
        .Features.DailySoptune.Feature,
        .Features.Home.Feature,
        .Features.Soptlog.Feature,
    ]
)
