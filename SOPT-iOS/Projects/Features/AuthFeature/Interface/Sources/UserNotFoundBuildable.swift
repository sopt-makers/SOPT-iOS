//
//  UserNotFoundBuildable.swift
//  AuthFeatureInterface
//
//  Created by 장석우 on 10/26/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import Foundation

import BaseFeatureDependency

public protocol UserNotFoundViewControllable: ViewControllable {
    var loginHelpButtonTapped: (() -> Void)? { get set }
    var loginRetryButtonTapped: (() -> Void)? { get set }
}

public typealias UserNotFoundPresentable = UserNotFoundViewControllable
