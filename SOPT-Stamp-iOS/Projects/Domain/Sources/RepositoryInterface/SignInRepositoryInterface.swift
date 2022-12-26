//
//  SignInRepositoryInterface.swift
//  Domain
//
//  Created by devxsby on 2022/12/01.
//  Copyright © 2022 SOPT-Stamp-iOS. All rights reserved.
//

import Combine

public protocol SignInRepositoryInterface {
    func requestSignIn(request: SignInRequest) -> AnyPublisher<SignInModel, Error>
}
