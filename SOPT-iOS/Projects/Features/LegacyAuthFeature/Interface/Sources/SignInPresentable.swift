//
//  AuthFeatureViewControllable.swift
//  AuthFeatureInterface
//
//  Created by 김영인 on 2023/03/17.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import BaseFeatureDependency
import Core
import Domain

public protocol LegacySignInViewControllable: LegacyViewControllable {
    var skipAnimation: Bool { get set }
    var accessCode: String? { get set }
    var requestState: String? { get set }
}

public protocol LegacySignInCoordinatable {
    var onSignInSuccess: ((SiginInHandleableType) -> Void)? { get set }
    var onVisitorButtonTapped: (() -> Void)? { get set }
}

public typealias LegacySignInViewModelType = ViewModelType & LegacySignInCoordinatable
public typealias LegacySignInPresentable = (vc: LegacySignInViewControllable, vm: any LegacySignInViewModelType)
