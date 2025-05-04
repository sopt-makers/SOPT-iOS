//
//  LegacyHomeFeatureBuildable.swift
//  HomeFeatureInterface
//
//  Created by Jae Hyun Lee on 11/22/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import Core

public protocol LegacyHomeFeatureBuildable {
    func makeHomeForMember() -> LegacyHomeForMemberPresentable
    func makeHomeForVisitor() -> LegacyHomeForVisitorPresentable
    func makeHomeCalendarDetail() -> LegacyHomeCalendarDetailPresentable
}
