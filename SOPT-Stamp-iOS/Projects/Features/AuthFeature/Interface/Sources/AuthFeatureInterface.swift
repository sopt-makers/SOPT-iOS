//
//  AuthFeatureInterface.swift
//  AuthFeatureInterface
//
//  Created by 김영인 on 2023/03/17.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import BaseFeatureDependency

public protocol AuthFeatureInterface: ViewRepresentable { }

public protocol AuthFeature {
    func makeSignInVC() -> AuthFeatureInterface
//    func makeFindAccountVC() -> AuthFeatureInterface
//    func makeSignUpVC() -> AuthFeatureInterface
//    func makeSignUpCompleteVC() -> AuthFeatureInterface
}
