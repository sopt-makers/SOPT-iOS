//
//  UserNotFoundBuildable.swift
//  AuthFeatureInterface
//
//  Created by 장석우 on 10/26/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import Foundation

import UIKit
import BaseFeatureDependency

public protocol UserNotFoundViewControllable: UIViewController {
    var onLoginHelpButtonTapped: (() -> Void)? { get set }
    var onLoginRetryButtonTapped: (() -> Void)? { get set }
}

public typealias UserNotFoundPresentable = UserNotFoundViewControllable
