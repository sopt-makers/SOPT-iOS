//
//  HomeFeatureBuildable.swift
//  HomeFeatureInterface
//
//  Created by Jae Hyun Lee on 11/22/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import Core

public protocol HomeFeatureBuildable {
    func makeHomeForMember() -> HomeForMemberPresentable
    func makeHomeForVisitor() -> HomeForVisitorPresentable
    func makeHomeCalendarDetail() -> HomeCalendarDetailPresentable
}
