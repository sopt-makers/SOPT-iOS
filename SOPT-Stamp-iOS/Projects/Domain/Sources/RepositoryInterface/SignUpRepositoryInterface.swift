//
//  SignUpRepositoryInterface.swift
//  Domain
//
//  Created by sejin on 2022/11/28.
//  Copyright © 2022 SOPT-Stamp-iOS. All rights reserved.
//

import Combine

public protocol SignUpRepositoryInterface {
    func getNicknameAvailable(nickname: String) -> AnyPublisher<Bool, Error>
    func getEmailAvailable(email: String) -> AnyPublisher<Bool, Error>
    func postSignUp(signUpModel: SignUpModel) -> AnyPublisher<Bool, Error>
}
