//
//  LegacyHomeFeatureBuildable.swift
//  HomeFeatureInterface
//
//  Created by Jae Hyun Lee on 11/22/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import Core
import BaseFeatureDependency

public protocol LegacyHomeFeatureBuildable {
    func makeHomeForMember(coordinator: Coordinator) -> LegacyHomeForMemberPresentable
    func makeHomeForVisitor(coordinator: Coordinator) -> LegacyHomeForVisitorPresentable
    func makeHomeCalendarDetail() -> LegacyHomeCalendarDetailPresentable
}
