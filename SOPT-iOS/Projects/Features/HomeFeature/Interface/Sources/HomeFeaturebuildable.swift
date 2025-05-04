//
//  HomeFeaturebuildable.swift
//  HomeFeatureInterface
//
//  Created by Jae Hyun Lee on 5/5/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import Core

public protocol HomeFeaturebuildable {
    func makeHomeForMember() -> HomeForMemberPresentable
    func makeHomeForVisitor() -> HomeForVisitorPresentable
    func makeHomeCalendarDetail() -> HomeCalendarDetailPresentable
}
