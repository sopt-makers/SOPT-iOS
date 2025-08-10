//
//  SearchSocialAccount.swift
//  AuthFeature
//
//  Created by 장석우 on 6/3/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import BaseFeatureDependency
import Core
import Domain

public protocol SearchSocialAccountViewControllable: LegacyViewControllable { }

public protocol SearchSocialAccountCoordinatable {
    var searchSocialAccountSucceed: ((OAuthProvider) -> Void)? { get set }
}

public typealias SearchSocialAccountViewModelType = ViewModelType & SearchSocialAccountCoordinatable

public typealias SearchSocialAccountPresentable = (vc: SearchSocialAccountViewControllable, vm: any SearchSocialAccountViewModelType)
