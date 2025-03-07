//
//  AuthFeatureBuildable.swift
//  AuthFeature
//
//  Created by 장석우 on 3/7/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import Foundation

public protocol AuthFeatureViewBuildable_Refactor: AuthFeatureViewBuildable {
    func makeLoginHelpBottomSheet() -> LoginHelpBottomSheetPresentable
    func makeUserNotFound() -> UserNotFoundPresentable
}
