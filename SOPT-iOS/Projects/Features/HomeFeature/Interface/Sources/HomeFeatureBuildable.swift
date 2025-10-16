//
//  HomeFeatureBuildable.swift
//  HomeFeatureInterface
//
//  Created by Jae Hyun Lee on 5/5/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import Core
import BaseFeatureDependency

public protocol HomeFeatureBuildable {
    func makeHomeForMember(coordinator: Coordinator) -> HomeForMemberPresentable
    func makeHomeForVisitor(coordinator: Coordinator) -> HomeForVisitorPresentable
    func makeHomeCalendarDetail() -> HomeCalendarDetailPresentable
}
