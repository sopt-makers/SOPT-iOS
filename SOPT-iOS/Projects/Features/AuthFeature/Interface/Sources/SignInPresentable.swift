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

public protocol SignInViewControllable: ViewControllable {
    var skipAnimation: Bool { get set }
    var accessCode: String? { get set }
    var requestState: String? { get set }
}
public protocol SignInCoordinatable {
    var onSignInSuccess: ((SiginInHandleableType) -> Void)? { get set }
    var onVisitorButtonTapped: (() -> Void)? { get set }
}
public typealias SignInViewModelType = ViewModelType & SignInCoordinatable
public typealias SignInPresentable = (vc: SignInViewControllable, vm: any SignInViewModelType)
