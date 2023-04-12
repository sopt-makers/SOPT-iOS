//
//  SignInRepositoryInterface.swift
//  Domain
//
//  Created by devxsby on 2022/12/01.
//  Copyright © 2022 SOPT-Stamp-iOS. All rights reserved.
//

import Combine

// TODO: - User 유형 설정 방식 생각하기

public protocol SignInRepositoryInterface {
    func requestSignIn(token: String) -> AnyPublisher<Bool, Never>
}
