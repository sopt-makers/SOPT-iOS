//
//  AuthFeatureBuildable.swift
//  AuthFeatureInterface
//
//  Created by Junho Lee on 2023/06/20.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Foundation

public protocol AuthFeatureViewBuildable {
    func makeSignIn() -> SignInPresentable
    func makeLoginHelpBottomSheet() -> LoginHelpBottomSheetPresentable
    func makeUserNotFound() -> UserNotFoundPresentable
}
