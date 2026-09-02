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
        .Features.Spalsh.Feature,
        .Features.LegacyAuth.Feature,
        .Features.Auth.Feature,
        .Features.TabBar.Feature,
        .Features.Stamp.Feature,
        .Features.Attendance.Feature,
        .Features.AppMyPage.Feature,
        .Features.Notification.Feature,
        .Features.Poke.Feature,
        .Features.Home.Feature,
        .Features.Soptlog.Feature,
        .Features.Soptletter.Feature
    ]
)
